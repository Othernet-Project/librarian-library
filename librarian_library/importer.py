import json
import logging
import os
import re
import uuid

import gevent
import scandir

from bottle_utils.common import unicode, to_bytes, to_unicode


ILLEGAL = re.compile(r'[\s!"#$%&\':()*\-/<=>?@\[\\\]^_`{|},.]+')
FIRST_CHAR = re.compile(r'\w{1}', re.UNICODE)
MAX_TITLE_LENGTH = 255


def find_content_dirs(basedir, meta_filenames, sleep_interval=0.01):
    for entry in scandir.scandir(basedir):
        if entry.is_dir():
            for child in find_content_dirs(entry.path, meta_filenames):
                yield child
        else:
            filename = os.path.basename(entry.path)
            if filename in meta_filenames:
                yield os.path.dirname(entry.path)
                # when it resumes, abort exploration of the current folder
                # since it got removed in the meantime
                break
    # force context switch
    gevent.sleep(sleep_interval)


def get_random_title():
    return uuid.uuid4().hex


def safe_title(source, delim=u' '):
    result = []
    for word in ILLEGAL.split(source):
        if word:
            result.append(word)
    return unicode(delim.join(result))


def read_meta(basedir, meta_filenames):
    meta = None
    for filename in meta_filenames:
        meta_path = os.path.join(basedir, filename)
        if os.path.exists(meta_path):
            try:
                with open(meta_path, 'r') as meta_file:
                    meta = json.load(meta_file)
            except Exception:
                continue

    return meta


def upgrade_meta(meta):
    meta['gen'] = 1
    meta['content'] = {
        'html': {
            'main': meta.pop('index', 'index.html'),
            'keep_formatting': meta.pop('keep_formatting', False)
        }
    }
    for ignored in ('images', 'multipage'):
        meta.pop(ignored, None)


def delete_old_meta(path, meta_filenames):
    if len(meta_filenames) > 1:
        for old_meta_filename in meta_filenames[1:]:
            old_meta_path = os.path.join(path, old_meta_filename)
            if os.path.exists(old_meta_path):
                os.remove(old_meta_path)


def import_content(srcdir, destdir, meta_filenames, fsal, notifications,
                   notifications_db):
    """Discover content directories under ``srcdir`` using the first generation
    folder structure and copy them into ``destdir``, while dropping the old
    nested structure and putting them into a single folder which name is
    generated from the slugified title of the content."""
    srcdir = os.path.abspath(srcdir)
    if not os.path.exists(srcdir):
        logging.info(u"Content directory: {0} does not exist.".format(srcdir))
        return

    logging.info(u"Starting content import of {0}".format(srcdir))
    added = 0
    for src_path in find_content_dirs(srcdir, meta_filenames):
        meta = read_meta(src_path, meta_filenames)
        if not meta:
            logging.error(u"Content import of {0} skipped. No valid metadata "
                          "was found.".format(src_path))
            continue  # metadata couldn't be found or read, skip this item
        # process and save the found metadata
        upgrade_meta(meta)
        meta_path = os.path.join(src_path, meta_filenames[0])
        with open(meta_path, 'w') as meta_file:
            json.dump(meta, meta_file)
        # delete any other meta files
        delete_old_meta(src_path, meta_filenames)
        # move content folder into library
        title = to_unicode(to_bytes(safe_title(meta['title']) or
                                    safe_title(meta['url']) or
                                    get_random_title())[:MAX_TITLE_LENGTH])
        match = FIRST_CHAR.search(title)
        first_letter = (match.group() if match else None) or title[0]
        dest_path = os.path.join(destdir, first_letter.upper(), title)
        if not fsal.exists(dest_path, unindexed=True):
            (success, error) = fsal.transfer(src_path, dest_path)
            if not success:
                logging.error(u"Content import of {0} failed with "
                              "{1}".format(src_path, error))
                continue
            # adding to database will happen when we're notified by fsal about
            # the event
            added += 1

    success_msg = "{0} content items imported from {1}.".format(added, srcdir)
    logging.info(success_msg)
    notifications.send(success_msg, db=notifications_db)

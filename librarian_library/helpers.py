"""
helpers.py: librarian core helper functions

Copyright 2014-2015, Outernet Inc.
Some rights reserved.

This software is free software licensed under the terms of GPLv3. See COPYING
file that comes with the source code, or http://www.gnu.org/licenses/gpl.txt.
"""

import os

from urlparse import urljoin

from bottle import request
from bottle_utils.common import unicode
from bottle_utils.html import set_qparam
from bottle_utils.i18n import i18n_url

from librarian_content.library.archive import Archive
from librarian_core.contrib.cache.decorators import cached
from librarian_core.contrib.templates.decorators import template_helper
from librarian_ui.lang import SELECT_LANGS

from .consts import LICENSES


def open_archive(config=None):
    conf = config or request.app.config
    return Archive.setup(conf['library.backend'],
                         request.app.supervisor.exts.fsal,
                         request.db.content,
                         contentdir=conf['library.contentdir'],
                         meta_filenames=conf['library.metadata'])


def get_content_url(root_url, domain):
    archive = open_archive()
    matched_contents = archive.content_for_domain(domain)
    try:
        # as multiple matches are possible, pick the first one
        meta = matched_contents[0]
    except IndexError:
        # invalid content domain
        path = 'content-not-found'
    else:
        path = i18n_url('opener:detail')
        path += set_qparam(path=meta.path).to_qs()

    return urljoin(root_url, path)


@template_helper
def join(*args):
    return os.path.join(*args)


@template_helper
@cached(prefix='content')
def content_languages():
    archive = open_archive()
    content_langs = archive.get_content_languages()
    return [(code, unicode(name)) for (code, name) in SELECT_LANGS
            if code in content_langs]


@template_helper
def readable_license(license_code):
    return dict(LICENSES).get(license_code, LICENSES[0][1])


@template_helper
def is_free_license(license):
    return license not in ['ARL', 'ON']

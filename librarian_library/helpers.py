"""
helpers.py: librarian core helper functions

Copyright 2014-2015, Outernet Inc.
Some rights reserved.

This software is free software licensed under the terms of GPLv3. See COPYING
file that comes with the source code, or http://www.gnu.org/licenses/gpl.txt.
"""

import os

from bottle import request
from bottle_utils.common import unicode

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

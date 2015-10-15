"""
content.py: routes related to content

Copyright 2014-2015, Outernet Inc.
Some rights reserved.

This software is free software licensed under the terms of GPLv3. See COPYING
file that comes with the source code, or http://www.gnu.org/licenses/gpl.txt.
"""

import os

from bottle import request, redirect, abort
from bottle_utils.ajax import roca_view
from bottle_utils.html import set_qparam
from bottle_utils.i18n import lazy_gettext as _, i18n_url

from librarian_content.decorators import with_meta
from librarian_content.library import metadata
from librarian_core.contrib.cache.decorators import cached
from librarian_core.contrib.templates.renderer import template

from ..helpers import open_archive
from ..paginator import Paginator


@cached(prefix='content', timeout=300)
def content_count(query, lang, tag, content_type):
    archive = open_archive()
    return archive.get_count(query, lang, tag, content_type)


@cached(prefix='content', timeout=300)
def filter_content(query, lang, tag, content_type, offset, limit):
    conf = request.app.config
    archive = open_archive()
    raw_metas = archive.get_content(terms=query,
                                    lang=lang,
                                    tag=tag,
                                    content_type=content_type,
                                    offset=offset,
                                    limit=limit)
    get_content_path = lambda relpath: os.path.join(conf['library.contentdir'],
                                                    relpath)
    return [metadata.Meta(meta, get_content_path(meta['path']))
            for meta in raw_metas]


@roca_view('library/content_list', 'library/_content_list', template_func=template)
def content_list():
    """ Show list of content """
    # parse search query
    query = request.params.getunicode('q', '').strip()
    # parse language filter
    default_lang = request.user.options.get('content_language', None)
    lang = request.params.get('lang', default_lang)
    request.user.options['content_language'] = lang
    # parse content type filter
    content_type = request.params.get('content_type')
    if content_type not in metadata.CONTENT_TYPES:
        content_type = None
    # parse tag filter
    archive = open_archive()
    try:
        tag = int(request.params.get('tag'))
    except (TypeError, ValueError):
        tag = None
        tag_name = None
    else:
        try:
            tag_name = archive.get_tag_name(tag)['name']
        except (IndexError, KeyError):
            abort(404, _('Specified tag was not found'))
    # parse pagination params
    page = Paginator.parse_page(request.params)
    per_page = Paginator.parse_per_page(request.params)
    # get content list filtered by above parsed filter params
    item_count = content_count(query, lang, tag, content_type)
    metas = filter_content(query,
                           lang,
                           tag,
                           content_type,
                           offset=page - 1,
                           limit=per_page)
    pager = Paginator(range(item_count), page, per_page)
    return dict(metadata=metas,
                pager=pager,
                vals=request.params.decode(),
                query=query,
                chosen_lang=lang,
                content_types=metadata.CONTENT_TYPES,
                chosen_content_type=content_type,
                tag=tag_name,
                tag_id=tag,
                tag_cloud=archive.get_tag_cloud(),
                base_path=i18n_url('content:list'),
                view=request.params.get('view'))


def pick_opener(content_type):
    openers = request.app.supervisor.exts.openers
    opener_id = openers.first_content_type(content_type)
    if not opener_id:
        # no match found, return default opener for simple downloads
        opener_id = openers.get('*')
    return opener_id


@with_meta()
def content_detail(path, meta):
    """Update view statistics and redirect to an opener."""
    archive = open_archive()
    archive.add_view(meta.path)
    # as mixed content is possible in zipballs, it is allowed to specify which
    # content type is being viewed now explicitly, falling back to the first
    # one found in the content object
    content_type = request.params.get('content_type')
    if content_type is None:
        # pick first available content type present in content object as it was
        # not specified
        content_type = meta.content_type_names[0]

    opener_id = pick_opener(content_type)
    url = i18n_url('files:path', path=meta.path)
    url += set_qparam(action='open', opener_id=opener_id).to_qs()
    return redirect(url)

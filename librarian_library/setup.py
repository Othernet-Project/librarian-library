import os
import shutil

import pytz

from bottle import request

from librarian_core.contrib.i18n.utils import (set_default_locale,
                                               get_enabled_locales)
from librarian_content.importer import import_content

from .forms import get_language_form, SetupDateTimeForm, SetupImportContentForm


def is_language_invalid():
    supervisor = request.app.supervisor
    lang_code = supervisor.exts.setup.get('language')
    return lang_code not in get_enabled_locales()


def setup_language_form():
    SetupLanguageForm = get_language_form(request.app.config)
    return dict(form=SetupLanguageForm())


def setup_language():
    SetupLanguageForm = get_language_form(request.app.config)
    form = SetupLanguageForm(request.forms)
    if not form.is_valid():
        return dict(successful=False, form=form)

    lang = form.processed_data['language']
    request.app.supervisor.exts.setup.append({'language': lang})
    set_default_locale(lang)
    return dict(successful=True, language=lang)


def has_bad_tz():
    timezone = request.app.supervisor.exts.setup.get('timezone')
    return timezone not in pytz.common_timezones


def setup_datetime_form():
    return dict(form=SetupDateTimeForm())


def setup_datetime():
    form = SetupDateTimeForm(request.forms)
    if not form.is_valid():
        return dict(successful=False, form=form)

    timezone = form.processed_data['timezone']
    request.app.supervisor.exts.setup.append({'timezone': timezone})
    return dict(successful=True, timezone=timezone)


def get_old_contentdir():
    return request.app.config.get('library.legacy_contentdir', '')


def has_old_content():
    old_contentdir = get_old_contentdir()
    return os.path.exists(old_contentdir)


def import_old_content(old_contentdir):
    contentdir = request.app.config['library.contentdir']
    meta_filenames = request.app.config['library.metadata']
    destdir = os.path.join(contentdir, 'Old_content')
    if not os.path.exists(destdir):
        os.makedirs(destdir)
    import_content(old_contentdir, destdir, meta_filenames)


def delete_old_content(old_contentdir):
    if os.path.exists(old_contentdir):
        shutil.rmtree(old_contentdir)


def setup_import_content_form():
    return dict(form=SetupImportContentForm())


def setup_import_content():
    form = SetupImportContentForm(request.forms)
    if not form.is_valid():
        return dict(successful=False, form=form)

    old_contentdir = get_old_contentdir()
    if form.processed_data['chosen_action'] == form.IMPORT:
        import_old_content(old_contentdir)
    # even when importing, upon completion old content folder has to be deleted
    delete_old_content(old_contentdir)

    return dict(successful=True)

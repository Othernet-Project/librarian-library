import os
import shutil

import pytz

from bottle import request

from librarian_core.contrib.i18n.utils import (set_default_locale,
                                               set_current_locale,
                                               get_enabled_locales)

from .forms import get_language_form, SetupDateTimeForm, SetupImportContentForm
from .helpers import open_archive
from .importer import import_content


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
    set_current_locale(lang)
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


def get_old_contentdirs():
    return request.app.config.get('library.legacy_contentdirs', [])


def has_old_content():
    return any([os.path.exists(contentdir) and os.listdir(contentdir)
                for contentdir in get_old_contentdirs()])


def delete_old_content(old_contentdir):
    if os.path.exists(old_contentdir):
        shutil.rmtree(old_contentdir)


def setup_import_content_form():
    return dict(form=SetupImportContentForm())


def setup_import_content():
    form = SetupImportContentForm(request.forms)
    if not form.is_valid():
        return dict(successful=False, form=form)

    old_contentdirs = get_old_contentdirs()
    if form.processed_data['chosen_action'] == form.IMPORT:
        fsal = request.app.supervisor.exts.fsal
        archive = open_archive()
        destdir = request.app.config['library.legacy_destination']
        for srcdir in old_contentdirs:
            import_content(srcdir, destdir, fsal, archive)
            # even when importing, upon completion old content folder has to be
            # deleted
            delete_old_content(srcdir)
    elif form.processed_data['chosen_action'] == form.IGNORE:
        for contentdir in old_contentdirs:
            delete_old_content(contentdir)

    return dict(successful=True)

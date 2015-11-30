import os
import shutil

import pytz

from bottle import request

from librarian_core.contrib.i18n.utils import (set_default_locale,
                                               set_current_locale,
                                               get_enabled_locales)

from .forms import get_language_form, SetupDateTimeForm, SetupImportContentForm
from .importer import import_content


IMPORT_TASK_KEY = 'import_tasks'


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
    task_ids = request.app.config.get(IMPORT_TASK_KEY, [])
    if task_ids:
        tasks = request.app.supervisor.exts.tasks
        healthy = lambda x: tasks.get_status(x) in (tasks.QUEUED,
                                                    tasks.PROCESSING)
        if any([healthy(tid) for tid in task_ids]):
            return False
        # delete finished task ids
        request.app.config.pop(IMPORT_TASK_KEY, None)

    return any([os.path.exists(contentdir) and os.listdir(contentdir)
                for contentdir in get_old_contentdirs()])


def delete_old_content(old_contentdir):
    if os.path.exists(old_contentdir):
        shutil.rmtree(old_contentdir)


def setup_import_content_form():
    return dict(form=SetupImportContentForm())


def import_task(srcdir, destdir, meta_filenames, fsal, notifications,
                notifications_db):
    import_content(srcdir,
                   destdir,
                   meta_filenames,
                   fsal,
                   notifications,
                   notifications_db)
    # even when importing, upon completion old content folder has to be deleted
    delete_old_content(srcdir)


def setup_import_content():
    form = SetupImportContentForm(request.forms)
    if not form.is_valid():
        return dict(successful=False, form=form)

    old_contentdirs = get_old_contentdirs()
    if form.processed_data['chosen_action'] == form.IMPORT:
        tasks = request.app.supervisor.exts.tasks
        fsal = request.app.supervisor.exts.fsal
        notifications = request.app.supervisor.exts.notifications
        notifications_db = request.app.supervisor.exts.databases.notifications
        meta_filenames = request.app.config['library.metadata']
        destdir = request.app.config['library.legacy_destination']
        import_task_ids = []
        for srcdir in old_contentdirs:
            args = (srcdir,
                    destdir,
                    meta_filenames,
                    fsal,
                    notifications,
                    notifications_db)
            task_id = tasks.schedule(import_task, args=args)
            import_task_ids.append(task_id)
        request.app.config[IMPORT_TASK_KEY] = import_task_ids
    elif form.processed_data['chosen_action'] == form.IGNORE:
        for contentdir in old_contentdirs:
            delete_old_content(contentdir)

    return dict(successful=True)

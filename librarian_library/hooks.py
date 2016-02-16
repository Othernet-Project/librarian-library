from bottle_utils.i18n import lazy_gettext as _

from librarian_core.contrib.i18n.consts import LANGS
from librarian_core.contrib.i18n.utils import set_default_locale

from . import setup
from .menuitems import LibraryMenuItem


def settings_saved(settings):
    set_default_locale(settings['general.language'])


def initialize(supervisor):
    supervisor.exts.menuitems.register(LibraryMenuItem)
    # register setup wizard step
    setup_wizard = supervisor.exts.setup_wizard
    setup_wizard.register('language',
                          setup.setup_language_form,
                          template='setup/step_language.tpl',
                          method='GET',
                          index=1,
                          test=setup.is_language_invalid)
    setup_wizard.register('language',
                          setup.setup_language,
                          template='setup/step_language.tpl',
                          method='POST',
                          index=1,
                          test=setup.is_language_invalid)
    setup_wizard.register('import_content',
                          setup.setup_import_content_form,
                          template='setup/step_import_content.tpl',
                          method='GET',
                          test=setup.has_old_content)
    setup_wizard.register('import_content',
                          setup.setup_import_content,
                          template='setup/step_import_content.tpl',
                          method='POST',
                          test=setup.has_old_content)
    # register option to change default language
    default_language = supervisor.config.get('i18n.default_locale', 'en')
    locales = supervisor.config.get('i18n.locales', ['en'])
    ui_languages = [(code, name) for code, name in LANGS if code in locales]
    help_text = _("Interface language that is initially selected for all "
                  "users. Users can change it independently later.")
    supervisor.exts.settings.add_group('general', _("General settings"))
    supervisor.exts.settings.add_field(name='default_language',
                                       group='general',
                                       label=_("Default language"),
                                       value_type='select',
                                       help_text=help_text,
                                       required=True,
                                       default=default_language,
                                       choices=ui_languages)
    # register handler that sets default language when settings are saved
    supervisor.exts.events.subscribe('SETTINGS_SAVED', settings_saved)


import pytz

from bottle_utils import form
from bottle_utils.i18n import lazy_gettext as _

from librarian_core.contrib.i18n.consts import LANGS


def get_language_form(config):
    default_locale = config.get('i18n.default_locale', 'en')
    locales = config.get('i18n.locales', ['en'])
    ui_languages = [(code, name) for code, name in LANGS if code in locales]

    class SetupLanguageForm(form.Form):
        # Translators, used as label for language
        language = form.SelectField(_('Language'),
                                    value=default_locale,
                                    validators=[form.Required()],
                                    choices=ui_languages)

    return SetupLanguageForm


class SetupDateTimeForm(form.Form):
    TIMEZONES = [(tzname, tzname) for tzname in pytz.common_timezones]
    DEFAULT_TIMEZONE = pytz.common_timezones[0]
    # Translators, used as label for date and time setup
    timezone = form.SelectField(_("Timezone"),
                                value=DEFAULT_TIMEZONE,
                                validators=[form.Required()],
                                choices=TIMEZONES)


class SetupImportContentForm(form.Form):
    IMPORT = 'import'
    IGNORE = 'ignore'
    ACTIONS = (
        # Translators, used for setup wizard action of importing legacy content
        (IMPORT, _("Import")),
        # Translators, used for setup wizard action of discarding legacy
        # content
        (IGNORE, _("Discard")),
    )
    chosen_action = form.SelectField(_("Action"),
                                     value=IMPORT,
                                     validators=[form.Required()],
                                     choices=ACTIONS)

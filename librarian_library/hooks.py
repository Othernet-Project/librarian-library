from . import setup
from .menuitems import ContentMenuItem


def initialize(supervisor):
    supervisor.exts.menuitems.register(ContentMenuItem)
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
    setup_wizard.register('datetime',
                          setup.setup_datetime_form,
                          template='setup/step_datetime.tpl',
                          method='GET',
                          index=2,
                          test=setup.has_bad_tz)
    setup_wizard.register('datetime',
                          setup.setup_datetime,
                          template='setup/step_datetime.tpl',
                          method='POST',
                          index=2,
                          test=setup.has_bad_tz)

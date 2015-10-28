from . import setup
from .menuitems import LibraryMenuItem


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

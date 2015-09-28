from bottle_utils.i18n import lazy_gettext as _

from librarian_menu.menu import MenuItem


class ContentMenuItem(MenuItem):
    name = 'content'
    label = _("Library")
    icon_class = 'library'
    route = 'content:list'

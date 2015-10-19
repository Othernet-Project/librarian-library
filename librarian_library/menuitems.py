from bottle_utils.i18n import lazy_gettext as _

from librarian_menu.menu import MenuItem


class LibraryMenuItem(MenuItem):
    name = 'library'
    label = _("Library")
    icon_class = 'library'
    route = 'content:list'

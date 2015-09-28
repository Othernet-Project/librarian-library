from .menuitems import ContentMenuItem


def initialize(supervisor):
    supervisor.exts.menuitems.register(ContentMenuItem)

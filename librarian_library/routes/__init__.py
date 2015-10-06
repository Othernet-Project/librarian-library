from .content import content_list, content_detail


EXPORTS = {
    'routes': {'required_by': ['librarian_core.contrib.system.routes.routes']}
}


def routes(config):
    return (
        ('content:list', content_list, 'GET', '/', {}),
        ('content:detail', content_detail, 'GET', '/content/<path:path>', {}),
    )

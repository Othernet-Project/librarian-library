from .content import content_list, content_detail
from .misc import domain_mismatch


EXPORTS = {
    'routes': {'required_by': ['librarian_core.contrib.system.routes.routes']}
}


def routes(config):
    return (
        ('content:list', content_list, 'GET', '/content/', {}),
        ('content:detail', content_detail, 'GET', '/content/<path:path>', {}),
        ('content:domain_mismatch', domain_mismatch, 'GET',
         '/you-are-on-outernet', {}),
    )

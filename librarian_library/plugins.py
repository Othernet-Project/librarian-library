import re
import logging

from functools import wraps

from bottle import request, redirect

from .helpers import get_content_url
from .netutils import IPv4Range, get_target_host


EXPORTS = {
    'content_resolver_plugin': {}
}

IP_RE = re.compile(r'^(?:\d{1,3}\.){3}\d{1,3}$')


def content_resolver_plugin(supervisor):
    """Load content based on the requested domain"""
    root_url = supervisor.config['app.root_url']
    ip_addresses = supervisor.config['app.ap_client_ip_range']
    ip_range = IPv4Range(*ip_addresses) if ip_addresses else None

    def decorator(callback):
        if not ip_range:
            logging.warning("Content resolver plugin not loaded due to missing"
                            " IP configuration.")
            return callback

        @wraps(callback)
        def wrapper(*args, **kwargs):
            target_host = get_target_host()

            # We consider access to be direct if they used the hostname that
            # was chosen to represent this box, or they used an IP address.
            is_direct = (target_host in root_url) or IP_RE.match(target_host)
            if is_direct or request.remote_addr not in ip_range:
                return callback(*args, **kwargs)

            # a content domain was entered (most likely), try to load it
            content_url = get_content_url(root_url, target_host)
            return redirect(content_url)

        return wrapper
    return decorator

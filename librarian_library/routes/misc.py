"""
misc.py: miscellaneous content-related routes

Copyright 2014-2015, Outernet Inc.
Some rights reserved.

This software is free software licensed under the terms of GPLv3. See COPYING
file that comes with the source code, or http://www.gnu.org/licenses/gpl.txt.
"""

from bottle import request
from bottle_utils.i18n import lazy_gettext as _
from librarian_core.contrib.templates.renderer import view


@view('library/domain_mismatch')
def domain_mismatch():
    # Translators, used in place of actual domain name when domain name is not
    # known. This is used on a page which user sees when they try to reach an
    # Internet domain while connected to Outernet. It appears in a sentence
    # "{domain} does not exist on Outernet".
    return dict(hostname=request.params.get('wanted', _('Unknown domain')),
                redirect_url='/')


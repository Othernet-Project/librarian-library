import os
from setuptools import setup, find_packages

import librarian_library


def read(fname):
    """ Return content of specified file """
    return open(os.path.join(os.path.dirname(__file__), fname)).read()


VERSION = librarian_library.__version__

setup(
    name='librarian-library',
    version=VERSION,
    license='BSD',
    packages=find_packages(),
    long_description=read('README.rst'),
    install_requires=[
        'pytz',
        'scandir',
        'bottle-fdsend',
        'outernet_metadata',
        'librarian_core',
        'librarian_sqlite',
        'librarian_cache',
        'librarian_menu',
        'librarian_auth',
        'librarian_setup',
    ],
    dependency_links=[
        'git+ssh://git@github.com/Outernet-Project/librarian-core.git#egg=librarian_core-0.1',
        'git+ssh://git@github.com/Outernet-Project/librarian-sqlite.git#egg=librarian_sqlite-0.1',
        'git+ssh://git@github.com/Outernet-Project/librarian-cache.git#egg=librarian_cache-0.1',
        'git+ssh://git@github.com/Outernet-Project/librarian-menu.git#egg=librarian_menu-0.1',
        'git+ssh://git@github.com/Outernet-Project/librarian-auth.git#egg=librarian_auth-0.1',
        'git+ssh://git@github.com/Outernet-Project/librarian-setup.git#egg=librarian_setup-0.1',
    ],
    classifiers=[
        'Development Status :: 3 - Alpha',
        'Topic :: Applicaton',
        'Framework :: Bottle',
        'Environment :: Web Environment',
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
        'Programming Language :: Python :: 2.7',
        'Programming Language :: Python :: 3.3',
        'Programming Language :: Python :: 3.4',
    ],
)

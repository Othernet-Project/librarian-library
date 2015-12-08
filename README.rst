=================
librarian-library
=================

A GUI prividing a simplified view of the content library, primarily meant to
provide a classical "web" experience.

Installation
------------

The component has the following dependencies:

- scandir_
- librarian-core_
- librarian-menu_
- librarian-auth_
- librarian-setup_
- librarian-content_

To enable this component, add it to the list of components in librarian_'s
`config.ini` file, e.g.::

    [app]
    +components =
        librarian_library

And to make the menuitem show up::

    [menu]
    +main =
        library

Configuration
-------------

``library.legacy_contentdirs``
    List of filesystem paths that were used as content library directories in
    older versions of librarian_. If content is discovered in the specified
    folders, a migration into the new content library will be attempted.
    Example::

        [library]
        legacy_contentdirs =
            tmp/zipballs

Development
-----------

In order to recompile static assets, make sure that compass_ and coffeescript_
are installed on your system. To perform a one-time recompilation, execute::

    make recompile

To enable the filesystem watcher and perform automatic recompilation on changes,
use::

    make watch

.. _scandir: https://github.com/benhoyt/scandir
.. _librarian: https://github.com/Outernet-Project/librarian
.. _librarian-core: https://github.com/Outernet-Project/librarian-core
.. _librarian-menu: https://github.com/Outernet-Project/librarian-menu
.. _librarian-auth: https://github.com/Outernet-Project/librarian-auth
.. _librarian-setup: https://github.com/Outernet-Project/librarian-setup
.. _librarian-content: https://github.com/Outernet-Project/librarian-content
.. _compass: http://compass-style.org/
.. _coffeescript: http://coffeescript.org/

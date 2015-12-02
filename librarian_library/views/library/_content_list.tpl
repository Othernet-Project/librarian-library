<%namespace name="ui_pager" file="/ui/pager.tpl"/>

<%def name="search_clear(label)">
    <a href="${i18n_url('content:list')}" class="button">${label}</a>
</%def>

% if not metadata:
    <p class="library-item search-empty">
        % if not query and not chosen_content_type and not chosen_lang:
            ## Translators, used as note on library page when library is empty
            ${_('Content library is currently empty')}
        % elif query:
            ## Translators, used as note on library page when search does not
            ## return anything {terms} is a placeholder, do not translate
            ${_(u"There are no search results for '{terms}'").format(terms=h.html_escape(query))}
            ## Translators, used as label for button that clears search results
            ${self.search_clear(_('Clear'))}
        % elif chosen_content_type:
            ## Translators, used on library page when there is no content for
            ## given content type, {type} is a placeholder, do not translate
            ${_("There is currently no content of {type} type").format(type=chosen_content_type)}
            ## Translators, used as button label for going back to all content
            ## types when there is no content for a chosen type.
            ${self.search_clear(_('Show all types'))}
        % elif chosen_lang:
            ## Translators, used as not on library page when there is no content for given language
            <% clear_filter_link = '<a href="{path}">{label}</a>'.format(path=i18n_url(request.path) + h.set_qparam(lang='').to_qs(), label=_('here')) %>
            ${_("Language filter for '{lang}' is active. Click {link} to see all content").format(lang=th.lang_name_safe(chosen_lang), link=clear_filter_link)}
        % endif
    </p>
    ## Bail out of template early
    <% return '' %>
% endif

% if query:
    <p class="library-item search-keyword">
        ## Translators, used as note on library page when showing search
        ## results, {term} represents the text typed in by user
        ${_(u"Showing search results for '{term}'").format(term=h.html_escape(query))}
        ## Translators, used as label for button that clears search results
        ${self.search_clear(_('Clear'))}
    </p>
% endif

% for meta in metadata:
    <%
        content_url = i18n_url('files:path', path=meta.path)
    %>

    <li class="library-item ${'library-partner' if meta.is_partner else ''} ${'library-sponsored' if meta.is_sponsored else ''} ${'library-has-cover' if meta.cover else ''}" data-id="${meta.path | h.urlquote}">

    <h2 class="library-item-title${ ' library-item-cover' if meta.cover else ''}"${th.i18n_attrs(meta.lang)}
        % if meta.cover:
            style="background-image: url('${h.quoted_url('files:direct', path=th.join(meta.path, meta.cover))}');"
        % endif
        >
        <a href="${content_url}" tabindex="${loop.index + 1}" class="library-item-link" data-ctypes="${','.join(meta.content_type_names)}" data-prefered-ctype="${chosen_content_type or ''}" data-path="${meta.path | h.urlquote}">
            <span class="library-item-title-text">${meta.title | h}</span>
        </a>
    </h2>

    <div class="library-item-metadata">
        <time datetime="${meta.timestamp.isoformat()[:-6]}Z" data-format="date">${meta.timestamp.strftime('%Y-%m-%d')}</time>
        % if meta.publisher:
            / ${meta.publisher | h} /
        % endif
        % if meta.license:
            ${th.readable_license(meta.license)}
        % else:
            ${_('All rights reserved')}
        % endif
    </div>

    % if meta.keywords:
        <div class="library-item-keywords">
            ## Translators, appears as label for the list of content keywords
            <span class="label">${_('Topics:')}</span>
            % for kw in meta.keywords.split(','):
                <a href="${i18n_url('content:list', q=kw)}" class="list-item-keyword">${kw.strip() | h}</a>
            % endfor
        </div>
    % endif

    </li>
% endfor

<p class="pager">
${ui_pager.pager_links(pager, _('Previous'), _('Next'))}
</p>

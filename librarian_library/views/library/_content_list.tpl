<%namespace name="ui_pager" file="/ui/pager.tpl"/>

<%def name="search_clear()">
    ## Translators, used as label for button that clears search results
    <a href="${i18n_url('content:list')}" class="button">${_('Clear')}</a>
</%def>

% if not metadata:
    <p class="library-item search-empty">
        % if not query and not tag and not chosen_lang:
            ## Translators, used as note on library page when library is empty
            ${_('Content library is currently empty')}
        % elif query:
            ## Translators, used as note on library page when search does not return anything
            ${_("There are no search results for '%(terms)s'") % {'terms': query}}
            ${self.search_clear()}
        % elif tag:
            ## Translators, used as not on library page when there is no content for given tag
            ${_("There are no results for '%(tag)s'") % {'tag': tag}}
        % elif chosen_lang:
            ## Translators, used as not on library page when there is no content for given language
            ${_("Language filter for '%(lang)s' is active. Click %(link)s to see all content") % {'lang': th.lang_name_safe(chosen_lang), 'link': '<a href="%(path)s">%(label)s</a>' % {'path': i18n_url(request.path) + h.set_qparam(lang='').to_qs(), 'label': _('here')}}}
        % endif
    </p>
    ## Bail out of template early
    <% return '' %>
% endif

% if query:
    <p class="library-item search-keyword">
        ## Translators, used as note on library page when showing search
        ## results, {term} represents the text typed in by user
        ${_("Showing search results for '{term}'").format(term=query)}
        ${self.search_clear()}
    </p>
% endif

% for meta in metadata:
    <%
        content_url = i18n_url('content:detail', path=meta.path)
        if chosen_content_type:
            content_url += h.set_qparam(content_type=chosen_content_type).to_qs()
    %>

    <li class="library-item ${'library-partner' if meta.is_partner else ''} ${'library-sponsored' if meta.is_sponsored else ''} ${'library-has-cover' if meta.cover else ''}" data-id="${meta.path}">

    <h2 class="library-item-title${ ' library-item-cover' if meta.cover else ''}"${th.i18n_attrs(meta.lang)}
        % if meta.cover:
            style="background-image: url('${url('files:direct', path=th.join(meta.path, meta.cover))}');"
        % endif
        >
        <a href="${content_url}" tabindex="${loop.index + 1}" class="library-item-link">
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
                <a href="${i18n_url('content:list', q=h.to_bytes(kw))}" class="list-item-keyword">${kw.strip()}</a>
            % endfor
        </div>
    % endif

    </li>
% endfor

${ui_pager.pager_links(pager, _('Previous'), _('Next'))}

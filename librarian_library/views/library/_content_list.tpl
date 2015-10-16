% if not metadata:
    <p class="empty">
    % if not query and not tag and not chosen_lang:
    ## Translators, used as note on library page when library is empty
    ${_('Content library is currently empty')}
    % elif query:
    ## Translators, used as note on library page when search does not return anything
    ${_("There are no search results for '%(terms)s'") % {'terms': query}}
    % elif tag:
    ## Translators, used as not on library page when there is no content for given tag
    ${_("There are no results for '%(tag)s'") % {'tag': tag}}
    % elif chosen_lang:
    ## Translators, used as not on library page when there is no content for given language
    ${_("Language filter for '%(lang)s' is active. Click %(link)s to see all content") % {'lang': th.lang_name_safe(chosen_lang), 'link': '<a href="%(path)s">%(label)s</a>' % {'path': i18n_url(request.path) + h.set_qparam(lang='').to_qs(), 'label': _('here')}}}
    % endif
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
        <a href="${content_url}" tabindex="${loop.index + 1}">
            <span class="library-item-title-text">${meta.title | h}</span>
        </a>
    </h2>

    <div class="library-item-markers">
        <div class="library-item-markers-date">
            <time datetime="${meta.timestamp.isoformat()[:-6]}Z" data-format="date">${meta.timestamp.strftime('%Y-%m-%d')}</time>
        </div>
    </div>

    <div class="library-item-attrib">

    </div>
    % if meta.license:
        <p class="library-item-license">
            % if meta.publisher:
                ${meta.publisher | h} /
            % endif
            ${th.readable_license(meta.license)}
        </p>
    % endif

    </li>
% endfor

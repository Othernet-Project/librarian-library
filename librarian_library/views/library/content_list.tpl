<%inherit file='/base.tpl'/>
<%namespace name='simple_pager' file='_simple_pager.tpl'/>
<%namespace name='content_list' file='_content_list.tpl'/>
<%namespace name='app_list' file='_app_list.tpl'/>
<%namespace name='tag_js_templates' file='_tag_js_templates.tpl'/>

<%namespace name="ui" file="/ui/widgets.tpl"/>

<%block name="title">
## Translators, used as page title
${_('Library')}
</%block>

<%block name="extra_head">
    <link rel="stylesheet" href="${assets['css/library']}">
</%block>

<%block name="menubar_panel">
    <form id="library-search" class="o-multisearch o-panel">
        <div class="o-panel">
            ## Translators, used as label for search field, appears before the text box
            <label for="q" class="o-multisearch-label">${_('Search in titles:')}</label>
        </div>
        <div class="o-panel">
            ${h.vinput('q', vals, _class='search', _type='text', placeholder=_('search keywords'))}
        </div>
        ## The hidden inputs are placed in the markup so they are not first or 
        ## last child of the conaining element. This is because in the 
        ## multisearch layout, the first and last child are treated 
        ## differently.
        ${h.vinput('t', vals, _type='hidden')}
        ${h.vinput('lang', vals, _type='hidden')}
        ${h.vinput('p', vals, _type='hidden')}
        ${h.vinput('pp', vals, _type='hidden')}
        <div class="o-panel">
            <button id="files-multisearch-button" type="submit" class="o-multisearch-button">
                ## Translators, used as button in content list
                <span class="o-multisearch-button-label">${_('Start search')}</span>
                <span class="o-multisearch-button-icon icon"></span>
            </button>
        </div>
    </form>
</%block>

<%
    clangs = th.content_languages()
    has_clangs = len(clangs) > 1
%>

<%block name="context_menu">
    ${ui.context_menu_separator()}
    % if has_clangs:
        ${ui.context_menu_submenu('clanguage', 'content-language', _('Content language'), 'file-globe')}
    % endif
    ${ui.context_menu_item('ctype-all', _('All content'), i18n_url('content:list'), enabled=chosen_content_type, direct=True)}
    ${self.ctype_link('generic', _('General'), 'generic')}
    ${self.ctype_link('html', _('Pages'), 'html')}
    ${self.ctype_link('image', _('Images'), 'image')}
    ${self.ctype_link('audio', _('Audio'), 'audio')}
</%block>

<nav id="content-language" class="o-context-menu o-context-menu-submenu" role="menu" aria-hidden="true">
## Translators, label on back button that appears at the top of
## context menu's submenu
${ui.context_menu_back('context-menu', _('Back to menu'))}
% for locale, label in clangs:
    <% lang_url = i18n_url('content:list', lang=locale) %>
    ${ui.context_menu_item('clang-{}'.format(locale), label, lang_url, enabled=locale != chosen_lang, direct=True)}
% endfor
</nav>

<%def name="ctype_link(ctype, label, icon)">
    ${ui.context_menu_item('ctype-{}'.format(ctype), label, i18n_url('content:list', content_type=ctype), icon, enabled=ctype != chosen_content_type, direct=True)}
</%def>

% if query:
    ## Translators, used as note on library page when showing search results, %(term)s represents the text typed in by user
    <p class="search-keyword">
    ${_("Showing search results for '%(terms)s'") % {'terms': query}}
    ## Translators, used as label for button that clears search results
    <a href="${i18n_path(request.path)}" class="button small secondary">${_('Clear')}</a>
    </p>
% endif

<div class="forms pager">
    ${simple_pager.prev_next_pager()}
</div>

<div class="content-type">
    <ul>
        % if chose_content_type:
            <li><a href="${i18n_path(request.path)}">${_("All")}</a></li>
        % endif
    </ul>
</div>

<ul id="content-list" class="content-list ${chosen_content_type or ''}" data-total="${int(pager.pages)}">
    % if chosen_content_type == 'app':
    ${app_list.body()}
    % else:
    ${content_list.body()}
    % endif
</ul>

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

<%block name="extra_scripts">
<script src="${assets['js/content']}"></script>
</%block>

<%block name="script_templates">
<script id="loadLink" type="text/template">
    <p id="more" class="load-more">
        <button
            class="primary"
            ## Translators, link that loads more content in infinite scrolling page
            data-active="${_('Load more content')}"
            ## Translators, label on link that loads more content, while content is being loaded
            data-normal="${_('Loading...')}">
                <span class="icon"></span>
                ${_('Load more content')}
        </button>
    </p>
</script>

<script id="end" type="text/template">
    <p class="end">
    ## Translators, shown when user reaches the end of the library
    ${_('You have reached the end of the library.')}
    ## Translators, link that appears at the bottom of infinite-scrolling page that takes the user back to top of the page
    <a href="#content-list">${_('Go to top')}</a>
    </p>
</script>

<script id="toTop" type="text/template">
    <div id="to-top" class="to-top">
        ## Translators, link that appears at the bottom of infinite-scrolling page that takes the user back to top of the page
        <a href="#content-list" class="button small">${_('Go to top')}</a>
    </div>
</script>

${tag_js_templates.body()}
</%block>

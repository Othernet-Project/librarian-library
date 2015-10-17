<%inherit file='/base.tpl'/>
<%namespace name='content_list' file='_content_list.tpl'/>
<%namespace name="ui" file="/ui/widgets.tpl"/>
<%namespace name="forms" file="/ui/forms.tpl"/>

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
            <label for="q" class="o-multisearch-label">${_('Search:')}</label>
        </div>
        <div class="o-panel">
            ${h.vinput('q', vals, _class='search', _type='text', placeholder=_('search keywords'))}
        </div>
        ## The hidden inputs are placed in the markup so they are not first or 
        ## last child of the conaining element. This is because in the 
        ## multisearch layout, the first and last child are treated 
        ## differently.
        ${h.vinput('lang', vals, _type='hidden')}
        ${h.vinput('p', vals, _type='hidden')}
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

<%def name="ctype_link(ctype, label, icon)">
    <li>
    % if chosen_content_type != ctype:
        <a href="${i18n_path(request.path + h.set_qparam(content_type=ctype).to_qs())}">
    % else:
        <span>
    % endif
            <span class="icon icon-${icon}"></span>
            <span class="ctype-label">${label}</span>
    % if chosen_content_type != ctype:
        </a>
    % else:
        </a>
    % endif
    </li>
</%def>

<div class="library-filterbar">
    % if has_clangs:
        <h2>${_('Content language')}</h2>
        <form method="get" action="${i18n_url('content:list')}">
            ${h.vinput('content_type', vals, _type='hidden')}
            ${h.vinput('p', vals, _type='hidden')}
            ${forms.select('language', clangs, _('Language'), 'content-')}
        </form>
    % endif

    <h2>${_('Types of content')}</h2>
    <ul class="library-content-types">
        % if chosen_content_type:
            <li>
            <a href="${i18n_path(request.path)}">
                <span class="icon icon-arrow-left"></span>
                <span class="ctype-label">${_("All")}</span>
            </a>
            </li>
        % endif
        ${self.ctype_link('generic', _('General'), 'generic')}
        ${self.ctype_link('html', _('Pages'), 'html')}
        ${self.ctype_link('image', _('Images'), 'image')}
        ${self.ctype_link('audio', _('Audio'), 'audio')}
        ${self.ctype_link('video', _('Video'), 'video')}
    </ul>
</div>

<ul id="library-list" class="library-list ${chosen_content_type or ''}" data-total="${int(pager.pages)}">
    % if chosen_content_type == 'app':
    ${app_list.body()}
    % else:
    ${content_list.body()}
    % endif
</ul>

<%block name="extra_scripts">
<script src="${assets['js/content']}"></script>
</%block>

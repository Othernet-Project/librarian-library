<%inherit file='/setup/setup_base.tpl'/>

<%block name="step_title">
    <span class="icon icon-comment-text-outline"></span> ${_('Default interface language')}
</%block>

<%block name="step_desc">
    <p>${_('Please select the default interface language. This will be the starting user inteface language for all users. Users will be able to change it later.')}</p>
</%block>

<%block name="step">
<div class="step-language-form">
    <p>
        ${form.language.label}
        ${form.language}
        % if form.language.error:
        ${form.language.error}
        % endif
    </p>
</div>
</%block>

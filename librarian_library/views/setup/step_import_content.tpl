<%inherit file='/setup/setup_base.tpl'/>

<%namespace name="forms" file="/ui/forms.tpl"/>

<%block name="step_title">
    <span class="icon icon-globe"></span> ${_('Import existing content')}
</%block>

<%block name="step_desc">
    <p>${_('Do you wish to import existing content items?')}</p>
</%block>

<%block name="step">
<div class="step-import-content-form">
    ${forms.field(form.chosen_action)}
</div>
</%block>

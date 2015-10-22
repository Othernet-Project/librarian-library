<%inherit file='/setup/setup_base.tpl'/>

<%namespace name="forms" file="/ui/forms.tpl"/>

<%block name="step_title">
    <span class="icon icon-file"></span> ${_('Import existing content')}
</%block>

<%block name="step_desc">
    <p>
        ${_("""
        We have found content from a previous version of this software. You may
        choose to import or discard it.
        """)}
    </p>
</%block>

<%block name="step">
<div class="step-import-content-form">
    ${forms.field(form.chosen_action)}
</div>
</%block>

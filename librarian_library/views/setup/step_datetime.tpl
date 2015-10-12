<%inherit file='/setup_base.tpl'/>

<%block name="step_title">
    <span class="icon icon-clock"></span> ${_('Timezone')}
</%block>

<%block name="step_desc">
    <p>${_('Please select your local timezone.')}</p>
</%block>

<%block name="step">
<div class="step-datetime-form">
    <div class="date-field">
        ${form.timezone.label}
        <div class="timezone-container">
            ${form.timezone}
            % if form.timezone.error:
            ${form.timezone.error}
            % endif
        </div>
    </div>
</div>
</%block>

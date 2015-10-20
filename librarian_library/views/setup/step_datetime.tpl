<%inherit file='/setup/setup_base.tpl'/>

<%namespace name="forms" file="/ui/forms.tpl"/>

<%block name="step_title">
    <span class="icon icon-clock"></span> ${_('Timezone')}
</%block>

<%block name="step_desc">
    <p>${_('Please select your local timezone.')}</p>
</%block>

<%block name="step">
    <div class="step-datetime-form">
        <div class="date-field">
            ${forms.field(form.timezone)}
        </div>
    </div>
</%block>

<%block name="extra_body">
    <script>
        ## Translators, used as 'region' in time zone selection, covering 
        ## non-regional time zones like UTC and GMT
        window.UNIVERSAL_REGION = '${_('Non-regional')}';
    </script>
</%block>

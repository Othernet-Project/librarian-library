<%inherit file='/setup/setup_base.tpl'/>

<%namespace name="forms" file="/ui/forms.tpl"/>

<%block name="step_title">
    <span class="icon icon-file"></span> 
    ${_('Existing content')}
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
    <div class="step-import-content-form" id="import-step-fields">
        ${forms.field(form.chosen_action)}
    </div>
    <p class="note">
        ## Translators, note shown during import step
        ${_('Both import and discard may take a long time to complete. Please do not close this tab or unplug the receiver.')}
    </p>
</%block>

<%block name="extra_body">
    <script type="text/template" id="stepImportChoices">
        <ul class="import-choices" id="import-choices">

            <li id="import-import" data-action="import" tabindex="1" role="button">
            <span class="icon icon-import"></span>
            <span class="import-choice-label">
                ${_('Import')}
            </span>
            <span class="import-choice-help">
                ${_('Adds existing content to the library')}
            </span>
            </li>

            <li id="import-ignore" data-action="ignore" tabindex="2" role="button">
            <span class="icon icon-discard"></span>
            <span class="import-choice-label">
                ${_('Discard')}
            </span>
            <span class="import-choice-help">
                ${_('Removes existing content')}
            </span>
            </li>

        </ul>

        <input type="hidden" name="chosen_action" id="import-chosen-action">
    </script>

    <script type="text/template" id="spinner">
        <span class="icon icon-spinning-loader"></span>
    </script>

    <script type="text/template" id="okIcon">
        <span class="icon icon-ok-outline"></span>
    </script>
</%block>

<%inherit file="/narrow_base.tpl"/>

<h2>
    <span class="icon icon-info"></span>
    ## Translators, message shown to users when they try to access a domain
    ## (e.g., google.com) while connected to Outernet receiver through WiFi.
    <span>${_('You are on Outernet')}</span>
</h2>

<p>
    ## Translators, message shown to users when they try to access a domain
    ## (e.g., google.com) while connected to Outernet receiver through WiFi.
    ## {domain} is a placeholder.
    ${_('{domain} does not exist on Outernet.').format(domain=h.attr_escape(hostname))}
</p>
<p>
    ## Translators, message shown to users when they try to access a domain
    ## (e.g., google.com) while connected to Outernet receiver through WiFi.
    ## {url} is a placeholder. Please mind the HTML fragments.
    ${_('You will be taken to the <a href="{url}">main page</a> shortly.').format(url=redirect_url)}
</p>

% for meta in metadata:
<li class="data ${meta.get('archive', 'unknown')} ${'partner' if meta.is_partner else ''} ${'sponsored' if meta.is_sponsored else ''} ${'has-thumb' if meta.cover else ''}" data-id="${meta.path}" ${'style="background-image: url(\'{}\')"'.format(url('files:direct', path=th.join(meta.path, filename=meta.cover)) if meta.cover else '')}>
    <div class="details">
        <p class="label-archive label-${meta.label}">
        ${_(meta.label)}
        </p>
        <h2 class="title"${th.i18n_attrs(meta.lang)}>
            <%
                content_url = i18n_url('content:detail', path=meta.path)
                if chosen_content_type:
                    content_url += h.set_qparam(content_type=chosen_content_type).to_qs()
            %>
            <a href="${content_url}">${meta.title | h}</a>
        </h2>
        <p class="attrib">
        ## Translators, attribution line appearing in the content list
        % if meta.publisher:
        ${_('%(date)s by %(publisher)s.') % dict(date=meta.timestamp.strftime('%Y-%m-%d'), publisher=meta.publisher)}
        % else:
        ${meta.timestamp.strftime('%Y-%m-%d')}
        % endif
        ${th.readable_license(meta.license)}
        </p>
    </div>
</li>
% endfor

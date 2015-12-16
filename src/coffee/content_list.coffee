((window, $, templates) ->

  libraryList = $ '#library-list'
  libraryItemLinkSelector = '.library-item-link'
  openerPanelSelector = '#content'
  contentLanguage = $ '.library-filterbar #language'

  $('#content-language').on 'change', () ->
    $(this).parents('form').submit()
    return


  getLocalePrefix = () ->
    window.location.pathname.split('/')[1]


  getOpenerUrl = (targetCtype, path) ->
    path = encodeURIComponent path
    "/#{getLocalePrefix()}/openers/#{targetCtype}/?path=#{path}"


  getOpenerParams = (link) ->
    ctypes = link.data('ctypes').split ','
    preferredType = link.data 'preferred-ctype'
    path = link.data 'path'

    # Make sure we have at least one type
    if not ctypes.length
      ctypes.push('generic')

    # Check if preferred ctype is in supported ctypes
    targetCtype = if preferredType in ctypes then preferredType else ctypes[0]

    path: path
    targetCtype: targetCtype



  libraryList.on 'click', libraryItemLinkSelector, (e) ->
    link = $ this
    {path, targetCtype} = getOpenerParams link

    # Emit opener event
    type = if targetCtype is 'generic' then 'folder' else targetCtype
    ($ window).trigger 'opener-click', [{path: path, type: type}]

    if targetCtype is 'generic'
      return

    e.preventDefault()
    url = getOpenerUrl targetCtype, path
    $.modalContent url, fullScreen: true
    return

  contentLanguage.on 'change', (e) ->
    select = $ this
    form = select.parents 'form'
    form.submit()

) this, this.jQuery, this.templates

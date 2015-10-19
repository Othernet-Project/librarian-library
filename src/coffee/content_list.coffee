((window, $, templates) ->

  libraryList = $ '#library-list'
  libraryItemLinkSelector = '.library-item-link'
  openerPanelSelector = '#content'

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

    if targetCtype is 'generic'
      return

    e.preventDefault()
    url = getOpenerUrl targetCtype, path
    console.log url
    $.modalContent url, fullScreen: true
    return

) this, this.jQuery, this.templates

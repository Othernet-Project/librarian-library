((window, $, templates) ->

  libraryList = $ '#library-list'
  libraryItemLinkSelector = '.library-item-link'
  openerPanelSelector = '#content'

  $('#content-language').on 'change', () ->
    $(this).parents('form').submit()
    return

  libraryList.on 'click', libraryItemLinkSelector, (e) ->
    e.preventDefault()
    link = $ this
    href = link.attr 'href'

    # First obtain the URL
    res = $.get href
    res.done (url) ->
      # Now load the obtained URL into modal
      $.modalContent url
    res.fail () ->
      # Oops, URL couldn't be fetched, show error message
      $.modalDialog templates.loadFailure
    return

) this, this.jQuery, this.templates

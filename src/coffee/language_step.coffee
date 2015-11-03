((window, $, templates) ->
  $('select#language').on('change', ->
    lang = $('select#language').val()
    location.replace(location.origin + '/' + lang + location.pathname.slice(3) + location.search)
  )
) this, this.jQuery, this.templates

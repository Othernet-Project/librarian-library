((window, $) ->

  $('#content-language').on 'change', () ->
    $(this).parents('form').submit()

) this, this.jQuery

((window, $, templates) ->

  RETURN = 13
  LEFT = 37
  RIGHT = 39
  UP = 38
  DOWN = 40

  importForm = $ '#import-step-fields'

  if not importForm.length
    return

  initialValue = (importForm.find 'select').val()

  importForm.before templates.stepImportChoices
  importForm.remove()

  choices = $ '#import-choices'
  input = $ '#import-chosen-action'
  buttons = choices.find 'li'
  buttonsByName =
    import: choices.find '#import-import'
    ignore: choices.find '#import-ignore'

  input.on 'change', (e) ->
    val = input.val()
    if not val
      return
    buttons.removeClass 'selected'
    (buttonsByName[val].addClass 'selected').focus()


  onActivate = (e) ->
    elem = $ this
    val = elem.data 'action'
    input.val val
    input.change()
    return

  choices.on 'click', 'li', onActivate
  choices.on 'keydown', 'li', (e) ->
    code = e.which
    if code is RETURN
      onActivate.call this, e
    if ([LEFT, UP].indexOf code) > -1
      input.val 'import'
      input.change()
    if ([RIGHT, DOWN].indexOf code) > -1
      input.val 'ignore'
      input.change()
    return

  # Set initial state
  input.val initialValue
  input.change()

  return

) this, this.jQuery, this.templates

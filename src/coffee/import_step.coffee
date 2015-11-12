((window, $, templates) ->

  RETURN = 13
  LEFT = 37
  RIGHT = 39
  UP = 38
  DOWN = 40

  processing = false
  importFormContainer = $ '.setup-wizard form'
  importForm = $ '#import-step-fields'
  importUrl = importFormContainer.attr 'action'
  finishButton = importFormContainer.find 'button'
  spinner = templates.spinner
  ok = templates.okIcon

  if not importForm.length
    return

  initialValue = (importForm.find 'select').val()

  stepChoices = $ templates.stepImportChoices
  importForm.before stepChoices
  importForm.remove()
  importForm = null

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
    if processing
      return

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

  importFormContainer.on 'submit', (e) ->
    e.preventDefault()

    if processing
      return

    # Set processing flag
    processing = true

    # Hide the action that was not chosen
    otherAction = (stepChoices.find 'li').not '.selected'
    otherAction.hide()

    # Set the spinner
    icon = stepChoices.find '.selected .icon'
    spinnerIcon = $ spinner
    icon.after spinnerIcon
    icon.hide()

    # Remove button from view
    finishButton.hide()

    res = $.ajax importUrl,
      method: 'POST'
      data: importFormContainer.serialize()

    res.always (data, status) ->
      status = if status is 'success' then 200 else data.status
      if status >= 400
        $('html').html data.responseText
        return
      if status is 200
        spinnerIcon.replaceWith ok
        setTimeout () ->
          window.location.assign data
        , 2000
      return


  # Set initial state
  input.val initialValue
  input.change()

  return

) this, this.jQuery, this.templates

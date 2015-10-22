((window, $) ->

  regions = {}

  OPT = '<option value="VAL">LBL</option>'

  makeOpt = (val, label) ->
    OPT.replace('VAL', val).replace('LBL', label.replace(/_/g, ' '))

  splitRegion = (val) ->
    [region, city] = val.split('/')
    if not city?
      city = region
      region = window.UNIVERSAL_REGION
    [region, city]

  updateCities = (region, select) ->
    cities = regions[region]
    select.html (makeOpt(c, c) for c in cities).join ''

  timezone = $ '#timezone'

  # Nothing to do if there's no timezone field
  if not timezone.length
    return

  # Copy timezone select list into new hidden input
  hiddenTimezone = $ '<input type="hidden">'
  timezone.after hiddenTimezone
  hiddenTimezone.val current = timezone.val()
  hiddenTimezone.attr 'name', timezone.attr 'name'
  [currentRegion, currentCity] = splitRegion current

  # Create a region-city mapping
  timezone.find('option').each () ->
    opt = $ this
    val = opt.val()
    [region, city] = splitRegion val
    (regions[region] ?= []).push city

  # Remove existing select
  timezone.remove()

  # Create a new set of selects
  regionSelect = $ '<select>'
  citySelect = $ '<select>'
  hiddenTimezone.before regionSelect
  hiddenTimezone.before citySelect

  # Populate the region select and add handlers
  regionSelect.html (makeOpt(r, r) for r of regions).join ''

  updateValue = () ->
    val = citySelect.val()
    rval = regionSelect.val()
    if rval is window.UNIVERSAL_REGION
      composite = val
    else
      composite = "#{rval}/#{val}"
    hiddenTimezone.val composite

  regionSelect.on 'change', () ->
    val = regionSelect.val()
    updateCities val, citySelect
    updateValue()

  citySelect.on 'change', updateValue

  # Set the intial state
  regionSelect.val currentRegion
  regionSelect.change()
  citySelect.val currentCity

  return

) this, this.jQuery

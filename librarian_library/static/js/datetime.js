// Generated by CoffeeScript 1.10.0
(function(window, $) {
  var OPT, citySelect, current, currentCity, currentRegion, hiddenTimezone, makeOpt, r, ref, regionSelect, regions, splitRegion, timezone, updateCities, updateValue;
  regions = {};
  OPT = '<option value="VAL">LBL</option>';
  makeOpt = function(val, label) {
    return OPT.replace('VAL', val).replace('LBL', label.replace(/_/g, ' '));
  };
  splitRegion = function(val) {
    var city, ref, region;
    ref = val.split('/'), region = ref[0], city = ref[1];
    if (city == null) {
      city = region;
      region = window.UNIVERSAL_REGION;
    }
    return [region, city];
  };
  updateCities = function(region, select) {
    var c, cities;
    cities = regions[region];
    return select.html(((function() {
      var i, len, results;
      results = [];
      for (i = 0, len = cities.length; i < len; i++) {
        c = cities[i];
        results.push(makeOpt(c, c));
      }
      return results;
    })()).join(''));
  };
  timezone = $('#timezone');
  if (!timezone.length) {
    return;
  }
  hiddenTimezone = $('<input type="hidden">');
  timezone.after(hiddenTimezone);
  hiddenTimezone.val(current = timezone.val());
  hiddenTimezone.attr('name', timezone.attr('name'));
  ref = splitRegion(current), currentRegion = ref[0], currentCity = ref[1];
  timezone.find('option').each(function() {
    var city, opt, ref1, region, val;
    opt = $(this);
    val = opt.val();
    ref1 = splitRegion(val), region = ref1[0], city = ref1[1];
    return (regions[region] != null ? regions[region] : regions[region] = []).push(city);
  });
  timezone.remove();
  regionSelect = $('<select>');
  citySelect = $('<select>');
  hiddenTimezone.before(regionSelect);
  hiddenTimezone.before(citySelect);
  regionSelect.html(((function() {
    var results;
    results = [];
    for (r in regions) {
      results.push(makeOpt(r, r));
    }
    return results;
  })()).join(''));
  updateValue = function() {
    var composite, rval, val;
    val = citySelect.val();
    rval = regionSelect.val();
    if (rval === window.UNIVERSAL_REGION) {
      composite = val;
    } else {
      composite = rval + "/" + val;
    }
    return hiddenTimezone.val(composite);
  };
  regionSelect.on('change', function() {
    var val;
    val = regionSelect.val();
    updateCities(val, citySelect);
    return updateValue();
  });
  citySelect.on('change', updateValue);
  regionSelect.val(currentRegion);
  regionSelect.change();
  citySelect.val(currentCity);
})(this, this.jQuery);
import librarian_library.helpers as mod


def test_is_free_license(*ignored):
    """ Free license is True for free licenses """
    assert not mod.is_free_license('ARL')
    assert not mod.is_free_license('ON')

    assert mod.is_free_license('GFDL')
    assert mod.is_free_license('CC-BY')


def test_i18n_attrs_property(*ignored):
    """ I18n attributes are returned for specified language """
    assert mod.i18n_attrs('') == ''
    assert mod.i18n_attrs('en') == ' lang="en"'
    assert mod.i18n_attrs('ar') == ' lang="ar" dir="rtl"'

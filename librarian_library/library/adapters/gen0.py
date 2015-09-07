
G1_MAIN_DEFAULT = 'index.html'
G1_KEEP_FORMATTING_DEFAULT = False


def upgrade_to_next(meta):
    for ignored in ('images', 'multipage'):
        meta.pop(ignored, None)

    main = meta.pop('index', G1_MAIN_DEFAULT)
    keep_formatting = meta.pop('keep_formatting', G1_KEEP_FORMATTING_DEFAULT)
    meta['gen'] = 1
    meta['content'] = {
        'html': {
            'main': main,
            'keep_formatting': keep_formatting
        }
    }

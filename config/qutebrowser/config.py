# Documentation:
#   qute://help/configuring.html
#   qute://help/settings.html

import os
import subprocess
import yaml


def read_xresources(prefix):
    props = {}
    x = subprocess.run(['xrdb', '-query'], stdout=subprocess.PIPE)
    lines = x.stdout.decode().split('\n')
    for line in filter(lambda l: l.startswith(prefix), lines):
        prop, _, value = line.partition(':\t')
        props[prop] = value
    return props


# --- colors --- #

with (config.configdir / 'qutebrowser_colors.yml').open() as f:
    yaml_data = yaml.safe_load(f)


def dict_attrs(obj, path=''):
    if isinstance(obj, dict):
        for k, v in obj.items():
            yield from dict_attrs(v, '{}.{}'.format(path, k) if path else k)
    else:
        yield path, obj


for k, v in dict_attrs(yaml_data):
    config.set(k, v)


#--- keybindings ---#
# general bindings
config.unbind('<Ctrl-q>')
config.unbind('<Ctrl-V>')
config.unbind('+')
config.unbind('-')
config.unbind('=')
config.bind('<Ctrl-k>', 'zoom-in')
config.bind('<Ctrl-j>', 'zoom-out')
config.bind('<Ctrl-=>', 'zoom')
config.bind('<Ctrl-r>', 'config-source')
config.bind('<Ctrl-Esc>', 'mode-enter passthrough', mode='normal')
config.bind('<Ctrl-Esc>', 'mode-enter passthrough', mode='insert')
config.bind('<Ctrl-Esc>', 'mode-leave', mode='passthrough')

#config.bind('<Ctrl-q>', 'mode-leave', mode='passthrough')
# don't know whys it's not working
# tabs
config.bind('<Ctrl-1>', 'tab-focus 1')
config.bind('<Ctrl-2>', 'tab-focus 2')
config.bind('<Ctrl-3>', 'tab-focus 3')
config.bind('<Ctrl-4>', 'tab-focus 4')
config.bind('<Ctrl-5>', 'tab-focus 5')
config.bind('<Ctrl-6>', 'tab-focus 6')
config.bind('<Ctrl-7>', 'tab-focus 7')
config.bind('<Ctrl-8>', 'tab-focus 8')
config.bind('<Ctrl-9>', 'tab-focus 9')
config.bind('<Ctrl-0>', 'tab-focus 10')
config.bind('<Ctrl-->', 'tab-focus -1')

#--- configs ---#
c.window.title_format = "{private}{perc}{current_title}{title_sep}qutebrowser"
c.auto_save.session = True
c.editor.command = ['st', '-e', os.environ.get('EDITOR'), '{}']

xresources = read_xresources('*')
try:
    font_name = xresources['*font_name']
    if ':' in font_name:
        font_name = font_name.split(':')[0]
    font_size = xresources['*font_size']
    base_font = font_size + 'pt ' + font_name
except:
    base_font = "11pt Monospace"

c.fonts.hints = 'bold ' + base_font
c.fonts.downloads = base_font
c.fonts.completion.entry = base_font
c.fonts.completion.category = 'bold ' + base_font
c.fonts.debug_console = base_font
c.fonts.keyhint = base_font
c.fonts.messages.error = base_font
c.fonts.messages.info = base_font
c.fonts.messages.warning = base_font
c.fonts.prompts = base_font
c.fonts.statusbar = base_font
c.fonts.tabs.selected = base_font
c.fonts.tabs.unselected = base_font

c.new_instance_open_target = 'window'
c.tabs.title.format = '{index} {current_title}'
c.url.default_page = 'about:blank'
c.url.start_pages = 'about:blank'
# c.url.default_page = '~/.config/qutebrowser/blank.html'
# c.url.start_pages = '~/.config/qutebrowser/blank.html'
c.confirm_quit = ["downloads"]
c.downloads.location.directory = '~/tmp/'
c.downloads.position = 'bottom'
c.downloads.open_dispatcher = ''
c.keyhint.radius = 0
c.prompt.radius = 0
#c.spellcheck.languages = ['pt-BR', 'en-US', 'de-DE']
c.url.searchengines = {
    "DEFAULT": "https://www.google.com.br/search?q={}",
    # "DEFAULT": "https://duckduckgo.com/?q={}",
    "g":  "https://www.google.com.br/search?q={}",
    "gs": "https://scholar.google.com/scholar?q={}",
    "gsb":
    "https://scholar.google.com.br/scholar?hl=pt-BR&as_sdt=0%2C5&q={}",
        "gpten": "https://translate.google.com/#pt/en/{}",
        "gen": "http://gen.lib.rus.ec/search.php?req={}&open=0&res=25&view=simple&phrase=1&column=def",
        "wr": "https://www.wordreference.com/enpt/{}",
        "w":  "https://en.wikipedia.org/wiki/Special:Search?search={}",
        "wb":  "https://pt.wikipedia.org/wiki/Special:Search?search={}",
        "wh": "https://alpha.wallhaven.cc/search?q={}",
        "doi": "http://gen.lib.rus.ec/scimag/?q={}",
        "dd":  "https://duckduckgo.com/?q={}",
        "gd":  "https://drive.google.com/drive/search?q={}",
        "yt":  "https://www.youtube.com/results?search_query={}",
        "aw": "https://wiki.archlinux.org/?search={}",
        "pten":
            "https://translate.google.com/#view=home&op=translate&sl=pt&tl=en&text={}",
        "enpt":
            "https://translate.google.com/#view=home&op=translate&sl=en&tl=pt&text={}",
        "sc": "https://soundcloud.com/search?q={}",
}


#c.content.user_stylesheets = []
#c.content.user_stylesheets = ['wal.css']
#c.content.user_stylesheets = ['/home/marcosrdac/.config/qutebrowser/ss/solarized-everything-css/css/solarized-light/solarized-light-all-sites.css']


# Enable JavaScript.
#config.set('content.javascript.enabled', True, 'file://*')
#config.set('content.javascript.enabled', True, 'chrome://*/*')
#config.set( 'content.javascript.enabled', True, 'qute://*/*')
# https://qutebrowser.org/doc/install.html#_debian_testing_ubuntu_18_04

# c.content.host_blocking.lists = \
# c.content.host_blocking.enabled = True
#c.content.host_blocking.whitelist = ['*www.linkedin.com/*']

config.load_autoconfig(False)

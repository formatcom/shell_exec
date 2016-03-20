jQuery = require 'jquery'

CodeMirror = require 'codemirror/lib/codemirror.js'
require 'codemirror/addon/dialog/dialog.js'
require 'codemirror/addon/search/searchcursor.js'
require 'codemirror/mode/clike/clike.js'
require 'codemirror/addon/edit/matchbrackets.js'
require 'codemirror/keymap/vim.js'

vim = document.getElementById 'vim'

CodeMirror.fromTextArea vim,
  lineNumbers: true
  mode: 'text/x-csrc'
  keyMap: 'vim'
  theme: 'monokai'
  matchBrackets: true
  showCursorWhenSelecting: true

$vim = jQuery '.CodeMirror'

$vim.hidden()

module.exports = $vim

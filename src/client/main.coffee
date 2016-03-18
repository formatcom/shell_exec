window.jQuery = require 'jquery'
require 'jquery.terminal/js/jquery.terminal-src.js'
socketio = require 'socket.io-client'

CodeMirror = require 'codemirror/lib/codemirror.js'
require 'codemirror/addon/dialog/dialog.js'
require 'codemirror/addon/search/searchcursor.js'
require 'codemirror/mode/clike/clike.js'
require 'codemirror/addon/edit/matchbrackets.js'
require 'codemirror/keymap/vim.js'

###
editor = document.getElementById 'vim'

CodeMirror.fromTextArea editor,
  lineNumbers: true
  mode: 'text/x-csrc'
  keyMap: 'vim'
  theme: 'monokai'
  matchBrackets: true
  showCursorWhenSelecting: true
###

socket  = socketio()
$window = jQuery window

socket.term = jQuery('body').terminal (command, term) ->

  if command != '' then socket.emit 'command:in', command
  term.echo ''

, {
  greetings: false
  completion: (term, command, callback) ->
    history = term.history().data()
    callback history
  login: (user, pass, callback) ->
    jQuery.ajax
      url: 'api/login'
      type: 'POST'
      headers:
        socket: socket.id
      data: {user, pass}
      success: (data) ->
        if data.response then callback data.response
        else callback null
  onInit: (term) ->
    term.set_prompt "#{term.login_name()}:ASYNC > "
}

$window.resize( () ->
  height = $window.height()
  socket.term.innerHeight height - 50
).resize()

socket.on 'command:out', (res) ->
  if res.out then @term.echo res.out
  else if res.path then @term.set_prompt "#{@term.login_name()}:ASYNC #{res.path} > "
  else if res.exit then @term.logout()

handleDragOver = (event) ->
  event.stopPropagation()
  event.preventDefault()
  event.dataTransfer.dropEffect = 'copy'

handleFileSelect = (event) ->
  event.stopPropagation()
  event.preventDefault()
  
  file = event.dataTransfer.files[0]
  data = new FormData()
  data.append 'file', file

  socket.term.echo "...uploading file: #{file.name}..."
  
  jQuery.ajax
    url: 'api/upload'
    type: 'POST'
    headers:
      socket: socket.id
      token: socket.term.token()
    data: data
    cache: false
    contentType: false
    processData: false
    success: (data) ->
      socket.term.echo "...#{data.response} has been uploaded succesfully..."

window.addEventListener 'dragover', handleDragOver, false
window.addEventListener 'drop',     handleFileSelect, false

window.term = socket.term

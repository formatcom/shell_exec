window.jQuery = require 'jquery'
require 'jquery.terminal/js/jquery.terminal-src.js'
socketio = require 'socket.io-client'

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
    jQuery.post 'api/login', {user, pass}, (data) ->
      if data.response then callback socket.id
      else callback null
  onInit: (term) ->
    term.set_prompt "#{term.login_name()}:ASYNC > "
}

$window.resize( () ->
  height = $window.height()
  socket.term.innerHeight height - 50
).resize()

socket.on 'command:out', (res) -> @term.echo res
socket.on 'path', (path) -> @term.set_prompt "#{@term.login_name()}:ASYNC #{path} > "

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
    data: data
    cache: false
    contentType: false
    processData: false
    success: (data) ->
      socket.term.echo "...#{data.response} has been uploaded succesfully..."

window.addEventListener 'dragover', handleDragOver, false
window.addEventListener 'drop',     handleFileSelect, false

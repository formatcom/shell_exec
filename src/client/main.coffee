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


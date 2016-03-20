window.jQuery = require 'jquery'
require 'jquery.terminal/js/jquery.terminal-src.js'
socket = require './socket'
vim    = require './vim'

socket.term = jQuery('body').terminal (command, term) ->

  if command != ''
    _command = command.split ' '
    if _command[0] is 'vim'
      vim.visible()
    else
      socket.emit 'command:in', command
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

window.term = socket.term

$window = jQuery window

$window.resize( () ->
  height = $window.height()
  socket.term.innerHeight height - 50
).resize()

socket.on 'command:out', (res) ->
  if res.out then @term.echo res.out
  else if res.path then @term.set_prompt "#{@term.login_name()}:ASYNC #{res.path} > "
  else if res.exit then @term.logout()

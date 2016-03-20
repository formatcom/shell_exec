fs         = require 'fs'
http       = require 'http'
express    = require 'express'
bodyParser = require 'body-parser'
socketio   = require 'socket.io'
{exec}     = require 'child_process'
api        = require './api'

app     = express()
server  = http.createServer app
io      = socketio server
clients = io.engine.clients

app.use express.static 'public'
app.use bodyParser.json()
app.use bodyParser.urlencoded extended: true
app.use '/api', api

io.on 'connection', (socket) ->

  socket.on 'command:in', (command) ->
    {token} = socket.client.conn

    if !token then return socket.emit 'command:out', {exit: true}

    _command = command.split ' '
    if _command[0] is 'cd'
      _command.shift()
      path = _command.join ' '
      fs.access path, fs.F_OK, (err) ->
        if !err
          process.chdir path
          socket.emit 'command:out', {path: process.cwd()}
    else
      exec command, (error, stdout, stderr) -> socket.emit 'command:out', {out: stdout || stderr}

module.exports = {clients, server}

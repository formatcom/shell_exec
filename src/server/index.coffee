fs         = require 'fs'
http       = require 'http'
express    = require 'express'
bodyParser = require 'body-parser'
socketio   = require 'socket.io'
{exec}     = require 'child_process'
api        = require './api'

app    = express()
server = http.createServer app
io     = socketio server
port   = process.env.PORT || 57575

app.use express.static 'public'
#app.use bodyParser.json()
#app.use bodyParser.urlencoded extended: true
app.use '/api', api

io.on 'connection', (socket) ->
  
  socket.on 'command:in', (command) ->
    _command = command.split ' '
    if _command[0] is 'cd'
      _command.shift()
      path = _command.join ' '
      fs.access path, fs.F_OK, (err) ->
        if !err
          process.chdir path
          socket.emit 'path', process.cwd()
    else
      exec command, (error, stdout, stderr) -> socket.emit 'command:out', stdout || stderr

server.listen port, console.log "\nServer listening on port #{port}"

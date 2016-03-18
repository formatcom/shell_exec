{server} = require './socket'

port = process.env.PORT || 57575
server.listen port, console.log "\nServer listening on port #{port}"

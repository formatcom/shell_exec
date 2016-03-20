jQuery = require 'jquery'
socket = require './socket'

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

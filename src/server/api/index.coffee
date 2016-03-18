express = require 'express'
multer  = require 'multer'
uid     = require 'uid'
data    = require '../users.json'

storage = multer.diskStorage
  destination: (req, file, cb) ->
    cb null, '.'
  filename: (req, file, cb) ->
    cb null, file.originalname

check  = (req, res, next) ->
  {clients} = require '../socket'
  {socket, token} = req.headers
  token = null if !token
  if clients[socket] and clients[socket].token is token
    next()
  else
    res.json {response: null}

router = express.Router()
router.post '/login', (req, res) ->
  {clients} = require '../socket'
  {user, pass} = req.body
  {socket} = req.headers
  if data[user] is pass and clients[socket]
    clients[socket].token = uid()
    res.json {response: clients[socket].token}
  else
    res.json {response: null}

router.post '/upload', check, multer({storage}).single('file'), (req, res) ->
  res.json {response: req.file.originalname}

module.exports = router

express = require 'express'
multer  = require 'multer'
data    = require '../users.json'

storage = multer.diskStorage
  destination: (req, file, cb) ->
    cb null, '.'
  filename: (req, file, cb) ->
    cb null, file.originalname

router = express.Router()
router.post '/login', (req, res) ->
  {user, pass} = req.body
  if data[user] is pass
    res.json {response: true}
  else
    res.json {response: null}

router.post '/upload', multer({storage}).single('file'), (req, res, next) ->
  res.json {response: req.file.originalname}

module.exports = router

express = require 'express'
data    = require '../users.json'

router = express.Router()
router.post '/login', (req, res) ->
  {user, pass} = req.body
  if data[user] is pass
    res.json {response: true}
  else
    res.json {response: null}

module.exports = router

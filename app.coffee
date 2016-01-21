express = require 'express'
bodyParser = require 'body-parser'
multer = require('multer')
Waterpit = require('water-pit').Waterpit
_config = require './config'
_routeMap = require './route'
_conn = require './connection'
_port = _config.port
upload = multer({ dest: _config.dest})
app = express()
router = express.Router()
water = new Waterpit(router, _routeMap)

app.use(bodyParser.json())
app.use(bodyParser.urlencoded({ extended: true }))
app.use(express.static("static"))


app.post('/api/asserts', upload.single('assert'), (req, res, next)->
  res.send({
    success: true
    file_path: "/api/asserts/#{req.file.filename}"
    file_name: req.file.filename
  })
)
app.get('/api/asserts/:asserts_id', (req, resp, next)->
  filename = req.params.asserts_id
  if filename.split('.').length isnt 2
    resp.set({
      'Content-Type':  'image/png'
    })
    resp.sendFile("#{_config.dest}/#{filename}")
  else
    resp.sendFile("#{_config.dest}/#{filename}")
)


app.use('/', router)

app.listen(_port)
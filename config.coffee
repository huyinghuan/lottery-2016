_ = require 'lodash'
_product = require './product-config'
_path = require 'path'

config =
  port: 3000,
  dest: _path.join(process.cwd(), 'static/avatar')
  develop: false
  img_source: '/home/ec/document/2016'
  log: _path.join(process.cwd(), "luckyList.log")


config = _.extend(config, _product)
module.exports = config
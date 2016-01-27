_ = require 'lodash'
_product = require './product-config'
_path = require 'path'

config =
  port: 3000,
  dest: _path.join(process.cwd(), 'data')
  develop: false
  img_source: '/home/ec/document/2016'


config = _.extend(config, _product)
module.exports = config
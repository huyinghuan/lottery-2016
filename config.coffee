_ = require 'lodash'
_product = require './product-config'
_path = require 'path'

config =
  port: 3000,
  dest: _path.join(process.cwd(), 'data')#解压后的文件存储位置 绝对路径
  develop: false

config = _.extend(config, _product)
module.exports = config
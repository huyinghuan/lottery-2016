_fs = require 'fs'
_fse = require 'fs-extra'
_path = require 'path'
_Coal = require('./connection').getConnection()
_config = require './config'
_Employee = _Coal.Model('employee')

_dest = _config.dest
_img_source = _config.img_source
#当前照片有冗余,不使用该方法
#checkIsInDb = (num)->
#  sql = "select count(*) from employee where num = ?"
#  _Employee.sql(sql, [num]).then((data)->
#    count = data[0]["count(*)"]
#    if count is 0
#      console.log "#{num}不存在数据库！"
#  )
#
#checkImageToDb = ->
#  _fs.readdir(_dest, (err, files)->
#    for file, index in files
#      num = file.replace(".jpg", "")
#      checkIsInDb(num)
#  )

checkDbHasImage = (num)->
  file = _path.join(_dest, "#{num}.jpg")
  if not _fs.existsSync(file)
    console.log "#{num}没有照片"

checkDBToImage = ->
  _Employee.sql("SELECT num from employee").then((data)->
    for item in data
      console.log item.num
      checkDbHasImage(item.num)
    console.log("检查完成")
  )
checkDBToImage()



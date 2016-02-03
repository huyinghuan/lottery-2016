_fs = require 'fs'
_fse = require 'fs-extra'
_path = require 'path'
_Coal = require('./connection').getConnection()
_config = require './config'


_dest = _config.dest
_img_source = _config.img_source

checkDbHasImage = (num)->
  file = _path.join(_dest, "#{num}.jpg")
  if not _fs.existsSync(file)
    console.log "#{num} 没有照片"

#检查数据库里面的人员是否都有照片．
checkDBToImage = ->
  _Employee = _Coal.Model('employee')
  _Employee.sql("SELECT num from employee").then((data)->
    for item in data
      console.log item.num
      checkDbHasImage(item.num)
    console.log("检查完成")
  )

#checkDBToImage()

checkDbHasImageLogToFile = (num)->
  file = _path.join(_dest, "#{num}.jpg")
  queue = []
  if not _fs.existsSync(file)
    queue.push(num)
  return queue


#最后核对名单
checkListFromTxt = ->
  file = _path.join(process.cwd(), "check-list.txt")
  _fs.readFile(file, 'utf8', (err, data)->
    arr = data.split('\n')
    queue = [""]
    for num in arr
      num = num.replace(/\s/g, "")
      if not _fs.existsSync(_path.join(_dest, "#{num}.jpg"))
        queue.push(num)
    #_Employee.table().select("num", "name").whereNotIn("num")
    _fs.appendFile(_path.join(process.cwd(), "no-pic.log"), queue.join("\n"), ->)
  )

checkListFromTxt()
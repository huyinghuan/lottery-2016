_fs = require 'fs'
_fse = require 'fs-extra'
_path = require 'path'
_Coal = require('./connection').getConnection()
_config = require './config'
_Employee = _Coal.Model('employee')

_dest = _config.dest
_img_source = _config.img_source

doInit = ->
  _fs.readdir(_img_source, (err, files)->
    queue = []
    for file, index in files
      prefix = file.split(".")[0]
      name = prefix.split("_")[0]
      num = prefix.split("_")[1]
      if not num?
        console.log("照片格式不符合规范，应该以  姓名_唯一工号.png  或  姓名_唯一工号.jpg 命名:", file)
        continue
      num = num.replace(/\s/g, "")
      if index > 1 and (index % 30) is 1
        console.log "本次插入#{queue.length}"
        _Employee.table().insert(queue).then(-> console.log(arguments, "成功！")).catch((e)-> console.log(e))
        queue = []

      destFile =  _path.join(_dest, "#{num}.jpg")

      _fse.copySync(_path.join(_img_source, file), destFile)

      queue.push({
        name: name
        num: num
        lucky: 0
        image: "#{num}.jpg"
      })

    console.log "本次插入#{queue.length}"
    _Employee.table().insert(queue)
    .then(->
        console.log "所有数据插入成功！"
        _Employee.sql("SELECT count(*) from employee").then((data)-> console.log(data))
    ).catch((e)-> console.log(e))
  )
#取消下面三行才会进行数据初始化，数据初始化后 记得把注释加上，避免每次数据都还原。
#setTimeout(->
#  doInit()
#, 3000)

_fs = require 'fs'
_path = require 'path'
_moment = require 'moment'
module.exports = {
  #分析奖品构成 主要是存在混合奖品的情况
  analyzeAward: (data)->
    name = data.award_name
    if name.indexOf("mix") is -1
      return [{
        id: data.award_id
        award_name: data.award_name
        count: data.count
      }]
    tmp = name.replace("mix_", "").split("_");
    queue = [];
    for item in tmp
      award = item.replace("(", "").replace(")", "").split("-")
      queue.push({
        id: parseInt(award[0]),
        count: parseInt(award[2])
        award_name: award[1]
      })
    queue

  pickLuckEmployeeByAwardFromPool: (award, pool)->
    currentLuckPeopleCount = award.count - 1
    luckEmployeeList = []
    for index in [0..currentLuckPeopleCount]
      luckyIndex = parseInt(Math.random()*(pool.length))
      luckEmployeeList.push(pool.splice(luckyIndex, 1)[0])
    luckEmployeeList

  logLuckList: (data)->
    return _fs.appendFile(_path.join(process.cwd(), "luckyList.log"), "抽奖结束！", ->) if data.end
    queue = []
    queue.push(_moment().format("YYYY-MM-DD HH:mm:ss"))
    for key, value of data
      queue.push("#{value.award_name}:")
      liststr = []
      for e in value.data
        liststr.push("#{e.num}-#{e.name}")
      queue.push(liststr.join(","))
      queue.push("\n")
    _fs.appendFile(_path.join(process.cwd(), "luckyList.log"), queue.join("\n"), ->)

}
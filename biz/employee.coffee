_async = require 'async'
_Base = require('water-pit').Base
_Coal = require('../connection').getConnection()
_Employee = _Coal.Model('employee')
_Lottery = _Coal.Model('lottery')
_utils = require '../utils'

class Employee extends _Base
  constructor: ->
    super

  get: (req, resp)->
    sql = "select id, name, num from employee where lucky = 0"
    _Employee.sql(sql).then((data)->
      resp.send(data)
    )

  getLuckyEmployee: (req, resp)->
    id = req.query.id
    sql = '''
      select E.name, E.num, A.name as award_name from employee E
        left join award A ON E.award_id = A.id
      where E.lucky = ?
    '''
    group = (list)->
      obj = {}
      for item in list
        if obj[item.award_name]
          obj[item.award_name].push(item)
        else
          obj[item.award_name] = [item]

      queue = []
      for key, value of obj
        value.push({}) if value.length % 2 is 1
        queue.push({
          award_name: key
          list: value
        })
      queue

    _Employee.sql(sql, [id]).then((data)->
      resp.send(group(data))
    )

  pickLucky: (req, resp)->
    #候选中奖名单
    pool = req.body.pool
    queue = []
    #获取奖品 #并分析
    queue.push((cb)->
      sql =
      '''
        select L.*, A.name as award_name
          from lottery L left join award A
            on L.award_id = A.id
          where happened = 0
          order by L.id ASC limit 1
      '''
      _Lottery.sql(sql).then((data)->
        #全部抽奖完成，结束．
        return cb(1) if not data[0]
        cb(null, data[0].id,  _utils.analyzeAward(data[0]))
      )
    )
    #选择中奖的人
    queue.push((luckyId, awardList, cb)->
      luckyList = []
      copyLuckyList = []
      for award in awardList
        item ={
            award_id: award.id
            award_name: award.award_name
            list: _utils.pickLuckEmployeeByAwardFromPool(award, pool)
        }
        luckyList.push(item)
        copyLuckyList.push(item)

      cb(null, luckyId, luckyList, copyLuckyList)
    )
    #消耗一次中奖
    queue.push((luckyId, luckyList, copyLuckyList, cb)->
      sql = '''
        update lottery set happened = 1 where id = ?
      '''
      _Employee.sql(sql, [luckyId]).then(->cb(null, luckyId, luckyList, copyLuckyList))
    )

    #记录中奖人的奖品id
    queue.push((luckyId, luckyList, copyLuckyList, cb)->
      _async.whilst(
        (->
          luckyList.length
        ),((next)->
          item = luckyList.pop()
          return next() if not item
          _Employee.table().whereIn('id', item.list).update({
            lucky:luckyId,
            award_id: item.award_id
          }).then(->
            next()
          )
        ),((err)->
          cb(null,  copyLuckyList)
        )
      )
    )

    #返回中奖名单
    queue.push((copyLuckyList, cb)->
      responseData = {}
      _async.whilst(
        (->
          copyLuckyList.length
        ),((next)->
          item = copyLuckyList.pop()
          return next() if not item
          _Employee.table().select().whereIn('id', item.list).then((data)->
            responseData[item.award_id] = {data:data, award_name: item.award_name}
            next()
          )
        ),((err)->
          cb(null, responseData)
        )
      )
    )

    _async.waterfall(queue, (err, result)->
      if err
        console.log("抽奖结束！")
        result = {end: true}
      resp.send(result)
      _utils.logLuckList(result)
    )

module.exports = new Employee()
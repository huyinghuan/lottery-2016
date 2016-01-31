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
    sql = '''
      select E.name, E.num, A.name as award_name from employee E
        left join award A ON E.award_id = A.id
      where lucky = 1
    '''
    _Employee.sql(sql).then((data)->
      resp.send(data)
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
        #resp.send(data[0] or {})
        cb(1) if not data[0]
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
      _Employee.sql(sql, [luckyId]).then(->cb(null, luckyList, copyLuckyList))
    )

    #记录中奖人的奖品id
    queue.push((luckyList, copyLuckyList, cb)->
      _async.whilst(
        (->
          luckyList.length
        ),((next)->
          item = luckyList.pop()
          return next() if not item
          _Employee.table().whereIn('id', item.list).update({
            lucky:1,
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
            responseData[item.award_id] = data
            next()
          )
        ),((err)->
          cb(null, responseData)
        )
      )
    )

    _async.waterfall(queue, (err, result)->
      resp.send(result)
    )

  doLucky: (req, resp)->
    data = req.body #data.luckyId
    queue = []
    queue.push((cb)->
      sql = '''
        update lottery set happened = 1 where id = ?
      '''
      _Employee.sql(sql, [data.luckyId]).then(->
        cb(null)
      )
      cb(null)
    )
    queue.push((cb)->
      award_list = data.award_list
      _async.whilst(
        (->
          award_list.length
        ),((next)->
          item = award_list.pop()
          return next() if not item
          _Employee.table().whereIn('id', item.list).update({
            lucky:1,
            award_id: item.award_id
          }).then(->
            next()
          )
        ),((err)->
          cb()
        )
      )
    )

    _async.waterfall(queue, (err, result)->
      resp.send({})
    )

module.exports = new Employee()

###
  {
    "luckyId":"29",
    "award_list":[
      {"award_id":"33","list":["247","923","824","1129"]},
      {"award_id":"34","list":["700","947","775"]},
      {"award_id":"35","list":["1140","626","369"]}
    ]
  }
###
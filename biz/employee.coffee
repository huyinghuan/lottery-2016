_Base = require('water-pit').Base
_Coal = require('../connection').getConnection()
_Employee = _Coal.Model('employee')
_async = require 'async'
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

  doLucky: (req, resp)->
    console.log(JSON.stringify(req.body));
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
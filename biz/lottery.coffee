_Base = require('water-pit').Base
_Coal = require('../connection').getConnection()
_Lottery = _Coal.Model('lottery')
class Lottery extends _Base
  constructor: ->
    super

  get: (req, resp)->
    sql = "select * from lottery where happened = 0"
    _Lottery.sql(sql).then((data)->
      resp.send(data)
    )

  post: (req, resp)->
    data = req.body
    lottery =
      award_id: data.award_id
      happened: 0
      count: data.count
    _Lottery.save(lottery).then(-> resp.sendStatus(200))

module.exports = new Employee()
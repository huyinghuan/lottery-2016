_Base = require('water-pit').Base
_Coal = require('../connection').getConnection()
_Lottery = _Coal.Model('lottery')
class Lottery extends _Base
  constructor: ->
    super

  get: (req, resp)->
    sql =
      '''
        select L.*, A.name as award_name
          from lottery L left join award A
            on L.award_id = A.id
          where happened = 0
          order by L.id ASC limit 1
      '''
    _Lottery.sql(sql).then((data)->
      resp.send(data[0] or {})
    )

  getLotteryList: (req, resp)->
    sql =
    '''
        select L.*, A.name as award_name
          from lottery L left join award A
            on L.award_id = A.id
          order by L.id
      '''
    _Lottery.sql(sql).then((data)->
      resp.send(data)
    )

  post: (req, resp)->
    data = req.body
    lottery =
      award_id: data.award_id
      happened: 0
      count: data.count
    _Lottery.save(lottery).then(-> resp.send({}))

  delete: (req, resp)->
    id = req.params.id
    sql =  "delete from lottery where id = ? and locked is not 1"
    _Lottery.sql(sql, [id]).then(->
      resp.send({})
    ).catch((e)-> console.log arguments)

  locked: (req, resp)->
    locked =  parseInt(req.body.locked)
    locked = 1 if isNaN(locked)
    sql = "update lottery set locked = ? where id > 0"
    _Lottery.sql(sql, [locked]).then(->
      resp.send({})
    )

  hasHappened: (req, resp)->
    id = req.params.id
    sql = "update lottery set happened = 1 where id = ?"
    _Lottery.sql(sql, [id]).then(->
      resp.send({})
    )

module.exports = new Lottery()
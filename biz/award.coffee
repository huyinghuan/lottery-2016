_Base = require('water-pit').Base
_Coal = require('../connection').getConnection()
_Award = _Coal.Model('award')
class Award extends _Base
  constructor: ->
    super

  get: (req, resp)->
    sql = "select * from award"
    _Award.sql(sql).then((data)->
      resp.send(data)
    )

  post: (req, resp)->
    award = name: req.body.name
    _Award.save(award).then(-> resp.send({}))

  delete: (req, resp)->
    id = req.params.id
    sql = "delete from award where id = ?"
    _Award.sql(sql, [id]).then((data)->
      resp.send({})
    )

module.exports = new Award()
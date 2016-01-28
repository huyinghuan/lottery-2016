_Base = require('water-pit').Base
_Coal = require('../connection').getConnection()
_Employee = _Coal.Model('employee')
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
    resp.send(1)

module.exports = new Employee()
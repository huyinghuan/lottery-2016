_Coal = require('./connection').getConnection()
_Employee = _Coal.Model('employee')

addEmployee = ->
  queue = []

  for i in [0..100]
    queue.push({
      name: 'test' + i
      image: 'avar.jpg'
      num: i
      lucky: 0
      award_id: 0
    })

  _Employee.save(queue).then(->)

deleteAll = ->
  _Employee.sql("delete from employee where id > 1").then(->)

#addEmployee()
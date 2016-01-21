_Coal = require('./connection').getConnection()
_Employee = _Coal.Model('employee')

addEmployee = ->
  queue = []

  for i in [0..100]
    lucky = if Math.random() > 0.7 then 1 else 0
    award_id = if lucky then parseInt(Math.random() * 6) + 10 else 0
    queue.push({
      name: 'test' + i
      image: 'avar.jpg'
      num: i
      lucky: lucky
      award_id: award_id
    })

  _Employee.save(queue).then(->)

resetAll = ->
  _Employee.sql("delete from employee where id > 0").then(->
    addEmployee()
  )

resetAll()
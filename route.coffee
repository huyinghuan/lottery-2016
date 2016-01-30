path = require 'path'
module.exports =
  "cwd": path.join(__dirname, 'biz'),
  "baseUrl": "/api",
  "map": [
    {
      path: '/employee'
      biz: 'employee'
    }
    {
      path: '/lucky'
      biz: 'employee'
      methods:
        GET: 'getLuckyEmployee', POST: 'doLucky'
    }
    {
      path: '/lottery'
      biz: 'lottery'
      methods:
        DELETE: false, PUT: 'locked'
    }
    {
      path: '/lotteryList'
      biz: 'lottery'
      methods:
        DELETE: false, PUT: false, POST: false, GET: 'getLotteryList'
    }
    {
      path: '/lottery/:id'
      biz: 'lottery'
      methods:
        GET: false, POST: false, PUT: 'hasHappened'
    }
    {
      path: '/award'
      biz: 'award'
      methods:
        PUT: false, DELETE: false
    }
    {
      path: '/award/:id'
      biz: 'award'
      methods:
        GET: false, PUT: false, POST: false
    }
  ]
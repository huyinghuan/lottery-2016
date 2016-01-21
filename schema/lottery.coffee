module.exports =
  name: 'lottery'
  fields:
    award_id: 'biginteger' #奖品id
    count: 'integer' #中奖人数
    happened: 'integer' #是否已经发生
    locked: 'integer' #锁定不允许删除
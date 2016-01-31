module.exports = {
  #分析奖品构成 主要是存在混合奖品的情况
  analyzeAward: (data)->
    name = data.award_name
    return [data] if name.indexOf("mix") is -1
    tmp = name.replace("mix_", "").split("_");
    queue = [];
    for item in tmp
      award = item.replace("(", "").replace(")", "").split("-")
      queue.push({
        id: parseInt(award[0]),
        award_name: award[1],
        count: parseInt(award[2])
      })
    queue

  pickLuckEmployeeByAwardFromPool: (award, pool)->
    currentLuckPeopleCount = award.count - 1
    luckEmployeeList = []
    for index in [0..currentLuckPeopleCount]
      luckyIndex = parseInt(Math.random()*(pool.length))
      luckEmployeeList.push(pool.splice(luckyIndex, 1)[0])
    luckEmployeeList
}
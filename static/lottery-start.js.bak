var _employeeList = [];
var _stop = false;
//头像的样式列表
var avatarClazzList = ["w-01", "w-02", "w-03", "w-04", "m-01", "m-02", "m-03", "m-04"];

//获取随机头像样式
var getRandomAvatarClazz = function(){
  return avatarClazzList[parseInt(Math.random() * 8)];
};

var currentAward = null;
//当前抽奖的ID
var _luckyId = 0;
/**
 * 由于有些抽奖包含多个奖品，因此需要进行字符串提取（非常不优雅的实现）*/
var setCurrentAward = function(data){
  _luckyId = data.id;
  var name = data.award_name;
  if(name.indexOf("mix") == -1){
    currentAward = [data];
    return;
  }
  var tmp = name.replace("mix_", "").split("_");
  var queue = [];
  for(var index = 0, len = tmp.length; index < len; index++){
    var item = tmp[index].replace("(", "").replace(")", "").split("-");
    queue.push({
      id: parseInt(item[0]),
      award_name: item[1],
      count: parseInt(item[2])
    })
  }
  currentAward = queue;
};
var getCurrentAward = function(){
  return currentAward;
};

var getDivDom = function(id, num, name, left){
  var arr = [id, id, num, name, left, getRandomAvatarClazz(), num];
  var div = '<div id="avatar_?" class="ul-box" data-id="?" data-num="?" data-name="?" style="left: ?px">' +
    '<a href="" class="img-box ?"><i><img src="/avatar/?.jpg"></i></a></div>';
  for(var index = 0, len = arr.length; index < len; index++){
    div = div.replace(/\?/, arr[index])
  }
  return div;
};

var getRandomItem = function(){
  var length = _employeeList.length;
  var index = parseInt(Math.random() * length);
  var tmp = _employeeList.splice(index, 1);
  return tmp[0]
};
//动画
var ani = function(left, easing, duration){
  var $pool = $(".bgbox");
  var timer = setInterval(function(){
    if(_stop){
      clearInterval(timer);
      return;
    }
    var item = getRandomItem();
    var dom = getDivDom(item.id,  item.num, item.name, left);
    $pool.append(dom);
    $pool.find("#avatar_"+item.id+"").animate({top: "-200px"}, {
      duration: duration,
      complete: function () {
        _employeeList.push({
          id: $(this).data('id'),
          num: $(this).data('num'),
          name: $(this).data('name')
        });
        $(this).remove()
      },
      fail: function(){ }
    })
  }, duration/10, 'linear')
};

var startScroll = function(){
  var durationQueue = [7000, 6000, 5000,4000, 4000, 5000, 6000, 7000];
  var leftQueue = [114, 114+200*1+10, 114+200*2+20, 114+200*3+40, 114+200*4+50, 114+200*5+70,114+200*6+80,114+200*7+100];
  var easingQueue = ["easeOutQuad", "easeInOutCubic", "linear", "easeInOutCirc"];
  for(var index = 0; index < 8; index++){
    ani(leftQueue[index], easingQueue[index%4], durationQueue[index%8])
  }
};

//选择中奖人员
var pickLuckyPeople = function(){
  var employeePool = [];
  $(".bgbox").find("div").each(function(){
    var top = parseInt($(this).css("top").replace("px", ""));
    if(top < -180){return;}
    if(top > 1080){return;}
    employeePool.push({
      id: parseInt($(this).data("id")),
      name: $(this).data("name"),
      num: $(this).data("num")
    })
  });
  //奖品列表
  var awardList = getCurrentAward();

  //中奖名单
  var luckyList = {};

  //根据奖品抽人
  for(var index = 0, length = awardList.length; index < length; index++){
    var award = awardList[index];
    var currentLuckPeopleCount = award.count;
    for(var j = 0; j < currentLuckPeopleCount; j++){
      var luckyIndex = parseInt(Math.random()*(employeePool.length));
      var luckEmployee = employeePool.splice(luckyIndex, 1)[0];
      if(!luckyList[award.id]){
        luckyList[award.id] = [luckEmployee];
      }else{
        luckyList[award.id].push(luckEmployee);
      }
    }
  }
  return luckyList;
};

//上传中奖名单
var postLuckyList = function(data, cb){
  var postData = {luckyId: _luckyId, award_list: []};
  for(var award_id in data){
    postData.award_list.push({
      award_id: award_id,
      list: _.map(data[award_id], 'id')
    })
  }
  API.post("lucky", postData, function(){cb && cb()});
};

//展示中奖名单
var showLuckList = function(data){
  var templateId = 0;
  var context = [];
  for(var award_id in data){
    templateId = templateId + Math.pow(data[award_id].length, 2);
    context.push({
      award_id: award_id,
      count: data[award_id].length,
      luckyList: data[award_id]
    })
  }
  context = _.orderBy(context, ['count'], ['desc']);
  var templateSource = $("#lotteryListTemplate_"+templateId).html();
  var template = Handlebars.compile(templateSource);
  var html = template({list: context});
  $(".cj2016-box").html(html).show();

};

//开始抽奖
var start = function(){
  $(".cj2016-box").hide();
  //bgMusic.play();
  $(".bgbox").html("");
  var queue = [];
  //获取中奖奖品
  queue.push(function(cb){
    API.get("lottery", function (data) {
      setCurrentAward(data);
      cb()
    });
  });
  //加载员工列表
  queue.push(function(cb){
    API.get("employee", function(data){
      _employeeList = data;
      cb()
    });
  });

  //开始动画
  async.waterfall(queue, function(){
    startScroll()
  })
};

start();

//操作失误
var hasDone = false;
//操作间隔
var operationalInterval = 3000;

//回车暂停抽奖
$(document).bind('keyup.return', function(){
  if(hasDone){
    return;
  }
  hasDone = true;
  setTimeout(function(){hasDone = false}, operationalInterval);
  if(!_stop){
   $(".ul-box").stop();
   // bgMusic.pause();
   // stopMusic.play();
    var luckyList = pickLuckyPeople();
    //提交中奖名单到服务器
    postLuckyList(luckyList, function(){
      showLuckList(luckyList)
    });
    _stop = true;
  }else{
    _stop = false;
    start();
  }
});

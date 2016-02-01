var _employeeList = [];
var _stop = false;
//头像的样式列表
var avatarClazzList = ["w-01", "w-02", "w-03", "w-04", "m-01", "m-02", "m-03", "m-04"];

//获取随机头像样式
var getRandomAvatarClazz = function(){
  return avatarClazzList[parseInt(Math.random() * 8)];
};

var getDivDom = function(id, num, name, left){
  var arr = [id, id, num, name, left, getRandomAvatarClazz(), num];
  var div = '<div id="avatar_?" class="ul-box" data-id="?" data-num="?" data-name="?" style="left: ?px">' +
    '<a class="img-box ?"><i><img src="/avatar/?.jpg"></i></a></div>';
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

//选择中奖人员 进入了池不代表中奖
var pickLuckyPeoplePool = function(){
  var employeePool = [];
  $(".bgbox").find("div").each(function(){
    var top = parseInt($(this).css("top").replace("px", ""));
    if(top < -180){return;}
    if(top > 1080){return;}
    employeePool.push(parseInt($(this).data("id")))
  });
  return employeePool;
};

//展示中奖名单
var showLuckList = function(data){
  var templateId = 0;
  var context = [];
  for(var award_id in data){
    templateId = templateId + Math.pow(data[award_id].data.length, 2);
    context.push({
      award_id: award_id,
      count: data[award_id].data.length,
      luckyList: data[award_id].data,
      award_name: data[award_id].award_name
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
  API.get("employee", function(data){
    _employeeList = data;
    startScroll()
  });
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
    var luckyList = pickLuckyPeoplePool();
    //提交中奖候选名单到服务器
    API.post("lucky", {pool: luckyList}, function(data){
      //$(".cj2016-wow").addClass("wow-show");
      if(data.end){
        alert("抽奖结束！");
        return;
      }
      showLuckList(data);
      //$(".cj2016-wow").removeClass("wow-show");
    });

    _stop = true;
  }else{
    _stop = false;
    start();
  }
});

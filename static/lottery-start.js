var _employeeList = [];
var _stop = false;
//头像的样式列表
var avatarClazzList = ["w-01", "w-02", "w-03", "w-04", "m-01", "m-02", "m-03", "m-04"];

//获取随机头像样式
var getRandomAvatarClazz = function(){
  return avatarClazzList[parseInt(Math.random() * 8)];
};

var currentAward = null;
var setCurrentAward = function(data){

};
var getCurrentAward = function(data){
  currentAward = data
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
  }, 300, 'linear')
};

var startScroll = function(){
  var durationQueue = [2000, 3000, 4000, 4000, 3000, 2000, 3000, 2000];
  var leftQueue = [114, 114+200*1+10, 114+200*2+20, 114+200*3+40, 114+200*4+50, 114+200*5+70,114+200*6+80,114+200*7+100];
  var easingQueue = ["easeOutQuad", "easeInOutCubic", "linear", "easeInOutCirc"];
  for(var index = 0; index < 8; index++){
    ani(leftQueue[index], easingQueue[index%4], durationQueue[index%2])
  }
};

var start = function(){
  bgMusic.play();
  $(".bgbox").html("");
  var queue = [];
  //获取中奖奖品
  queue.push(function(cb){
    API.get("award", function (data) {
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

$(document).bind('keyup.return', function(){
  if(hasDone){
    return;
  }
  hasDone = true;
  setTimeout(function(){hasDone = false}, operationalInterval);
  if(!_stop){
    $(".ul-box").stop();
    bgMusic.pause();
    stopMusic.play();
    console.log("选择中奖！");
    _stop = true;
  }else{
    //init(generateLoopBlock);
    _stop = false;
    start();
  }
});
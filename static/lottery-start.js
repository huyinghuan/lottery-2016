_employeeList = [];
//头像的样式列表
var avatarClazzList = ["w-01", "w-02", "w-03", "w-04", "m-01", "m-02", "m-03", "m-04"];

//获取随机头像样式
var getRandomAvatarClazz = function(){
  return avatarClazzList[parseInt(Math.random() * 9)];
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

var ani = function(left){
  var $pool = $(".bgbox");
  setInterval(function(){
    var item = getRandomItem();
    var dom = getDivDom(item.id,  item.num, item.name, left);
    $pool.append(dom);
    $pool.find("#avatar_"+item.id+"").animate({top: "-200px"}, {
      duration: 3000,
      complete: function () {
        console.log($(this).data('id'));
        $(this).remove()
      },
      fail: function(){ }
    })
  }, 300)
};

var startScroll = function(){

  var leftQueue = [114, 114+200*1+10, 114+200*2+10, 114+200*3+10, 114+200*4+10, 114+200*5+10,114+200*6+10,114+200*7+10];
  for(var index = 0; index < 8; index++){
    ani(leftQueue[index%8])
  }

};

var start = function(){
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

  //
  //queue.push(function(emploeyList, cb){
  //  var leftQueue = [114, 114+200*1+10, 114+200*2+10, 114+200*3+10, 114+200*4+10, 114+200*5+10,114+200*6+10,114+200*7+10];
  //  var b = new Date().getTime();
  //  for(var index = 0, length = emploeyList.length; index < length; index++){
  //    var item = emploeyList[index];
  //    var div = getDivDom(item.id, item.num, item.name,  leftQueue[index%8]);
  //    $avatarPool.append(div)
  //  }
  //  console.log(new Date().getTime() - b);
  //  cb()
  //});

  //开始动画
  async.waterfall(queue, function(){
    startScroll()
  })
};

start();
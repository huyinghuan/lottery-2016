$(function(){

  var awardOptionListTemplateSource = $("#awardOptionList").html();
  var awardOptionListTemplate = Handlebars.compile(awardOptionListTemplateSource);

  var lotteryTableTemplateSource = $("#tableListTR").html();
  var lotteryTableTemplate = Handlebars.compile(lotteryTableTemplateSource);

  Handlebars.registerHelper("getIndex", function(index){return index + 1});

  var bindDelEvent = function(){
    $("#awardListTable").find("button").click(function(){
      API.delete('lottery', {id: $(this).data('id')}, function(){
        reloadLotteryList();
      })
    })
  };


  //加载奖品列表
  var reloadAwardList = function(){
    API.get('award', function(data){
      var html = awardOptionListTemplate({awardList: data});
      $("#award_id").html(html);
    })
  };

  reloadAwardList();

  //加载抽奖顺序列表
  var reloadLotteryList = function(){
    API.get('lotteryList', function(data){
      var html = lotteryTableTemplate({lotteryList: data});
      $("#awardListTable").html(html);
      //bindDelEvent();
    })
  };

  reloadLotteryList();

  $("#addAwardBtn").click(function(){
    var awardCount = +$("#award_count").val();
    if(!awardCount || awardCount < 1){
      return alert("奖品数量不能小于１");
    }
    var award_id = $("#award_id").val();

    API.post('lottery', {award_id: award_id, count: awardCount}, function(){
      reloadLotteryList();
    })
  });

  $("#lockedLotteryList").click(function(){
    API.put("lottery", {locked: 1},function(){alert("锁定成功，现在无法删除抽奖流程！")})
  });

  $("#unlockedLotteryList").click(function(){
    var flag = confirm("是否确定解锁流程？正式运行时不推荐解锁！");
    if(!flag){
      return;
    }
    API.put("lottery", {locked: 0},function(){alert("解锁成功，现在修改抽奖流程！")})
  })

});
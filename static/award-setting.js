$(function(){

  var templateSource = $("#tableListTR").html();
  var template = Handlebars.compile(templateSource);

  var bindDelEvent = function(){
    $("#awardListTable").find("button").click(function(){
      API.delete('award', {id: $(this).data('id')}, function(){
        console.log(2);
        reloadAwardList();
      })
    })
  };

  //加载奖品列表
  var reloadAwardList = function(){
    API.get('award', function(data){
      var html = template({awardList: data});
      $("#awardListTable").html(html);
      bindDelEvent()
    })
  };

  reloadAwardList();

  $("#addAwardBtn").click(function(){
    var awardName = $("#award_name").val();
    if(!awardName){
      return alert("奖品名称不能为空");
    }
    API.post('award', {name: awardName}, function(){
      reloadAwardList()
    })
  })
});
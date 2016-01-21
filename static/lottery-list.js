$(function(){
  var templateSource = $("#tableTr").html();
  var template = Handlebars.compile(templateSource);
  API.get("lucky", function(data){
    $("#employeeListTable").html(template({employeeList: data}))
  });
});
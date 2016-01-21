;(function(global){

  var ajax = function(url, type, data, cb){
    url  = "/api/" + url;
    if(data && data.id){
      url = url + "/" + data.id;
      delete data.id
    }

    $.ajax(url, {
      data: data,
      dataType: 'json',
      method: type,
      success: cb,
      error: function(){console.log(arguments)}
    })
  };
  global.API = {
    get: function(url, data, cb){
      if(typeof data === 'function'){
        cb = data;
        data = {}
      }
      ajax(url, 'GET', data, cb)
    },
    post: function(url, data, cb){
      ajax(url, 'POST', data, cb)
    },
    put: function(url, data, cb){
      ajax(url, 'PUT', data, cb)
    },
    delete: function(url, data, cb){
      ajax(url, 'DELETE', data, cb)
    }
  }

})(window);
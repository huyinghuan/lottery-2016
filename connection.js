_config =  require('./config');
_isDev = _config.develop
var _Coal = require('coal');

_coal = new _Coal({
  database: {
    client: "sqlite3",
    connection: {
      filename: "./db.sqlite"
    }
  },
  schema: "schema"
}, _isDev);

exports.getConnection = function(){
  return _coal;
}
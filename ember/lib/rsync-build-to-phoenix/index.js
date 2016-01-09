/*jshint node:true*/
var exec = require('child_process').execSync;
module.exports = {
  name: 'rsync-build-to-phoenix',

  postBuild: function(results) {
    var target = "../priv/static/ember/";
    var source = results.directory + "/";
    exec("mkdir -p " + target);
    exec("rsync -acL " + source + " " + target);
    exec("rsync -acL dist/index.html ../web/templates/ember/index.html.eex");
  }
};


/** @jsx m */

(function() {
  require(["jquery", "mithril", "home/home", "login/login", "register/register", "manga/viewer", "lodash", "TweenMax", "bootstrap"], function($, m, home, login, register, viewer) {
    $(document).ready(function() {
      m.route.mode = "hash";
      m.route(document.getElementById("route"), "/", {
        "/login": login,
        "/register": register,
        "/": home,
        "/viewer/:link...": viewer
      });
    });
  });

}).call(this);
// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

;

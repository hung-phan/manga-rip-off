###* @jsx m ###
require [
  "jquery"
  "mithril"
  "home/home"
  "login/login"
  "register/register"
  "lodash"
  "TweenLite"
  "bootstrap"
], ($, m, home, login, register) ->
  $(document).ready ->

    #setup routes to start w/ the `#` symbol
    m.route.mode = "hash"

    #routing configuration
    m.route document.getElementById("route"), "/",
      "/login": login
      "/register": register
      "/": home

    return

  return

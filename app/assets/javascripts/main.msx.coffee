###* @jsx m ###
require [
  "jquery"
  "mithril"
  "home/home"
  "login/login"
  "register/register"
  "manga/viewer"
  "lodash"
  "TweenMax"
  "bootstrap"
], ($, m, home, login, register, viewer) ->
  $(document).ready ->

    #setup routes to start w/ the `#` symbol
    m.route.mode = "hash"

    #routing configuration
    m.route document.getElementById("route"), "/",
      "/login": login
      "/register": register
      "/": home
      "/viewer/:link...": viewer

    return

  return

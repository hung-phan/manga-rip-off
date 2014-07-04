###* @jsx m ###
define [
  "mithril"
  "navigation/navigation"
], (m, navigation) ->
  "use strict"

  #namespace for app
  app = {}

  #controller
  app.controller = ->
    @navigationCtrl = new navigation.controller()
    return

  #view
  app.view = (ctrl) ->
    `<div>
      {navigation.view(ctrl.navigationCtrl)}
      <div class="container">
        Inner contain
      </div>
    </div>`

  app

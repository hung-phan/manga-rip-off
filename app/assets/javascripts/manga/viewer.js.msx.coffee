###* @jsx m ###
define [
  "mithril"
  "navigation/navigation"
], (m, navigation) ->
  "use strict"

  #namespace for viewer
  viewer = {}

  #controller
  viewer.controller = ->
    # init
    @pages = m.prop([])
    @navigationCtrl = new navigation.controller()

    data =
      link: m.route.param("link")

    m.request(method: "POST", url: "/api/v1/batoto/view", background: true, data: data, config: ((xhr) ->
      xhr.setRequestHeader "Content-Type", "application/json"
    )).then(@pages).then(m.redraw)

    return

  #view
  viewer.view = (ctrl) ->
    `<div>
      {navigation.view(ctrl.navigationCtrl)}
      <div class="container">
        {_.map(ctrl.pages(), function(page, i) {
          return <img src={page} alt={"page " + i}/>
        })}
      </div>
    </div>`

  viewer

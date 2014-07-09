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
    @pages          = m.prop([])
    @loading        = m.prop(true)
    @prev           = m.prop("")
    @next           = m.prop("")
    @navigationCtrl = navigation.sharedController

    # function
    @addStyle = (base, style)->
      base + style

    data =
      link: decodeURIComponent(m.route.param("link"))

    m.request(method: "POST", url: "/api/v1/batoto/view", background: true, data: data, config: ((xhr) ->
      xhr.setRequestHeader "Content-Type", "application/json"
    )).then(((response)->
      @pages(response['images'])
      @prev(encodeURIComponent(response['prev']))
      @next(encodeURIComponent(response['next']))
      @loading(false)
      m.redraw()
    ).bind(this))

    return

  #view
  viewer.view = (ctrl) ->
    `<div>
      {navigation.view(ctrl.navigationCtrl)}
      <div class="container">
        <a href={'#/viewer/' + ctrl.prev()}
          class="btn btn-primary view-button"
          style={!ctrl.loading() ? ctrl.addStyle('display:inline;', 'left:2%;') : ctrl.addStyle('display:none;', 'left:2%;')}>Previous</a>
        <a href={'#/viewer/' + ctrl.next()}
          class="btn btn-primary view-button"
          style={!ctrl.loading() ? ctrl.addStyle('display:inline;', 'right:2%;') : ctrl.addStyle('display:none;', 'right:2%;')}>Next</a>

        <div class="row">
          <div class="col-md-12 text-center">
            <h2><strong>Lorem Ipsum</strong></h2>
            <span style={ctrl.loading() ? 'display:inline;' : 'display:none;'}>
              <i class="fa fa-4x fa-spin fa-refresh"></i>
            </span>
          </div>
        </div>
        <div class="row">
          {_.map(ctrl.pages(), function(page, i) {
            return <img class="col-md-10 col-md-offset-1 text-center" src={page} alt={"page " + i}/>
          })}
        </div>

      </div>
    </div>`

  viewer

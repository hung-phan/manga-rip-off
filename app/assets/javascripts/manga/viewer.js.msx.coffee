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
    @title          = m.prop("")
    @navigationCtrl = navigation.sharedController

    # function
    @addStyle = (base, style)->
      base + style

    data =
      link: decodeURIComponent(m.route.param("link"))

    m.request(method: "POST", url: "/api/v1/kissmanga/view", background: true, data: data, config: ((xhr) ->
      xhr.setRequestHeader "Content-Type", "application/json"
    )).then(((response)->
      @pages(response['images'])
      @title(response['title'])
      @loading(false)

      # check if previous link exist
      if response['prev']
        @prev(encodeURIComponent(response['prev']))
      else
        @prev(false)

      # check if next link exist
      if response['next']
        @next(encodeURIComponent(response['next']))
      else
        @next(false)

      # redraw
      m.redraw()

      return
    ).bind(this))

    return

  #view
  viewer.view = (ctrl) ->
    `<div>
      {navigation.view(ctrl.navigationCtrl)}
      <div class="container">
        <a href={'#/viewer/' + ctrl.prev()}
          class="btn btn-default view-button"
          style={!ctrl.loading() && ctrl.prev() ? ctrl.addStyle('display:inline;', 'left:2%;') : ctrl.addStyle('display:none;', 'left:2%;')}>
          <i class="fa fa-2x fa-arrow-left"></i>
        </a>
        <a href={'#/viewer/' + ctrl.next()}
          class="btn btn-default view-button"
          style={!ctrl.loading() && ctrl.next() ? ctrl.addStyle('display:inline;', 'right:2%;') : ctrl.addStyle('display:none;', 'right:2%;')}>
          <i class="fa fa-2x fa-arrow-right"></i>
        </a>
        <div class="row">
          <div class="col-md-12 text-center">
            <h2><strong>{ctrl.title()}</strong></h2>
            <span style={ctrl.loading() ? 'display:inline;' : 'display:none;'}>
              <i class="fa fa-4x fa-spin fa-refresh"></i>
            </span>
          </div>
        </div>
        <div class="row">
          <div class="col-xs-12 col-sm-12 col-md-12">
            {_.map(ctrl.pages(), function(page, i) {
              return (
                <div class="row">
                  <img class="col-xs-12 col-sm-12 col-md-10 col-md-offset-1 text-center" src={page} alt={"page " + i}/>
                </div>
              );
            })}
          </div>
        </div>

      </div>
    </div>`

  viewer

###* @jsx m ###
define [
  "mithril"
  "navigation/navigation"
  "manga/sidebar"
  "manga/menu-link"
], (m, navigation, sidebar, menuLink) ->
  "use strict"

  # namespace for viewer
  viewer = {}

  # controller
  viewer.controller = ->
    # init
    @pages          = m.prop([])
    @loading        = m.prop(true)
    @title          = m.prop("")
    @navigationCtrl = navigation.sharedController
    @sidebarCtrl    = new sidebar.controller()
    @menuLinkCtrl   = new menuLink.controller(@sidebarCtrl.toggleSideBar)

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
        @sidebarCtrl.prev(encodeURIComponent(response['prev']))
      else
        @sidebarCtrl.prev(false)

      # check if next link exist
      if response['next']
        @sidebarCtrl.next(encodeURIComponent(response['next']))
      else
        @sidebarCtrl.next(false)
      # assign chapters to sidebar
      @sidebarCtrl.chapters(response['chapters'])

      # redraw
      m.redraw()

      return
    ).bind(this))

    return

  # TODO Add chapters_list to sidebar menu

  # view
  viewer.view = (ctrl) ->
    `<div>
      {navigation.view(ctrl.navigationCtrl)}
      {sidebar.view(ctrl.sidebarCtrl)}
      {menuLink.view(ctrl.menuLinkCtrl)}
      <div class="container">
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

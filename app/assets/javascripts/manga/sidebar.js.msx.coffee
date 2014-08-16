###* @jsx m ###
define [
  "mithril"
  "helper/routing"
  "sidebar"
], (m, routing) ->
  "use strict"

  # sidebar component
  sidebarComponent = undefined
  isSidebarShow    = false
  # name space for sidebar
  sidebar          = {}

  # config
  sidebar.config = (ctrl)->
    (element, isInitialized)->
      el = $(element)
      if not isInitialized
        # store DOM node of sidebar component
        # for attach event to it latter
        sidebarComponent = el
        el.mmenu(
          classes: "mm-light"
          header: true
        )
      return

  # controller
  sidebar.controller = ->
    #init
    @prev     = m.prop("")
    @next     = m.prop("")
    @chapters = m.prop([])

    #handler
    @toggleSideBar = ->
      if !isSidebarShow
        sidebarComponent.trigger("open.mm")
      else
        sidebarComponent.trigger("close.mm")

    @changePage = (event)->
      routing.path "/viewer/#{encodeURIComponent(event.target.value)}"

    return

  # view
  sidebar.view = (ctrl)->
    `<nav config={sidebar.config(ctrl)}>
      <ul>
        <li>
          <select style="width: 100%;" onchange={ctrl.changePage.bind(ctrl)}>
            {_.map(ctrl.chapters(), function(chapter) {
              return (
                chapter.selected ? <option selected value={chapter.value}>{chapter.title}</option>
                                 : <option value={chapter.value}>{chapter.title}</option>
              );
            })}
          </select>
        </li>
        <li>
          <a class="text-center">
            <a class="btn btn-default" href={"#/viewer/" + ctrl.prev()}
              style={ctrl.prev() ? "display: inline-block;" : "display:none;"}>
              <i class="fa fa-2x fa-arrow-left"></i>
            </a>
            <a class="btn btn-default" href={"#/viewer/" + ctrl.next()}
              style={ctrl.next() ? "display:inline-block;" : "display:none;"}>
              <i class="fa fa-2x fa-arrow-right"></i>
            </a>
          </a>
        </li>
        <li>
          <a class="text-center">
            <a href="#/" class="btn btn-default">Back to Home Page</a>
          </a>
        </li>
      </ul>
    </nav>`

  sidebar

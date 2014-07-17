###* @jsx m ###
define [
  "mithril"
], (m) ->
  "use strict"

  # namespace for link
  menuLink          = {}
  menuLinkComponent = undefined

  # config
  menuLink.config = (ctrl)->
    (element, isInitialized)->
      el = $(element)
      if not isInitialized
        menuLinkComponent = el
        fixDiv = ->
          if $(window).scrollTop() > 100
            el.css
              position: "fixed"
              top: "0px"

          else
            el.css
              position: "relative"
              top: "auto"

          return
        $(window).scroll fixDiv
        fixDiv()
      return

  menuLink.controller = (func)->
    @func     = func
    @isShowed = m.prop(false)
    @callFunc = (->
      if @isShowed
        menuLinkComponent.css
          position: "relative"
          top: "auto"
      else
        menuLinkComponent.css
          position: "fixed"
          top: "0px"

      @isShowed(not @isShowed())
      @func()

      return
    ).bind(this)
    return

  menuLink.view = (ctrl)->
    `<a config={menuLink.config(ctrl)} class="btn btn-default menu-fixed" onclick={ctrl.callFunc.bind(ctrl)}>
      <span class="menu-hide">Menu</span>&nbsp;<i class="fa fa-align-justify"></i>
    </a>`

  menuLink

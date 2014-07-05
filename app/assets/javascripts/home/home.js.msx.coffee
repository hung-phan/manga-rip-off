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
    @timeout = undefined
    @navigationCtrl = new navigation.controller()
    @searchManga = ((event)->
      if @timeout
        clearTimeout @timeout
        @timeout = undefined
      @timeout = setTimeout(
        () ->
          m.request(method: "GET", url: "/api/v1/batoto/#{event.target.value}", config: ((xhr) ->
            xhr.setRequestHeader "Content-Type", "application/json"
          )).then(
            (response) ->
              console.log response
              return
            , (error) ->
              alert error.error
              return
          )
          return
        , 500)
    ).bind(this)
    return

  #view
  app.view = (ctrl) ->
    `<div>
      {navigation.view(ctrl.navigationCtrl)}
      <div class="container">
        <div class="row">
          <input type="text" class="col-xs-12 col-sm-10 col-sm-offset-2 col-md-7 col-md-offset-5 search-box status-form"
            placeholder="Manga name ..." oninput={ctrl.searchManga.bind(ctrl)}/>
        </div>
        <div class="row">
          <div class="col-md-12">
            Content
          </div>
        </div>
      </div>
    </div>`

  app

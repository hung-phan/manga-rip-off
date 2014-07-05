###* @jsx m ###
define [
  "mithril"
  "navigation/navigation"
], (m, navigation) ->
  "use strict"

  #namespace for app
  app = {}

  # app model
  app.model = (href, title)->
    @href  = m.prop(href)
    @title = m.prop(title)
    return

  app.AppList = Array

  #controller
  app.controller = ->
    @mangaList = new app.AppList()
    @timeout = undefined
    @navigationCtrl = new navigation.controller()

    # event handle
    mangaList = @mangaList
    @searchManga = ((event)->
      # clear timeout if exists
      if @timeout
        clearTimeout @timeout
        @timeout = undefined

      # do nothing if value is empty
      if event.target.value is ""
        mangaList.length = 0
        return

      # timeout function for request
      @timeout = setTimeout(
        ->
          m.request(method: "GET", url: "/api/v1/batoto/#{event.target.value}", config: ((xhr) ->
            xhr.setRequestHeader "Content-Type", "application/json"
          )).then(
            (response) ->
              mangaList.length = 0
              _.each(response, (mangaBook)->
                mangaList.push new app.model(mangaBook.href, mangaBook.title)
                return
              )
            , (error) ->
              alert error.error
          )
          return
        , 500)
    ).bind(this)

    # animation for element
    @enterEvent = (event)->
      console.log event.target

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
            {_.map(ctrl.mangaList, function(mangaBook, i) {
              return (<h4 onenter={ctrl.enterEvent.bind(ctrl)}>{i + 1}. {mangaBook.title()}</h4>);
            })}
          </div>
        </div>
      </div>
    </div>`

  app

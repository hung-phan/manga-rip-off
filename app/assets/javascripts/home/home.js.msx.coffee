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
    @mangaList      = new app.AppList()
    @timeout        = undefined
    @navigationCtrl = new navigation.controller()
    @currentManga   = undefined
    @loadMangaList  = false

    registerLoadEvent = (->
      @loadMangaList = true
    ).bind(this)

    clearLoadEvent = (->
      @loadMangaList = false
    ).bind(this)

    # event handle
    mangaList     = @mangaList
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
          registerLoadEvent()
          m.request(method: "GET", url: "/api/v1/batoto/#{event.target.value}", config: ((xhr) ->
            xhr.setRequestHeader "Content-Type", "application/json"
          )).then(
            (response) ->
              mangaList.length = 0
              _.each(response, (mangaBook)->
                mangaList.push new app.model(mangaBook.href, mangaBook.title)
                return
              )
              clearLoadEvent()
            , (error) ->
              alert error.error
              clearLoadEvent()
          )
          return
        , 500)
    ).bind(this)

    @mangaSelectEvent = ((mangaBook)->
      @currentManga = mangaBook
    ).bind(this)

    # animation for element
    @enterEvent = (event)->
      TweenLite.to event.target, 0.2, {
        backgroundColor: 'black',
        color: '#89CD25'
      }
      return

    @leaveEvent = (event)->
      TweenLite.to event.target, 0.2, {
        backgroundColor: 'none',
        color: 'black'
      }
      return

    return

  #view
  app.view = (ctrl) ->
    `<div>
      {navigation.view(ctrl.navigationCtrl)}
      <div class="container">
        <div class="row">
          <input type="text" class="col-xs-12 col-md-6 col-md-offset-6 search-box status-form"
            placeholder="Manga name ..." oninput={ctrl.searchManga.bind(ctrl)}/>
        </div>
        <div class="row">
          <div class="col-md-6">
            <div class="row" style={ctrl.loadMangaList ? "display:block;" : "display:none;"}>
              <div class="col-md-12">
                <i class="fa fa-spin fa-refresh"></i>
              </div>
            </div>
            {_.map(ctrl.mangaList, function(mangaBook) {
              return (
                <h4 onmouseover={ctrl.enterEvent.bind(ctrl)}
                  onmouseout={ctrl.leaveEvent.bind(ctrl)}
                  onclick={ctrl.mangaSelectEvent.bind(ctrl, mangaBook)} style="cursor: pointer;">
                  - {mangaBook.title()}
                </h4>
              );
            })}
          </div>
          <div class="col-md-6">
          </div>
        </div>
      </div>
    </div>`

  app

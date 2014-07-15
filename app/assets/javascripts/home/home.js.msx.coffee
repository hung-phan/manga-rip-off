###* @jsx m ###
define [
  "mithril"
  "navigation/navigation"
  "manga/manga"
], (m, navigation, manga) ->
  "use strict"

  #namespace for app
  app = {}

  # app model
  app.model = (href, title)->
    # initialize
    @ctrl    = new manga.controller([])
    @href    = m.prop(href)
    @title   = m.prop(title)
    @loading = m.prop(false)
    return

  app.AppList = Array

  #controller
  app.controller = ->
    @mangaList      = new app.AppList()
    @timeout        = undefined
    @navigationCtrl = navigation.sharedController
    @loadMangaList  = m.prop(false)

    registerLoadEvent = ((source)->
      source(true)
      m.redraw()
    ).bind(this)

    clearLoadEvent = ((source)->
      source(false)
      m.redraw()
    ).bind(this)

    # event handle
    mangaList     = @mangaList
    loadMangaList = @loadMangaList
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
        () ->
          registerLoadEvent(loadMangaList)
          m.request(method: "GET", url: "/api/v1/kissmanga/#{event.target.value}", config: ((xhr) ->
            xhr.setRequestHeader "Content-Type", "application/json"
          )).then(
            (response) ->
              mangaList.length = 0
              _.each(response, (mangaBook)->
                mangaList.push new app.model(mangaBook.href, mangaBook.title)
                return
              )
              clearLoadEvent(loadMangaList)
              return
            (error) ->
              alert error.error
              clearLoadEvent(loadMangaList)
              return
          )
          return
        500
      )
    ).bind(this)

    @mangaSelectEvent = ((mangaBook)->
      unless mangaBook.ctrl.mangaBook.chapters().length is 0
        mangaBook.ctrl.setVisibility(!mangaBook.ctrl.mangaBook.display())
        return
      data =
        link: mangaBook.href()

      registerLoadEvent(mangaBook.loading)
      m.request(method: "POST", url: "/api/v1/kissmanga/", data: data, config: ((xhr) ->
        xhr.setRequestHeader "Content-Type", "application/json"
      )).then(
        (response) ->
          mangaBook.ctrl.setMangaBook(response['image'], response['chapters'])
          clearLoadEvent(mangaBook.loading)
        (error) ->
          alert error.error
          clearLoadEvent(mangaBook.loading)
      )
    ).bind(this)

    # animation for element
    @enterEvent = (event)->
      TweenLite.to event.target, 0.5, {
        color: '#89CD25'
      }
      return

    @leaveEvent = (event)->
      TweenLite.to event.target, 0.1, {
        color: '#333333'
      }
      return

    return

  #view
  app.view = (ctrl) ->
    `<div>
      {navigation.view(ctrl.navigationCtrl)}
      <div class="container">
        <div class="row">
          <div class="col-md-12 text-center">
            <h1 style="padding-bottom: 22px;">Welcome to Manga Rip Off page</h1>
          </div>
        </div>
        <div class="row">
          <input type="text" class="col-xs-11 col-md-11 search-box status-form"
            placeholder="Search ..." oninput={ctrl.searchManga.bind(ctrl)}/>
          <div style={ctrl.loadMangaList() ? "display:block;" : "display:none;"}
            class="col-xs-1 col-md-1 text-right">
            <i class="fa fa-2x fa-spin fa-refresh"></i>
          </div>
        </div>
        <div class="row" style="padding-top: 20px;">
          {_.map(ctrl.mangaList, function(mangaBook) {
            return (
              <div class="row">
                <div class="col-md-12">
                  <p onmouseover={ctrl.enterEvent.bind(ctrl)}
                    onmouseout={ctrl.leaveEvent.bind(ctrl)}
                    onclick={ctrl.mangaSelectEvent.bind(ctrl, mangaBook)} class="lead" style="cursor: pointer;">
                    {mangaBook.title()}&nbsp;
                    <span style={mangaBook.loading() ? "display:inline;" : "display:none;"}>
                      <i class="fa fa-spin fa-refresh"></i>
                    </span>
                  </p>
                </div>
                {manga.view(mangaBook.ctrl)}
              </div>
            );
          })}
        </div>
      </div>
    </div>`

  app

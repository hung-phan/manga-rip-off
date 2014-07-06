###* @jsx m ###
define [
  "mithril"
  "helper/routing"
], (m, routing) ->
  "use strict"

  #namespace for manga
  manga = {}

  #model
  manga.manga = (chapters) ->
    @display  = m.prop(false)
    @chapters = m.prop(chapters)
    return

  #controller
  manga.controller = (mangaBook)->
    # create manga book
    @mangaBook = new manga.manga(mangaBook)

    # event handler
    @setMangaBook = ((chapters)->
      # do nothing if manga has no chapter
      if chapters.lenght is 0
        @mangaBook.display(false)
        return

      # edit chapter
      @mangaBook.chapters(chapters)
      # show chapter
      @mangaBook.display(true)
    ).bind(this)

    @setVisibility = ((visibility)->
      @mangaBook.display(visibility)
    ).bind(this)

    @route = (link)->
      routing.path "/viewer/#{link}"

    return

  #view
  manga.view = (ctrl) ->
    `<div class="col-sm-12" style={ctrl.mangaBook.display() ? 'display:block;' : 'display:none;'}>
      {_.map(ctrl.mangaBook.chapters(), function(chapter) {
        return (
          <p><a onclick={ctrl.route.bind(ctrl, chapter.href)}>{chapter.title}</a></p>
        );
      })}
    </div>`

  manga

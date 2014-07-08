###* @jsx m ###
define ["mithril"], (m) ->
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
      @mangaBook.chapters(_.map(chapters, (chapter)->
        chapter.href = encodeURIComponent(chapter.href)
        chapter
      ))
      # show chapter
      @mangaBook.display(true)
    ).bind(this)

    @setVisibility = ((visibility)->
      @mangaBook.display(visibility)
    ).bind(this)

    return

  #view
  manga.view = (ctrl) ->
    `<div class="col-md-12" style={ctrl.mangaBook.display() ? 'display:block;' : 'display:none;'}>
      {_.map(ctrl.mangaBook.chapters(), function(chapter) {
        return (
          <p><a href={'#/viewer/' + chapter.href}>{chapter.title}</a></p>
        );
      })}
    </div>`

  manga

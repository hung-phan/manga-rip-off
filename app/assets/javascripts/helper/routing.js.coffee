define [
  "mithril"
], (m)->
  # wrapper for mithril routing helper

  routing = {}

  routing.path = (path)->
    m.route path

  routing

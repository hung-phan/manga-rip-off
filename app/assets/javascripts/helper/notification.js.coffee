define [
  "alertify"
], (alertify)->
  # wrapper for alertify.js
  # This module is responsible for creating wrapper for alertify function

  notification = {}

  notification.notYetImplement = ->
    alertify.log "Feature is not implemented yet"

  notification.log = (type, msg)->
    alertify[type] msg

  notification

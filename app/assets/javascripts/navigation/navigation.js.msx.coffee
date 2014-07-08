###* @jsx m ###
define ["mithril"], (m) ->
  "use strict"

  #namespace for navigation
  navigation = {}

  #controller
  navigation.controller = ->
    return

  # default controller
  navigation.sharedController = new navigation.controller()

  #view
  navigation.view = (ctrl) ->
    `<nav class="navbar navbar-inverse" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#/">
            Manga Rip Off
            <i class="fa fa-spin fa-refresh"></i>
            <span class="glyphicon glyphicon-search"></span>
          </a>
        </div>
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
          <ul class="nav navbar-nav navbar-right">
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown">Username goes here <span class="caret"></span></a>
              <ul class="dropdown-menu" role="menu">
                <li><a href="#">Account</a></li>
                <li><a href="#">Settings</a></li>
                <li class="divider"></li>
                <li><a href="#">Logout</a></li>
              </ul>
            </li>
          </ul>
        </div>
      </div>
    </nav>`

  navigation

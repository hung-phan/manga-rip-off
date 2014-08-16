###* @jsx m ###
define [
  "mithril"
  "helper/notification"
  "helper/routing"
], (m, notificationHelper, routingHelper) ->
  "use strict"

  #namespace for login
  login = {}

  #controller
  login.controller = ->
    @email      = m.prop("")
    @password   = m.prop("")
    @rememberMe = m.prop(false)

    @submit     = (->
      notificationHelper.log "success", @email()
      notificationHelper.log "success", @password()
      routingHelper.path "/"
      return
    ).bind(this)

    @rememberMeHandler = (->
      @rememberMe(not @rememberMe())
      return
    ).bind(this)

    return

  #view
  login.view = (ctrl) ->
    `<div class="container">
      <div class="row" style="margin-top:20px">
        <div class="col-xs-12 col-sm-8 col-md-6 col-sm-offset-2 col-md-offset-3">
          <form role="form">
            <fieldset>
              <h2>Please Sign In</h2>
              <hr class="colorgraph"/>
              <div class="form-group">
                <input type="email" class="form-control input-lg" placeholder="Email Address"
                  onchange={m.withAttr("value", ctrl.email)} value={ctrl.email()} />
              </div>
              <div class="form-group">
                <input type="password" class="form-control input-lg" placeholder="Password"
                  onchange={m.withAttr("value", ctrl.password)} value={ctrl.password()}/>
              </div>
              <div class="row">
                <div class="col-sm-6 col-xs-8">
                  <button type="button"
                    class={ctrl.rememberMe() ? "btn btn-info" : "btn btn-default" }
                    onclick={ctrl.rememberMeHandler}>
                    <i class={ctrl.rememberMe() ? "fa fa-check-square-o" : "fa fa-square-o" }></i>&nbsp;Remember Me
                  </button>
                </div>
                <div class="col-sm-6 col-xs-4">
                  <a onclick={notificationHelper.notYetImplement} class="btn btn-link pull-right">Forgot Password?</a>
                </div>
              </div>
              <hr class="colorgraph"/>
              <div class="row">
                <div class="col-xs-6 col-sm-6 col-md-6">
                  <button type="button" class="btn btn-lg btn-success btn-block" onclick={ctrl.submit}>Sign In</button>
                </div>
                <div class="col-xs-6 col-sm-6 col-md-6">
                  <a href="#/register" class="btn btn-lg btn-primary btn-block">Register</a>
                </div>
              </div>
            </fieldset>
          </form>
        </div>
      </div>
    </div>`

  login

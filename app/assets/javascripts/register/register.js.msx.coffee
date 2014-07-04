###* @jsx m ###
define [
  "mithril"
  "helper/notification"
], (m, notificationHelper) ->
  "use strict"

  #namespace for register
  register = {}

  #controller
  register.controller = ->
    @firstName       = m.prop("")
    @lastName        = m.prop("")
    @displayName     = m.prop("")
    @email           = m.prop("")
    @password        = m.prop("")
    @confirmPassword = m.prop("")
    @agree           = m.prop(false)

    # change animation style of agree component
    @agreeHandler = (->
      @agree(not @agree())
      return
    ).bind(this)

    # submit data to server
    @submit = (->
      notificationHelper.log "log", @email()
      notificationHelper.log "log", @password()
      return
    ).bind(this)

    return

  #view
  register.view = (ctrl) ->
    `<div class="container">
      <div class="row" style="margin-top:20px">
        <div class="col-xs-12 col-sm-8 col-md-6 col-sm-offset-2 col-md-offset-3">
          <form role="form">
            <h2>Please Sign Up <small>It's free and always will be.</small></h2>
            <hr class="colorgraph"/>
            <div class="row">
              <div class="col-xs-12 col-sm-6 col-md-6">
                <div class="form-group">
                  <input type="text" class="form-control input-lg" placeholder="First Name" tabindex="1"
                   onchange={m.withAttr("value", ctrl.firstName)} value={ctrl.firstName()}/>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-6">
                <div class="form-group">
                  <input type="text" class="form-control input-lg" placeholder="Last Name" tabindex="2"
                   onchange={m.withAttr("value", ctrl.lastName)} value={ctrl.lastName()}/>
                </div>
              </div>
            </div>
            <div class="form-group">
              <input type="text" class="form-control input-lg" placeholder="Display Name" tabindex="3"
               onchange={m.withAttr("value", ctrl.displayName)} value={ctrl.displayName()}/>
            </div>
            <div class="form-group">
              <input type="email" class="form-control input-lg" placeholder="Email Address" tabindex="4"
                   onchange={m.withAttr("value", ctrl.email)} value={ctrl.email()}/>
            </div>
            <div class="row">
              <div class="col-xs-12 col-sm-6 col-md-6">
                <div class="form-group">
                  <input type="password" class="form-control input-lg" placeholder="Password" tabindex="5"
                   onchange={m.withAttr("value", ctrl.password)} value={ctrl.password()}/>
                </div>
              </div>
              <div class="col-xs-12 col-sm-6 col-md-6">
                <div class="form-group">
                  <input type="password" class="form-control input-lg" placeholder="Confirm Password" tabindex="6"
                   onchange={m.withAttr("value", ctrl.confirmPassword)} value={ctrl.confirmPassword()}/>
                </div>
              </div>
              <div class="col-xs-12 col-sm-12 col-md-12" style={(ctrl.password() === ctrl.confirmPassword()) ? 'display:none;' : 'display:block;'}>
                <div class="form-group">
                  <p class="alert alert-danger">Password and Confirm password must be matched</p>
                </div>
              </div>
            </div>
            <div class="row">
              <div class="col-xs-4 col-sm-3 col-md-3">
                <span class="button-checkbox">
                  <button type="button" data-color="info" tabindex="7"
                    class={ctrl.agree() ? "btn btn-info" : "btn btn-default" }
                    onclick={ctrl.agreeHandler}>
                    <i class={ctrl.agree() ? "fa fa-check-square-o" : "fa fa-square-o" }></i>&nbsp;I Agree
                  </button>
                </span>
              </div>
              <div class="col-xs-8 col-sm-9 col-md-9">
                 By clicking <strong class="label label-primary">Register</strong>, you agree to the <a onclick={notificationHelper.notYetImplement}>Terms and Conditions</a> set out by this site, including our Cookie Use.
              </div>
            </div>

            <hr class="colorgraph"/>
            <div class="row">
              <div class="col-xs-12 col-md-6">
                <button type="button" onclick={ctrl.submit} class="btn btn-primary btn-block btn-lg">Register</button>
              </div>
              <div class="col-xs-12 col-md-6"><a href="#/login" class="btn btn-success btn-block btn-lg">Sign In</a></div>
            </div>
          </form>
        </div>
      </div>
    </div>`

  register

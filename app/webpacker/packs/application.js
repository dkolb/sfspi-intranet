/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

import Rails from 'rails-ujs'
import Turbolinks from 'turbolinks'
import 'bootstrap/dist/js/bootstrap'
import '../src/scss/application.scss'
import EventPickerUi from '../src/javascript/events_ui'
import environment from '../src/javascript/environment.js.erb'

Rails.start()
Turbolinks.start()

window.EventPickerUi = EventPickerUi
window.Routes = require('../src/javascript/routes.js')

if(environment === 'development') {
  window.$ = $
  window.jQuery = jQuery
}

$(document).ready(function() {
  $('[data-skiperror="true"]').removeClass('is-invalid')
})

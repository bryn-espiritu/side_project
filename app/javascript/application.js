// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import jQuery from "jquery"
window.jQuery = jQuery
window.$ = jQuery

import * as bootstrap from "bootstrap"

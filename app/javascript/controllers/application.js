import { Turbo } from "@hotwired/turbo-rails"
import { Application } from "@hotwired/stimulus"
import Rails from "@rails/ujs"

Rails.start()
Turbo.start()

const application = Application.start()
application.debug = false
window.Stimulus = application

export { application }

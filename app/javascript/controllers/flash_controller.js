import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    // Auto-dismiss after 5 seconds
    this.timeout = setTimeout(() => {
      this.dismiss()
    }, 5000)
  }

  dismiss() {
    if (this.timeout) clearTimeout(this.timeout)

    // Add slide-out and fade-out animation
    this.element.classList.add("translate-x-full", "opacity-0")

    // Wait for animation to finish before removing from DOM
    setTimeout(() => {
      this.element.remove()
    }, 500)
  }
}

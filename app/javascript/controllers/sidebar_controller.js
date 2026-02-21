// app/javascript/controllers/sidebar_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label", "dropdown"] // Added dropdown target
  static STORAGE_KEY = "earmark-sidebar-collapsed"

  connect() {
    const saved = localStorage.getItem(this.constructor.STORAGE_KEY)
    this.apply(saved === "collapsed")
  }

  toggle() {
    const collapsed = this.element.classList.contains("w-64")
    this.apply(collapsed)
  }

  apply(collapsed) {
    this.element.classList.toggle("w-64", !collapsed)
    this.element.classList.toggle("w-20", collapsed)

    this.labelTargets.forEach(label => label.classList.toggle("hidden", collapsed))

    // If we collapse, hide all open dropdowns immediately
    if (collapsed) { this.hideAllDropdowns() }

    localStorage.setItem(this.constructor.STORAGE_KEY, collapsed ? "collapsed" : "expanded")
  }

  toggleDropdown(event) {
    // Only allow dropdowns if sidebar is expanded
    if (this.element.classList.contains("w-20")) return

    const container = event.currentTarget.nextElementSibling
    const chevron = event.currentTarget.querySelector('.chevron-icon')

    container.classList.toggle("hidden")
    if (chevron) chevron.classList.toggle("rotate-180")
  }

  hideAllDropdowns() {
    this.dropdownTargets.forEach(d => d.classList.add("hidden"))
  }
}
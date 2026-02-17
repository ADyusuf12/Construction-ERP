import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label"]

  // We define the key as a constant at the top so it's easy to change later
  static STORAGE_KEY = "earmark-sidebar-collapsed"

  connect() {
    const saved = localStorage.getItem(this.constructor.STORAGE_KEY)
    const collapsed = saved === "collapsed"
    this.apply(collapsed)
  }

  toggle() {
    // Check if the sidebar is currently expanded (w-64)
    const collapsed = this.element.classList.contains("w-64")
    this.apply(collapsed)
  }

  apply(collapsed) {
    this.element.classList.toggle("w-64", !collapsed)
    this.element.classList.toggle("w-20", collapsed)

    this.labelTargets.forEach(label => {
      label.classList.toggle("hidden", collapsed)
    })

    // Save the state using the new Earmark key
    localStorage.setItem(this.constructor.STORAGE_KEY, collapsed ? "collapsed" : "expanded")
  }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["label"]

  connect() {
    const saved = localStorage.getItem("hamzis-sidebar-collapsed")
    const collapsed = saved === "collapsed"
    this.apply(collapsed)
  }

  toggle() {
    const collapsed = this.element.classList.contains("w-64")
    this.apply(collapsed)
  }

  apply(collapsed) {
    this.element.classList.toggle("w-64", !collapsed)
    this.element.classList.toggle("w-20", collapsed)
    this.labelTargets.forEach(label => {
      label.classList.toggle("hidden", collapsed)
    })
    localStorage.setItem("hamzis-sidebar-collapsed", collapsed ? "collapsed" : "expanded")
  }
}

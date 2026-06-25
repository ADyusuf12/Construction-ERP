import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "content", "btnText"]

    connect() {
        // Optional: Restore previous collapsed state from localStorage
        const isCollapsed = localStorage.getItem("dev-switcher-collapsed") === "true"
        if (isCollapsed) {
            this.collapse()
        }
    }

    toggle(e) {
        e.preventDefault()
        if (this.contentTarget.classList.contains("hidden")) {
            this.expand()
        } else {
            this.collapse()
        }
    }

    collapse() {
        this.contentTarget.classList.add("hidden")
        this.btnTextTarget.textContent = "Expand"
        localStorage.setItem("dev-switcher-collapsed", "true")
    }

    expand() {
        this.contentTarget.classList.remove("hidden")
        this.btnTextTarget.textContent = "Collapse"
        localStorage.setItem("dev-switcher-collapsed", "false")
    }
}
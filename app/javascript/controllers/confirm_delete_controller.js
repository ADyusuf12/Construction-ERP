import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.boundHandleKeyUp = this.handleKeyUp.bind(this)
  }

  open(event) {
    event.preventDefault()
    const { title, message, confirmPath } = event.params
    this.modalTarget.classList.remove("hidden")
    this.modalTarget.querySelector("#modal-title").textContent = title
    this.modalTarget.querySelector("p").textContent = message
    this.modalTarget.querySelector("form").action = confirmPath
    document.addEventListener("keyup", this.boundHandleKeyUp)
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.removeEventListener("keyup", this.boundHandleKeyUp)
  }

  handleKeyUp(event) {
    if (event.key === "Escape") {
      this.close()
    }
  }
}

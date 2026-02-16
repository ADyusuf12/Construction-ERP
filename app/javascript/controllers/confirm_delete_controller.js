import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.boundHandleKeyUp = this.handleKeyUp.bind(this)
  }

  open(event) {
    event.preventDefault()

    // 1. Extract params
    const { title, message, confirmPath, confirmMethod = "delete" } = event.params

    const modal = this.modalTarget
    const form = modal.querySelector("form")
    const methodInput = form.querySelector("input[name='_method']")

    // 2. Update UI text
    modal.querySelector("#modal-title").textContent = title
    modal.querySelector("p").textContent = message

    // 3. Configure Form action and method
    form.action = confirmPath
    if (methodInput) {
      methodInput.value = confirmMethod
    }

    // 4. AUTO-CLOSE: Hide modal immediately when the form is submitted
    form.addEventListener("submit", () => {
      this.close()
    }, { once: true })

    // 5. Show modal and add listeners
    modal.classList.remove("hidden")
    document.addEventListener("keyup", this.boundHandleKeyUp)
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.removeEventListener("keyup", this.boundHandleKeyUp)
  }

  handleKeyUp(event) {
    if (event.key === "Escape") this.close()
  }

  disconnect() {
    document.removeEventListener("keyup", this.boundHandleKeyUp)
  }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal"]

  connect() {
    this.boundHandleKeyUp = this.handleKeyUp.bind(this)
  }

  open(event) {
    event.preventDefault()

    const {
      title,
      message,
      confirmPath,
      confirmMethod = "post",
      variant = "danger"
    } = event.params

    const modal = this.modalTargets.find(m => m.dataset.variant === variant)
    if (!modal) return

    // Update Content
    modal.querySelector("[data-modal-title]").textContent = title
    modal.querySelector("[data-modal-message]").textContent = message

    // Update Form Action and Method
    const form = modal.querySelector("form")
    form.action = confirmPath

    const methodInput = form.querySelector("input[name='_method']")
    if (methodInput) methodInput.value = confirmMethod

    // Update Button Text
    const submitBtn = modal.querySelector("button[type='submit']")
    if (submitBtn) submitBtn.textContent = title

    // Show Modal
    modal.classList.remove("hidden")
    this.activeModal = modal
    document.addEventListener("keyup", this.boundHandleKeyUp)

    // AUTO-CLOSE on submit so the Turbo Stream replacement is seamless
    form.addEventListener("submit", () => this.close(), { once: true })
  }

  close() {
    if (this.activeModal) {
      this.activeModal.classList.add("hidden")
      this.activeModal = null
    }
    document.removeEventListener("keyup", this.boundHandleKeyUp)
  }

  handleKeyUp(event) {
    if (event.key === "Escape") this.close()
  }

  disconnect() {
    document.removeEventListener("keyup", this.boundHandleKeyUp)
  }
}
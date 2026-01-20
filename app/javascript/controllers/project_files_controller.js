import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="project-files"
export default class extends Controller {
  static targets = ["container", "template"]

  add() {
    const newId = new Date().getTime()
    let html = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, newId)

    const temp = document.createElement("div")
    temp.innerHTML = html

    // clear inputs
    temp.querySelectorAll("input[type='file']").forEach(i => i.value = "")
    temp.querySelectorAll("input[type='text'], textarea").forEach(i => i.value = "")
    temp.querySelectorAll("select").forEach(i => i.selectedIndex = 0)

    this.containerTarget.appendChild(temp.firstElementChild)
  }

  removeNew(event) {
    const block = event.currentTarget.closest(".project-file-block")
    if (block) block.remove()
  }

  markDestroy(event) {
    const block = event.currentTarget.closest(".project-file-block")
    if (!block) return
    const checkbox = block.querySelector("input.destroy-checkbox")
    if (checkbox) {
      checkbox.checked = true
      block.style.display = "none"
    }
  }
}

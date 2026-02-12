import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["container", "template"]

    add(event) {
        event.preventDefault()
        // Replace NEW_RECORD with a unique timestamp to prevent ID collisions
        const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
        this.containerTarget.insertAdjacentHTML('beforeend', content)
    }

    remove(event) {
        event.preventDefault()
        const wrapper = event.target.closest(".nested-fields")

        if (wrapper.dataset.persisted === "true") {
            // If persisted, hide it and check the _destroy checkbox
            wrapper.querySelector("input[name*='[_destroy]']").value = "1"
            wrapper.style.display = "none"
        } else {
            // If new, just rip it out of the DOM
            wrapper.remove()
        }
    }
}

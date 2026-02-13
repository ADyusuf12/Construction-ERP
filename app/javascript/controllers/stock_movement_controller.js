import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["type", "source", "destination", "project", "quantity", "cost", "total"]

    connect() {
        this.updateFields()
        this.calculate()
    }

    // Logic to show/hide fields based on movement type
    updateFields() {
        const type = this.typeTarget.value

        // Inbound: Needs Destination Warehouse
        // Outbound: Needs Source Warehouse + Project
        // Site Delivery: Needs Project
        // Adjustment: Needs Destination Warehouse

        this.toggleVisibility(this.sourceTarget, ["outbound", "adjustment"].includes(type))
        this.toggleVisibility(this.destinationTarget, ["inbound", "adjustment", "site_delivery"].includes(type))
        this.toggleVisibility(this.projectTarget, ["outbound", "site_delivery"].includes(type))
    }

    toggleVisibility(target, shouldShow) {
        const container = target.closest(".field-wrapper")
        if (shouldShow) {
            container.classList.remove("hidden")
            container.classList.add("animate-fade-in") // Add a smooth entry
        } else {
            container.classList.add("hidden")
            container.classList.remove("animate-fade-in")
        }
    }

    // Calculator Logic
    calculate() {
        const qty = parseFloat(this.quantityTarget.value) || 0
        const cost = parseFloat(this.costTarget.value) || 0
        const total = qty * cost

        this.totalTarget.textContent = new Intl.NumberFormat('en-NG', {
            style: 'currency',
            currency: 'NGN',
        }).format(total)
    }
}

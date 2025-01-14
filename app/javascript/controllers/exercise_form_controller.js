import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["weightFields", "manualFields"]

  toggleWeightFields(event) {
    const isManual = event.target.value === "manual"
    this.weightFieldsTarget.classList.toggle("d-none", isManual)
    this.manualFieldsTarget.classList.toggle("d-none", !isManual)
  }
}

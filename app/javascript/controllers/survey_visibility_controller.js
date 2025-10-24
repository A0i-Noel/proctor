import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["question"]; // your question wrappers (if you use targets)

  connect() { this.refresh(); }

  refresh() {
    const selected = this.selectedRoleId(); // number | null
    // Find question wrappers; either via targets or a selector:
    const items = this.hasQuestionTarget ? this.questionTargets
      : this.element.closest("form")?.querySelectorAll("[data-target-roles]") || [];

    items.forEach((el) => {
      const targets = this.targetRolesOf(el); // Set<number> (empty = everyone)
      const visible = this.isVisibleFor(selected, targets);
      el.classList.toggle("hidden", !visible);
      el.setAttribute("aria-hidden", String(!visible));
    });
  }

  selectedRoleId() {
    const checked = this.element.querySelector('input[name="response[role_id]"]:checked');
    if (!checked || checked.value === "") return null; // treat blank as "show all"
    const n = parseInt(checked.value, 10);
    return Number.isNaN(n) ? null : n;
  }

  targetRolesOf(el) {
    const raw = (el.dataset.targetRoles || "").trim();
    if (!raw) return new Set(); // empty => visible to everyone
    return new Set(raw.split(",").map(s => parseInt(s, 10)).filter(n => !Number.isNaN(n)));
  }

  isVisibleFor(selected, targets) {
    if (targets.size === 0) return true;  
    if (selected === null) return true;   
    return targets.has(selected);   
  }
}

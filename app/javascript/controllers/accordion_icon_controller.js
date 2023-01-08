import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let accordionButtonsSelector = document.querySelectorAll('.wallet-accordion-button');
    const switchAccordionButton = (e) => {
      let accordionIcon = e.currentTarget.querySelector('i');
      if (accordionIcon.className.includes('bi-caret-up-fill')) {
        accordionIcon.classList.remove('bi-caret-up-fill');
        accordionIcon.classList.add('bi-caret-down-fill');
      } else {
        accordionIcon.classList.remove('bi-caret-down-fill');
        accordionIcon.classList.add('bi-caret-up-fill');
      }
    }
    accordionButtonsSelector.forEach((accordionButton) => {
      accordionButton.addEventListener('click', switchAccordionButton);
    });
  }
}
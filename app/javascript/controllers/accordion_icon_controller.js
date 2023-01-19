import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let accordionButtonsSelector = document.querySelectorAll('.wallet-accordion-button');
    const switchAccordionButton = (e) => {
      let accordionIcon = e.currentTarget.querySelector('svg');
      if (accordionIcon.className.baseVal.includes('down')) {
        accordionIcon.classList.remove('fa-caret-down')
        accordionIcon.classList.add('fa-caret-up')
      } else {
        accordionIcon.classList.remove('fa-caret-up')
        accordionIcon.classList.add('fa-caret-down')
      }
    }
    accordionButtonsSelector.forEach((accordionButton) => {
      accordionButton.addEventListener('click', switchAccordionButton);
    });
  }
}
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    let categorySelector = document.getElementById('transaction_category_id');
    let subcategorySelector = document.getElementById('subcategory-field');
    let subcategoryOptionsSelector = document.getElementById('transaction_subcategory_id');
    let currentTransaction = subcategorySelector.dataset.transaction;
    const getSubcategories = () => {
      let selectedCategory = categorySelector.value;
      let isNoCategorySelection = categorySelector.value === '';
      if (!isNoCategorySelection) {
        fetch('/categories/' + selectedCategory + '/subcategories.json').then((response) => {
          return response.json();
        }).then((data) => {
          let subcategories = data;
          if (subcategories.length > 0) {
            subcategorySelector.classList.remove('hide-container');
            subcategoryOptionsSelector.innerHTML = '';
            subcategoryOptionsSelector.insertAdjacentHTML('beforeend', "<option value=''>Choose a subcategory</option>");
            subcategories.forEach((subcategory) => {
              let htmlString = `<option value='${subcategory.id}'>${subcategory.name}</option>`
              subcategoryOptionsSelector.insertAdjacentHTML('beforeend', htmlString);
            })
          } else {
            subcategorySelector.classList.add('hide-container');
          }
        })
      } else {
        subcategorySelector.classList.add('hide-container');
      }
    }
    const getCurrentTransaction = () => {
      if (currentTransaction !== undefined) {
        fetch('/transactions/' + currentTransaction + '.json').then((response) => {
          return response.json();
        }).then((data) => {
          let transaction = data;
          if (transaction.subcategory_id){
            subcategoryOptionsSelector.value = transaction.subcategory_id;
            subcategoryOptionsSelector.classList.add('is-valid');
            subcategoryOptionsSelector.classList.add('form-control');
            subcategoryOptionsSelector.classList.remove('form-select');
          }
        });
      }
    };
    getSubcategories();
    getCurrentTransaction();
    categorySelector.addEventListener('change', getSubcategories);
  }
}

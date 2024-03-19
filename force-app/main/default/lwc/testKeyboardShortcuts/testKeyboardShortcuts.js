import { LightningElement } from 'lwc';

export default class TestKeyboardShortcuts extends LightningElement {

    connectedCallback() {
        document.addEventListener('keydown', this.handleKeydown);
      }

      disconnectedCallback() {
        document.removeEventListener('keydown', this.handleKeydown);
      }

      handleKeydown(event) {
        alert('got it'+ event.key);
        //if (event.key === '2') {
          // Scroll to section 2
          this.value = event.detail.value;
        let containerChoosen = this.template.querySelector('.container_2');
        containerChoosen.innerHTML = '<h1>helo there</h1>';
        containerChoosen.scrollIntoView();
        //}
      }
}
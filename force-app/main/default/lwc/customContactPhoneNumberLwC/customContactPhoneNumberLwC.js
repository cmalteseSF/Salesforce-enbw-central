import { LightningElement,track,wire,api } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class CustomContactPhoneNumberLwC extends OmniscriptBaseMixin(LightningElement) {

    phonenumber;

    handlePhoneChange(event) {
        let inputValue = event.target.value;
        let phoneField = this.template.querySelector('[data-id="phoneNum"]');

        if(inputValue.length > 20 ){
            phoneField.setCustomValidity("Bitte gültige Telefonnummer eingeben");
        }

		//const phoneRegex = /^\+?[0-9]{20}$/;
        const phoneRegex = /^(\+?\d{2})\s*[0-9 ]{9,20}$/;
        var pattern = inputValue.match(phoneRegex);
        
        if(pattern != null){
            phoneField.setCustomValidity("");
        }

        // Check if the input contains non-numeric characters
		if (/[^[0-9+ ]+/.test(inputValue)) {
            phoneField.setCustomValidity("Bitte gültige Telefonnummer eingeben");
        }

        phoneField.reportValidity();

        // Update the property to reflect the changes
        this.phonenumber = inputValue;
        this.sendPhoneFieldsDataToOmniscriptJSON();
    }

    sendPhoneFieldsDataToOmniscriptJSON() {
        
        let trimmedPhoneNum = this.phonenumber.replace(/^0+/, '');

        var data = {
            LwCData2 : {
                phonenumber:trimmedPhoneNum
            }
        }
        this.omniApplyCallResp(data);
    }
}
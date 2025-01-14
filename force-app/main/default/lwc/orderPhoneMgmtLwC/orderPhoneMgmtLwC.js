import { LightningElement,track,wire,api } from 'lwc';
import getOrderItemRecord from '@salesforce/apex/OrderController.getOrderItems';
import getCarrierNames from '@salesforce/apex/OrderController.getCarrierNames';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const FIELDS = [
    'OrderItem.Id',
    'OrderItem.vlocity_cmt__AttributeSelectedValues__c',
];


export default class OrderPhoneMgmtLwC extends OmniscriptBaseMixin(LightningElement) {
    
    @api columns = [];  
    @api keyField;
    @api showRowNumberColumn = false;
    @api sortedBy;
    @api sortedDirection = "desc";
    @api hideCheckboxColumn = false;
    @api debug = false;
    @track _rows = [];
    @track _maxRowSelection = 1000;
    @api selectedRows = [];


    @api recordId;
    carrierOptions = [];
    carrierOptionValues;

    @wire(getOrderItemRecord, { quoteId:'$recordId',  fields: FIELDS}) record;
   
    @api myList = [];
    attrSelectedValue = [];
    prodName = [];
    //voiceSubscriber = [];
    portingdate = [];
    legacycontractid = [];
    attrsObject;
    attrsMap = [];
    @track phonenumber = '';
    carriername;
    porting;
    tempdate = '';
    splitDate = [];
    year;
    day;
    month;
    portingValue = false;
    selectedARow = false;
    quotelineItemId = [];
    newList = [];

    areDetailsVisible = false;
    handlePortingChange(event) {
        this.areDetailsVisible = event.target.checked;
        this.portingValue = event.target.checked;
        this.sendPortingFieldsDataToOmniscriptJSON();
    }

    handlePhoneChange(event) {
        let inputValue = event.target.value;
        let phoneField = this.template.querySelector('[data-id="phoneNum"]');

        if(inputValue.length > 20){
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

    handleLegacyChange(event) {
        this.legacycontractid = event.target.value;
        this.sendLegacyFieldsDataToOmniscriptJSON();
    }

    handlePortingDateChange(event) {
        this.portingdate = event.target.value;
        this.sendPortingDateFieldsDataToOmniscriptJSON();
    }

    handleCarrierNameChange(event) {
        this.carriername = event.target.value;
        this.sendCarrierFieldsDataToOmniscriptJSON();
    }

    showNotification(variant, message) {
        const event = new ShowToastEvent({
            title: 'Error',
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    
    
    columns = [
        //{ label: 'QuoteLineItemId', fieldName: 'id' },
        { label: 'Nr', fieldName: 'indexNumber' },
        { label: 'Produktname', fieldName: 'ProductName' },
        { label: 'Portierung', fieldName: 'Porting' },
        { label: 'Anbietername', fieldName: 'CarrierName' },
        { label: 'Rufnummer', fieldName: 'PhoneNumber' },
        { label: 'PortingDate', fieldName: 'PortingDate' },
        { label: 'LegacyContractId', fieldName: 'LegacyContractId' }
    ]

    connectedCallback(){
        this.handleLoad();
    }

    renderedCallback(){
    }

    // Logic for all QLI Records
    handleLoad() {
        getOrderItemRecord({ orderId: this.recordId })
        .then((result) => {
        this.qlis = result;
        console.log('qlis lengt :: '+this.qlis.length);
        this.sendDataToOmniscriptJSON();
        if (Array.isArray(this.qlis) && this.qlis.length ) {
            for (let i = 0; i < this.qlis.length; i++) {
                this.quotelineItemId.push(this.qlis[i].Id);
                this.attrSelectedValue.push(this.qlis[i].vlocity_cmt__AttributeSelectedValues__c);
                this.prodName.push(this.qlis[i].Product2.Name);
                this.portingdate.push(this.qlis[i].PortingDate__c);
                this.legacycontractid.push(this.qlis[i].LegacyContractId__c);
            }
        }

        if (Array.isArray(this.attrSelectedValue) && this.attrSelectedValue.length ) {
            for (let i = 0; i < this.attrSelectedValue.length; i++) {
                this.attrsObject = JSON.parse(this.attrSelectedValue[i]);
                this.attrsMap.push(new Map(Object.entries(this.attrsObject)));
            }
        }
        
        if (Array.isArray(this.attrsMap) && this.attrsMap.length ) {
            for (let i = 0; i < this.attrsMap.length; i++) {
                this.phonenumber = this.attrsMap[i].get('ATT-PHO-N');
                this.carriername = this.attrsMap[i].get('ATTR-CRR-NAM');
                this.porting = this.attrsMap[i].get('ATT-PRT-IN');
                console.log('porting val befiore..' ,this.porting);
                this.portingValue = this.porting; // to pass the original true / false value
                if(this.porting == true ){
                    this.porting = 'Ja';
                }
                else{
                    this.porting = 'Nein';
                }
                this.newList.push({ indexNumber : i+1 , id: this.quotelineItemId[i], ProductName : this.prodName[i] , Porting : this.porting, PortingValue : this.portingValue, CarrierName : this.carriername, PhoneNumber : this.phonenumber, PortingDate : this.portingdate[i], LegacyContractId : this.legacycontractid[i] , RowsCount: this.qlis.length});
            }
        }

        this.myList = this.newList; // setting the records to display by the datatable
        
        
        })
        .catch((error) => {
        this.error = error;
        console.log('error....' + this.error);
        });



        getCarrierNames({})
            .then((result) => {
                this.carrierOptionValues = result;
                console.log('carrierOptionValues lengt :: ' + this.carrierOptionValues.length);
                for(let j = 0; j < this.carrierOptionValues.length; j++){
                    this.carrierOptions.push({ label: this.carrierOptionValues[j].Name, value: this.carrierOptionValues[j].vlocity_cmt__Value__c });
                }
                console.log('this.carrierOptions ...' + JSON.stringify(this.carrierOptions));
            })
            .catch((error) => {
                this.error = error;
                console.log('error....' + this.error);
            });
    }


    changeDateFormat(){ 
        console.log('this.tempdate..'+this.tempdate);
        var splitDate = this.tempdate.split('-');
        if(splitDate.count == 0){
            return null;
        }
    
        var year = splitDate[0];
        var month = splitDate[1];
        var day = splitDate[2]; 
    
        this.tempdate = day + '-' + month + '-' + year;
    }


    sendDataToOmniscriptJSON() {
        var data = {
            LwCData : {
                RowsCount:this.qlis.length
            }
        }
        this.omniApplyCallResp(data);
    }

    sendPortingFieldsDataToOmniscriptJSON() {
        var data = {
            LwCData2 : {
                portingvalue:this.portingValue
            }
        }
        this.omniApplyCallResp(data);
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

    sendLegacyFieldsDataToOmniscriptJSON() {
        var data = {
            LwCData2 : {
                legacycontractid:this.legacycontractid
            }
        }
        this.omniApplyCallResp(data);
    }

    sendPortingDateFieldsDataToOmniscriptJSON() {
        var data = {
            LwCData2 : {
                portingdate:this.portingdate
            }
        }
        this.omniApplyCallResp(data);
    }

    sendCarrierFieldsDataToOmniscriptJSON() {
        var data = {
            LwCData2 : {
                carriername:this.carriername
            }
        }
        this.omniApplyCallResp(data);
    }

    // Rows
    @api
    get rows() { 
        return this.myList;  // fetches the records to display by the datatable
    }
    set rows(data) {
        if (data) {
            if (Array.isArray(data)) {
                this._rows = JSON.parse(JSON.stringify(data));
            }
            else{
                this._rows = [JSON.parse(JSON.stringify(data))];            
            }          
        }
    }

     // Max Row Selection
     @api
     get maxRowSelection() { return this._maxRowSelection; }
     set maxRowSelection(data) {
         if (data) {
             this._maxRowSelection = data;
 
             if (this._maxRowSelection < 1) 
                 this.hideCheckboxColumn = true;
             else 
                 this.hideCheckboxColumn = false;
         }
     }

     handleRowSelection(event) {
        try {
            this.selectedRows = event.detail.selectedRows;
            
            console.log("Row(s) Selected PortingValue -> " + JSON.stringify(this.selectedRows[0].PortingValue));            
            if(this.selectedRows[0].PortingValue== "false"  || JSON.stringify(this.selectedRows[0].PortingValue) == "false" || this.selectedRows[0].PortingValue == false){
                this.areDetailsVisible = false;  
                this.portingValue = false;  
            }
            else{
                this.areDetailsVisible = true;  
                this.portingValue = true; //this.selectedRows[0].PortingValue; 
            }
            
            this.phonenumber = this.selectedRows[0].PhoneNumber;
            this.legacycontractid = this.selectedRows[0].LegacyContractId;
            this.portingdate = this.selectedRows[0].PortingDate;
            this.carriername = this.selectedRows[0].CarrierName;

            if(this.selectedRows[0] != null){
                this.selectedARow = true;
            }

            if (this.debug) 
                console.log("Row(s) Selected -> " + JSON.stringify(this.selectedRows));            
            
            super.omniUpdateDataJson(this.selectedRows);
        }
        catch (err) {
            console.error("Error in handleRowSelected() -> " + err);
        }
    }

    sortData(fieldName, sortDirection) {
       
        if (this.debug) 
            console.log("Sorting by " + fieldName + " in " + sortDirection + "ending direction");

        // Create a new array to sort
        let sortedData = JSON.parse(JSON.stringify(this._rows));
        
        // Sort it
        sortedData.sort(function (a, b) {            
            // Sort Ascending
            if (sortDirection === "asc") {

                // undefined values always appear first in an ascending sort
                if (a[fieldName] === undefined && b[fieldName] !== undefined) return -1;
                else if (a[fieldName] !== undefined && b[fieldName] === undefined) return 1;                    
                else if (a[fieldName] > b[fieldName]) return 1;
                else if (a[fieldName] < b[fieldName]) return -1;                
                else return 0;
            }
            // Sort Descending
            else {

                // undefined values always appear last in a decending sort
                if (a[fieldName] === undefined && b[fieldName] !== undefined) return 1;
                else if (a[fieldName] !== undefined && b[fieldName] === undefined) return -1;
                else if (a[fieldName] > b[fieldName]) return -1;
                else if (a[fieldName] < b[fieldName]) return 1;                
                else return 0;
            }
        });

        return sortedData;
    }

    handleSort(event) {
        try {
            var fieldName = event.detail.fieldName;
            var sortDirection = event.detail.sortDirection;
            
            // sort the rows
            this.sortedBy = fieldName;
            this.sortedDirection = sortDirection;
            this._rows = this.sortData(fieldName, sortDirection);
        }
        catch (err) {
            console.error("Error in handleSort() -> " + err);
        }
    }
}
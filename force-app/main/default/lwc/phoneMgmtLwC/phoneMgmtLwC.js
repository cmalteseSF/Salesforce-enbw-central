import { LightningElement,track,wire,api } from 'lwc';
import getQLIRecord from '@salesforce/apex/QuoteController.getQuoteLineItems';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

const FIELDS = [
    'QuoteLineItem.Id',
    'QuoteLineItem.vlocity_cmt__AttributeSelectedValues__c',
];


export default class PhoneMgmtLwC extends OmniscriptBaseMixin(LightningElement) {
 
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
    @api productCode;

    @wire(getQLIRecord, { quoteId:'$recordId',  productCode:'$productCode', fields: FIELDS}) record;

    @api myList = [];
    attrSelectedValue = [];
    prodName = [];
    voiceSubscriber = [];
    attrsObject;
    attrsMap = [];
    phonenumber;
    carriername;
    porting;
    quotelineItemId = [];
    newList = [];

    
    columns = [
        //{ label: 'QuoteLineItemId', fieldName: 'id' },
        { label: 'Nr', fieldName: 'indexNumber' },
        { label: 'Produktname', fieldName: 'ProductName' },
        { label: 'Portierung', fieldName: 'Portierung' },
        { label: 'Anbietername', fieldName: 'CarrierName' },
        { label: 'Rufnummer', fieldName: 'PhoneNumber' },
        { label: 'Anschlussinhaber', fieldName: 'VoiceSubscriber' }
    ]

    connectedCallback(){
        console.log('recordId..', this.recordId); //current record id from @api
        this.handleLoad();
        console.log('In connectedCallback');
        //console.log('selectedRows', this.selectedRows)

    }

    renderedCallback(){
        console.log('remderedCallback.......');
        //console.log('renderedCallback wire records..', this.record);
        //console.log('renderedCallback wire records 2..', JSON.stringify(this.record));
    }

    // Logic for all QLI Records
    handleLoad() {
    getQLIRecord({ quoteId: this.recordId , productCode: this.productCode})
        .then((result) => {
        this.qlis = result;
        console.log('qlis lengt :: '+this.qlis.length);
        this.sendDataToOmniscriptJSON();
        if (Array.isArray(this.qlis) && this.qlis.length ) {
            for (let i = 0; i < this.qlis.length; i++) {
                this.quotelineItemId.push(this.qlis[i].Id);
                this.attrSelectedValue.push(this.qlis[i].vlocity_cmt__AttributeSelectedValues__c);
                this.prodName.push(this.qlis[i].Product2.Name);
                this.voiceSubscriber.push(this.qlis[i].VoiceSubscriber__c);
                //console.log('Adding default value Ids :: '+this.defaultvalueIds[i]);
            }
        }

        

        if (Array.isArray(this.attrSelectedValue) && this.attrSelectedValue.length ) {
            for (let i = 0; i < this.attrSelectedValue.length; i++) {
                this.attrsObject = JSON.parse(this.attrSelectedValue[i]);
                this.attrsMap.push(new Map(Object.entries(this.attrsObject)));
            }
        }
        
        //console.log('attrsMap are..', JSON.stringify(this.attrsMap));

        if (Array.isArray(this.attrsMap) && this.attrsMap.length ) {
            for (let i = 0; i < this.attrsMap.length; i++) {
                this.phonenumber = this.attrsMap[i].get('ATT-PHO-N');
                this.carriername = this.attrsMap[i].get('ATTR-CRR-NAM');
                this.porting = this.attrsMap[i].get('ATT-PRT-IN');
                console.log('porting val befiore..' ,this.porting);
                if(this.porting == true ){
                    this.porting = 'Ja';
                }
                else{
                    this.porting = 'Nein';
                }
                this.newList.push({ indexNumber : i+1 , id: this.quotelineItemId[i], ProductName : this.prodName[i] , Portierung : this.porting, CarrierName : this.carriername, PhoneNumber : this.phonenumber, VoiceSubscriber : this.voiceSubscriber[i] , RowsCount: this.qlis.length});
            }
        }

        this.myList = this.newList; // setting the records to display by the datatable
        
        
        })
        .catch((error) => {
        this.error = error;
        console.log('error....' + this.error);
        });
    }

    sendDataToOmniscriptJSON() {
        var data = {
            LwCData : {
                RowsCount:this.qlis.length
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
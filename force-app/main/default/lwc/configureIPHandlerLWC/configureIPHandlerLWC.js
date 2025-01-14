import { LightningElement,track,wire,api } from 'lwc';
import getQLIRecord from '@salesforce/apex/IPHandlerController.getQLIRecord';
import upsertQLIRecord from '@salesforce/apex/IPHandlerController.upsertQLIRecord';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';
import { refreshApex } from "@salesforce/apex";

const VERSION_VALUE = 'IPv4';
const USAGE_TYPE_VALUE = 'LANIP';
const COLUMNS = [
    { label: 'Subnet mask', fieldName: 'SubnetMask' },
    { label: 'Version', fieldName: 'Version' },
    { label: 'Usage Type', fieldName: 'UsageType' }
];

const FIELDS = [
    'QuoteLineItem.Id',
    'QuoteLineItem.vlocity_cmt__AttributeSelectedValues__c',
];

export default class PhoneMgmtLwC extends OmniscriptBaseMixin(LightningElement) {
    columns = COLUMNS;
    versionValue = VERSION_VALUE;
    usageTypeValue = USAGE_TYPE_VALUE;
    @api keyField;
    @api showRowNumberColumn = false;
    @api hideCheckboxColumn = false;
    @api debug = false;
    @track _rows = [];
    @track _maxRowSelection = 1000;
    @api selectedRows  = [];
    @track isIPConfig = false;
    @track isRowSelected = false;
    @track isNewSelected = false;
    @track isAdditionalRows = false;
    @track checked = false;
    @track isLoaded = false;
    @track isLast = false;
    @api recordId;
    @api productCode;
    @api rootProductCode;
    @api myList = [];
    @api myAdditionalList = [];
    subnetValue = '30';
    subnetSelectedValue = '30';
    wiredRecordsResult;

    @wire(getQLIRecord, { quoteId:'$recordId',  productCode:'$productCode', fields: FIELDS}) wiredRecords(result) {
        this.wiredRecordsResult = result;
        if (result.data) {
            this.attrSelectedValue = [];
            this.attrsObject = [];
            this.attrsMap = [];
            this.quotelineItemId = [];
            this.newList = [];
            this.additionalNewList = [];           
            this.records = result.data;
            this.isLoaded = true;
            this.qlis = this.records;
            if(this.qlis.slice(3).length != 0){
                this.isAdditionalRows = true;
            }
            if (Array.isArray(this.qlis) && this.qlis.length ) {
                this.qlis.forEach((item) => {
                    this.quotelineItemId.push(item.Id);
                    this.attrSelectedValue.push(item.vlocity_cmt__AttributeSelectedValues__c);
                });
            }

            if (Array.isArray(this.attrSelectedValue) && this.attrSelectedValue.length ) {
                this.attrSelectedValue.forEach((item) => {
                    this.attrsObject = JSON.parse(item);
                    this.attrsMap.push(new Map(Object.entries(this.attrsObject)));
                });
            }

            if (Array.isArray(this.attrsMap) && this.attrsMap.length ) {
                let i = 0;
                this.attrsMap.forEach((item) => {                
                    this.subnetMask = item.get('ATT-SBN-MSK');
                    this.version = item.get('ATT-IP-VRS');
                    this.type = item.get('ATT-USG-TYP');
                    this.newList.push({ indexNumber : i+1 , Id: this.quotelineItemId[i], SubnetMask :'/' + this.subnetMask , Version : this.version, UsageType : this.type});  
                    i++;   
                });
            }     

            this.myList = this.newList.slice(0,3); 
            this.additionalRows = this.newList.slice(3);        
        } else if (result.error) {
            // Handle error
        }
    }

    refreshTable() {
        refreshApex(this.wiredRecordsResult);
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
            this.isIPConfig = true;
            this.isRowSelected = true;
            this.isNewSelected = false;
            this.subnetValue = this.selectedRows[0].SubnetMask.replace('/','');
            this.subnetSelectedValue = this.subnetValue;
        }
        catch (err) {
            console.error("Error in handleRowSelected() -> " + err);
        }
    }

    get subnetOptions() {
        return [
            { label: '/30', value: '30' },
            { label: '/29', value: '29' },
            { label: '/28', value: '28' },
            { label: '/27', value: '27' }
        ];
    }

    get versionOptions() {
        return [
            { label: 'IPv4', value: 'IPv4' }
        ];
    }

    get usageTypeOptions() {
        return [
            { label: 'LANIP', value: 'LANIP' }
        ];
    }

    handleSubnetChange(event) {
        this.subnetSelectedValue = event.detail.value;
    }

    handleCancel(){
        this.setDefaultView();
    }

    handleOperation(event) {
        this.isLoaded = false;
        if(this.additionalRows.length == 1){
            this.isLast = true;
        }else{
            this.isLast = false;    
        }
        if(event.target.dataset.name.toString() == 'Add'){
            this.qliId = '';
        }else{
            this.qliId = this.selectedRows[0].Id;    
        }
        upsertQLIRecord({ subnetValue: this.subnetSelectedValue , quoteId: this.recordId , 
            qliId:this.qliId, rootProductCode:this.rootProductCode, isNotFirst:this.isAdditionalRows, isLast:this.isLast, dmlType: event.target.dataset.name.toString()})
        .then((result) => {
            this.isLoaded = true;
            this.setDefaultView();
            if(event.target.dataset.name.toString() == 'Delete'){
                this.message = 'IP Netzwerk erfolgreich gelöscht';
                this.isAdditionalRows = false;
            }else if(event.target.dataset.name.toString() == 'Add'){
                this.message = 'IP Netzwerk erfolgreich hinzugefügt';
            }else if(event.target.dataset.name.toString() == 'Update'){
                this.message = 'IP Netzwerk erfolgreich aktualisiert';
            }
            this.showToast('OK',this.message,'success');         
            this.refreshTable();
        })
        .catch((error) => {
            this.showToast('Fehler',this.error,'error');       
        })     
    }

    showToast(title, message , variant){
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: 'dismissable'
        }); 
        this.dispatchEvent(event);   
    }

    get options() {
        return [
            { label: 'Add New Additional IP Network', value: 'true' },
        ];
    }

    handleAddAdditionalIP() {
            this._maxRowSelection = 0;
            this.isIPConfig = true;
            this.isNewSelected = true;
            this.isRowSelected = false;    
    }

    setDefaultView(){
        this._maxRowSelection = 1;
        this.isIPConfig = false;
    }  
}
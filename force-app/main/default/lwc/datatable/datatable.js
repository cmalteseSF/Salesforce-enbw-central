import { LightningElement, api, track } from 'lwc';
import { OmniscriptBaseMixin } from 'vlocity_cmt/omniscriptBaseMixin';

export default class Datatable extends OmniscriptBaseMixin(LightningElement) {
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

    connectedCallback(){
        console.log('connectedCallback');
        console.log('selectedRows', this.selectedRows)
    }  

    // Rows
    @api
    get rows() { return this._rows; }
    set rows(data) {
        if (data) {
            if (Array.isArray(data)) 
                this._rows = JSON.parse(JSON.stringify(data));
            else 
                this._rows = [JSON.parse(JSON.stringify(data))];            
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
            //let selections = event.detail.selectedRows;
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
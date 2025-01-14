import { LightningElement, wire,api } from 'lwc'; 
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import pubsub from 'vlocity_cmt/pubsub';

export default class FireEventLwC extends LightningElement { 

    @api recordId;

    record;
    @wire(getRecord, { recordId: '$recordId', fields: ['Status'] })
    wiredRecord(result) {
        this.record = result;
        console.log('record - is ' + this.record);
        if (result.data) {
            this.refreshData();
        }
    }

    refreshData() {
        console.log('refreshData - refresh my flexcard via pubsub');
        //pubsub.fire("channelName", "eventName", "anydata");
        pubsub.fire("refreshmymodal", "data", this.record);
    }

}
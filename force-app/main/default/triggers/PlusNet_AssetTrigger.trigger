Trigger PlusNet_AssetTrigger on Asset (after insert) {

     if (Trigger.isInsert) {
        PlusNet_TriggerHelper.updateContratLineItemAssetId(Trigger.New);
     }
}
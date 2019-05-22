trigger ProductStatePolicyAssocTrigger on Product_State_Status__c (before insert) {
    
    new ProductStatePolicyAssocHandler().run();
    
    //ProductStatePolicyAssocHandler.TransferStatus(Trigger.isBefore, Trigger.isInsert, Trigger.new);
}
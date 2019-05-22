trigger ProductStateTrigger on State_Availability__c (before insert) {
    
    new ProductStateHandler().run();
}
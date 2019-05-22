trigger PolicyFormDetailTrigger on Policy_Form_Detail__c (after update) {
    
    new PolicyFormDetailHandler().run();
    
}
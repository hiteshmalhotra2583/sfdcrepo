trigger ProjectTrigger on Project__c (before update) {
    
    new ProjectHandler().run();
    //ProjectHandler.RequestAutonumber(Trigger.isBefore, Trigger.isUpdate, Trigger.oldMap, Trigger.newMap);
}
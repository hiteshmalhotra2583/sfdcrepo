trigger PolicyStateTrigger on Filing_Status__c (before insert, before update,after update) 
{
    
     new PolicyStateHandler().run();
    //PolicyStateHandler.NamePolicyStateRecord(Trigger.isBefore, Trigger.isInsert, Trigger.new);
    //PolicyStateHandler.PolicyStateStatusChange(Trigger.isAfter, Trigger.isUpdate, Trigger.oldMap, Trigger.newMap);
}
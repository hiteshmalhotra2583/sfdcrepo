trigger MarketingMaterialsTrigger on Marketing_Materials__c (before update, before insert)
 {
     new MarketingMaterialsHandler().run();
    //MarketingMaterialsHandler.RequestAutonumber(Trigger.isBefore, Trigger.isUpdate, Trigger.isInsert, Trigger.oldMap, Trigger.newMap, Trigger.new);
}
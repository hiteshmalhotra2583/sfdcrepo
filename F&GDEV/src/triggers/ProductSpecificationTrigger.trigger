trigger ProductSpecificationTrigger on Product_Specification__c (after insert , after update) 
{
     new ProductSpecificationHandler().run();
    /*ProductSpecificationHandler.CreateStateAvailRecs(trigger.isAfter, trigger.isInsert, trigger.newmap);
    if(Trigger.isUpdate)
    ProductSpecificationHandler.updateStateAvailRecs( trigger.isAfter,trigger.new,trigger.oldMap,trigger.newMap);*/
}
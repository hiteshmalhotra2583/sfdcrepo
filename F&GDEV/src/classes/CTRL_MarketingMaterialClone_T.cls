@isTest
private class CTRL_MarketingMaterialClone_T {

    public static User admin_User;
    public static User admin_User2;
    public static Integer count = 1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Product_Specification__c> productSpecifications = new List<Product_Specification__c>();
    public static List<State_Availability__c> stateAvailabilitys = new List<State_Availability__c>();
    public static List<Marketing_Name__c> marketingNames = new List<Marketing_Name__c>();
     public static List<Marketing_Materials__c> marketingMaterials = new List<Marketing_Materials__c>();
    
    private static void testData() {
        
        admin_User = TestDataFactory.createUser(true,'',SYSTEM_ADMINISTRATOR_PROFILE);
        insert admin_User;
        System.runAs(admin_User)
        {
          
          for(Integer i = 0 ; i <count; i++)
            {
                productSpecifications.add((Product_Specification__c) TestDataFactory.operationOnObjectRecord(null, 'Product_Specification__c', null));
            }
            insert productSpecifications; 
            Map<String,Object>  stateAvailabilityMap = new Map<String,Object>();
          stateAvailabilityMap.put('Product_Specification__c',productSpecifications[0].Id);
            
            for(Integer i = 0 ; i <count; i++)
            {
                stateAvailabilitys.add((State_Availability__c) TestDataFactory.operationOnObjectRecord(null, 'State_Availability__c', stateAvailabilityMap));
            }
            insert stateAvailabilitys; 
            
            Map<String,Object>  marketingNameMap = new Map<String,Object>();
          marketingNameMap.put('Product_Specification__c',productSpecifications[0].Id);
            
            for(Integer i = 0 ; i <count; i++)
            {
                marketingNames.add((Marketing_Name__c) TestDataFactory.operationOnObjectRecord(null, 'Marketing_Name__c', marketingNameMap));
            }
            insert marketingNames; 
            
            for(Integer i = 0 ; i <count; i++)
            {
                marketingMaterials.add((Marketing_Materials__c) TestDataFactory.operationOnObjectRecord(null, 'Marketing_Materials__c', null));
            }
             BaseTriggerHandler.bypass('MARKETINGMATERIALSHANDLER');
            insert marketingMaterials; 
              BaseTriggerHandler.clearBypass('MARKETINGMATERIALSHANDLER');
            
        } 
        
    }
  private static testMethod void testCloneMarketingMaterials() {
            //creating test data
            
            Test.startTest();
            testData();
            admin_User2 = TestDataFactory.createUser(true,'',SYSTEM_ADMINISTRATOR_PROFILE);
            insert admin_User2; 
            System.runAs(admin_User2)
            {
            String clonedObjectId = CTRL_MarketingMaterialClone.cloneMarketingMaterials(marketingMaterials[0].Id);
            String objName = UtilityClass.getObjectNameFromId(clonedObjectId);
            System.assertEquals('Marketing_Materials__c', objName);
            }
            Test.stopTest();
  }
}

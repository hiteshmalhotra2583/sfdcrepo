@isTest
private class CTRL_MarketingMaterialClone_T {

  public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Product_Specification__c> productSpecifications = new List<Product_Specification__c>();
    public static List<State_Availability__c> stateAvailabilitys = new List<State_Availability__c>();
    public static List<Marketing_Name__c> marketingNames = new List<Marketing_Name__c>();
    
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
            
        } 
        
    }
	private static testMethod void testCloneMarketingMaterials() {
            //creating test data
            testData();
            Test.startTest();
            String clonedObjectId = CTRL_MarketingMaterialClone.cloneMarketingMaterials(marketingNames[0].Id, 'ClonedMarketingMaterialTest');
            String objName = UtilityClass.getObjectNameFromId(clonedObjectId);
            System.assertEquals('Marketing_Name__cj', objName);
            Test.stopTest();
	}
}
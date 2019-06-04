@isTest
private class DAL_MarketingMaterial_T {

    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Marketing_Materials__c> productSpecifications = new List<Marketing_Materials__c>();
    
    static void testData()
    {
    
        admin_User = TestDataFactory.createUser(true,'',SYSTEM_ADMINISTRATOR_PROFILE);
        
        insert admin_User;
        System.runAs(admin_User)
        {
        	
        	for(Integer i = 0 ; i <count; i++)
            {
                productSpecifications.add((Marketing_Materials__c) TestDataFactory.operationOnObjectRecord(null, 'Marketing_Materials__c', null));
            }
            insert productSpecifications; 
            
        } 
    
    }
    
    static testMethod void getByIdsTest() {
     
     testData();
     Test.startTest();
     List<Id> productSpecificationIds  = new List<Id>();
     for(Marketing_Materials__c productSpecification:productSpecifications)
     {
     	productSpecificationIds.add(productSpecification.id);
     }
     DAL_MarketingMaterial.getByIds(productSpecificationIds);
     Test.stopTest();
        
    }
}
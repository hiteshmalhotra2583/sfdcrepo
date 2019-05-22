@isTest
private class DAL_StateAvailability_T {
   
    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Product_Specification__c>  productSpecifications = new List<Product_Specification__c>();
    
    static void testData()
    {
    
        admin_User = TestDataFactory.createUser(true,'',SYSTEM_ADMINISTRATOR_PROFILE);
        
        insert admin_User;
        System.runAs(admin_User)
        {
        	for(Integer i = 0 ; i <count; i++)
            {
                productSpecifications.add((Product_Specification__c) TestDataFactory.operationOnObjectRecord(null, 'Product_Specification__c', null));
            }
            insert productSpecifications; 
            
        } 
    
    }
    
    static testMethod void getByIdsMapTest()
    {
     
     testData();
     Test.startTest();
     List<Id> productSpecificationIds  = new List<Id>();
     for(Product_Specification__c productSpecification:productSpecifications)
     {
     	productSpecificationIds.add(productSpecification.id);
     }
     DAL_StateAvailability.getByTranxcationIdMap(productSpecificationIds);
     DAL_StateAvailability.getByTranxcationId(String.valueof(productSpecificationIds[0]));
     Test.stopTest();
        
    }
}
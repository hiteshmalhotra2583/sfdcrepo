@isTest
private class DAL_ProductStatePolicyFormAssociation_T {

    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Product_State_Status__c> productSpecifications = new List<Product_State_Status__c>();
    public static List<Filing_Status__c> filingStatus = new List<Filing_Status__c>();
    public static List<Policy_Form_Detail__c> policyForms = new List<Policy_Form_Detail__c>();
    public static List<State_Availability__c> stateAvailabilitys = new List<State_Availability__c>();
    public static List<Product_Specification__c> productSpecificationss = new List<Product_Specification__c>();
    
    
    static void testData()
    {
    
        admin_User = TestDataFactory.createUser(true,true,SYSTEM_ADMINISTRATOR_PROFILE);
        
       // insert admin_User;
        System.runAs(admin_User)
        {
        	
        	
        	Map<String,Object> policyFormDetailsMap = new Map<String,Object>();
            policyFormDetailsMap.put('Insurance_Type__c','Life');
        	for(Integer i = 0 ; i <count; i++)
            {
                policyForms.add((Policy_Form_Detail__c) TestDataFactory.operationOnObjectRecord(null, 'Policy_Form_Detail__c', policyFormDetailsMap));
            }
            insert policyForms; 
            
            for(Integer i = 0 ; i <count; i++)
            {
                productSpecificationss.add((Product_Specification__c) TestDataFactory.operationOnObjectRecord(null, 'Product_Specification__c', null));
            }
            insert productSpecificationss;
            
            Map<String,Object> productSpecificationsMaps = new Map<String,Object>();
            productSpecificationsMaps.put('Product_Specification__c',productSpecificationss[0].Id);
            
            for(Integer i = 0 ; i <count; i++)
            {
                stateAvailabilitys.add((State_Availability__c) TestDataFactory.operationOnObjectRecord(null, 'State_Availability__c', productSpecificationsMaps));
            }
            insert stateAvailabilitys; 
            
            Map<String,Object> filingStatusMap = new Map<String,Object>();
            filingStatusMap.put('Policy_Form__c',policyForms[0].Id);
            filingStatusMap.put('State__c','Al');
            for(Integer i = 0 ; i <count; i++)
            {
                filingStatus.add((Filing_Status__c) TestDataFactory.operationOnObjectRecord(null, 'Filing_Status__c', filingStatusMap));
            }
            insert filingStatus; 
        	
            Map<String,Object> productSpecificationsMap = new Map<String,Object>();
            productSpecificationsMap.put('Filing_Status__c',filingStatus[0].Id);
            productSpecificationsMap.put('Product_State_Availability__c',stateAvailabilitys[0].Id);
            
        	for(Integer i = 0 ; i <count; i++)
            {
                productSpecifications.add((Product_State_Status__c) TestDataFactory.operationOnObjectRecord(null, 'Product_State_Status__c', productSpecificationsMap));
            }
            insert productSpecifications; 
            
        } 
    
    }
    
    static testMethod void getByIdsTest() {
     
     testData();
     Test.startTest();
     List<Id> filingStatusIds  = new List<Id>();
     for(Filing_Status__c fs:filingStatus)
     {
     	filingStatusIds.add(fs.id);
     }
     DAL_ProductStatePolicyFormAssociation.getByProductStateAvailabilityIdsMap(filingStatusIds);
     Test.stopTest();
        
    }
}
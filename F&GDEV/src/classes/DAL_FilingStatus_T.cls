@isTest
private class DAL_FilingStatus_T {

    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Filing_Status__c> filingStatus = new List<Filing_Status__c>();
    public static List<Policy_Form_Detail__c> policyForms = new List<Policy_Form_Detail__c>();
    
    static void testData()
    {
    
        admin_User = TestDataFactory.createUser(true,'',SYSTEM_ADMINISTRATOR_PROFILE);
        
        insert admin_User;
        System.runAs(admin_User)
        {
        	
        	Map<String,Object>  policyFormsMap = new Map<String,Object>();
            policyFormsMap.put('Insurance_Type__c','Life');
            policyFormsMap.put('Filing_Strategy__c','Individual');
        	for(Integer i = 0 ; i <count; i++)
            {
                policyForms.add((Policy_Form_Detail__c) TestDataFactory.operationOnObjectRecord(null, 'Policy_Form_Detail__c', policyFormsMap));
            }
            insert policyForms; 
            
            Map<String,Object> filingStatusMap = new Map<String,Object>();
            filingStatusMap.put('Policy_Form__c',policyForms[0].Id);
            filingStatusMap.put('State__c','Al');
            filingStatusMap.put('Form_Variation_Description__c','testDescription');
            filingStatusMap.put('Feature_Variation_Description__c','testFeatureDescription');
            filingStatusMap.put('Filing_Strategy__c','Group Dependent');
            for(Integer i = 0 ; i <count; i++)
            {
                filingStatus.add((Filing_Status__c) TestDataFactory.operationOnObjectRecord(null, 'Filing_Status__c', filingStatusMap));
            }
            insert filingStatus; 
        } 
    
    }
    
    static testMethod void getByIdsMapTest() {
     
     testData();
     Test.startTest();
     List<Id> policyFormsIds  = new List<Id>();
     for(Policy_Form_Detail__c policyForm:policyForms)
     {
     	policyFormsIds.add(policyForm.id);
     }
     DAL_FilingStatus.getByParentIds(policyFormsIds);
     DAL_FilingStatus.getByParentIdMap(policyFormsIds);
     DAL_FilingStatus.getByParentIDsAndFilingStrategy(policyFormsIds);
     Test.stopTest();
        
    }
}
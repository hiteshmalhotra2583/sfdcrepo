@isTest
private class DAL_PolicyFormDetail_T {

    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
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
            
        } 
    
    }
    
    static testMethod void getByIdsTest() {
     
     testData();
     Test.startTest();
     List<Id> policyFormsIds  = new List<Id>();
     for(Policy_Form_Detail__c policyForm:policyForms)
     {
     	policyFormsIds.add(policyForm.id);
     }
     DAL_PolicyFormDetail.getByIds(policyFormsIds);
     DAL_PolicyFormDetail.getByPolicyFormDetailIds(policyFormsIds);
     DAL_PolicyFormDetail.getByName(policyForms[0].Name);
     Test.stopTest();
        
    }
}
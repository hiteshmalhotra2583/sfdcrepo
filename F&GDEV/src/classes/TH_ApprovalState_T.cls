@isTest
private class TH_ApprovalState_T
{
	public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Policy_Form_Detail__c> policyForms = new List<Policy_Form_Detail__c>();
    public static List<Approval_State__c> approvalStates = new List<Approval_State__c>();
    
    
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
            
            Map<String,Object>  approvalStatesMap = new Map<String,Object>();
        	approvalStatesMap.put('Policy_Form__c',policyForms[0].Id);
            approvalStatesMap.put('Situs_State__c','DE');
        	for(Integer i = 0 ; i <count; i++)
            {
                approvalStates.add((Approval_State__c) TestDataFactory.operationOnObjectRecord(null, 'Approval_State__c', approvalStatesMap));
            }
             
            Map<String,Object>  approvalStatesMap2 = new Map<String,Object>();
        	approvalStatesMap2.put('Policy_Form__c',policyForms[0].Id);
            approvalStatesMap2.put('Situs_State__c','AL');
        	for(Integer i = 0 ; i <count; i++)
            {
                approvalStates.add((Approval_State__c) TestDataFactory.operationOnObjectRecord(null, 'Approval_State__c', approvalStatesMap2));
            }
            
             
            Map<String,Object>  approvalStatesMap3 = new Map<String,Object>();
        	approvalStatesMap3.put('Policy_Form__c',policyForms[0].Id);
            approvalStatesMap3.put('Situs_State__c','AK');
        	for(Integer i = 0 ; i <count; i++)
            {
                approvalStates.add((Approval_State__c) TestDataFactory.operationOnObjectRecord(null, 'Approval_State__c', approvalStatesMap3));
            }
        } 
    }
    
     
    static testMethod void csetApprovedStatesOnPolicyFormTest() 
    {
     
     testData();
     Test.startTest();
            insert approvalStates; 
            List<Id> policyFormsIds  = new List<Id>();
     for(Policy_Form_Detail__c policyForm:policyForms)
     {
     	policyFormsIds.add(policyForm.id);
     }
     system.debug(policyFormsIds);  
     List<Policy_Form_Detail__c>  policyForms = DAL_PolicyFormDetail.getByIds(policyFormsIds);
       system.debug(policyForms[0].Approved_States__c);                       
     Test.stopTest();
        
    }
}
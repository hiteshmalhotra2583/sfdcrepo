@isTest
public class DAL_Approval_State_T {
    
    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Policy_Form_Detail__c> policyForms = new List<Policy_Form_Detail__c>();
    public static List<Approval_State__c> approvalStates = new List<Approval_State__c>();
    
    static void testData()
    {
        admin_User = TestDataFactory.createUser(true,true,SYSTEM_ADMINISTRATOR_PROFILE);
        System.runAs(admin_User)
        {
            Map<String,Object> policyFormDetailsMap = new Map<String,Object>();
            policyFormDetailsMap.put('Insurance_Type__c','Life');
        	for(Integer i = 0 ; i<count; i++)
            {
                policyForms.add((Policy_Form_Detail__c) TestDataFactory.operationOnObjectRecord(null, 'Policy_Form_Detail__c', policyFormDetailsMap));
            }
            insert policyForms;
            
            Map<String,Object> approvalStatesMap = new Map<String,Object>();
            approvalStatesMap.put('Policy_Form__c',policyForms[0].Id);
            approvalStatesMap.put('Situs_State__c','AK');
            for(Integer i = 0 ; i<count+1; i++)
            {
                approvalStates.add((Approval_State__c) TestDataFactory.operationOnObjectRecord(null, 'Approval_State__c', approvalStatesMap));
            }
            insert approvalStates;
        }
    }
    static testmethod void testDALMethods()
    {
        testData();
        Set<Id> setPolicyFormId = new Set<Id>();
        for(Policy_Form_Detail__c policyForm : policyForms)
        {
            setPolicyFormId.add(policyForm.Id);
        }
        test.startTest();
        List<Approval_State__c> lstApprovalStates = DAL_Approval_State.getPrimaryApprovalStateByParentIds(setPolicyFormId);
        lstApprovalStates = new List<Approval_State__c>();
        lstApprovalStates = DAL_Approval_State.getApprovalStateByParentIds(setPolicyFormId);
        System.assertEquals(count+1, lstApprovalStates.size());
        test.stopTest();
        
    }
}
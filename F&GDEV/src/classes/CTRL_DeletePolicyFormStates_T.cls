@isTest
private class CTRL_DeletePolicyFormStates_T 
{
    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static Policy_Form_Detail__c policyForm;
    public static List<Filing_Status__c> policyState = new List<Filing_Status__c>();
    
     static void testData() {
    
        admin_User = TestDataFactory.createUser(true,'',SYSTEM_ADMINISTRATOR_PROFILE);
        
        insert admin_User;
        System.runAs(admin_User) {
            TestDataFactory.initStateList();
            Map<String,Object> mapPolicyForm = new Map<String,Object>();
            mapPolicyForm.put('Name','Policy Form Test');
            mapPolicyForm.put('Insurance_Type__c','Annuity');
            mapPolicyForm.put('Insurance_Type__c','Annuity');
            mapPolicyForm.put('Policy_Form_Type__c','Base Policy Form');
            mapPolicyForm.put('Status__c','Active');
            policyForm =(Policy_Form_Detail__c)TestDataFactory.operationOnObjectRecord('insert', 'Policy_Form_Detail__c', mapPolicyForm);
            //now create related policy form state records
            Map<String,Object> mapPolicyFormStateAL = new Map<String,Object>();
            mapPolicyFormStateAL.put('Name','Policy Form Test - AL');
            mapPolicyFormStateAL.put('State__c','AL');
            mapPolicyFormStateAL.put('Policy_Form__c',policyForm.Id);
            mapPolicyFormStateAL.put('Form_Variation_Description__c','test description');
            mapPolicyFormStateAL.put('Feature_Variation_Description__c','test description');
            
            Map<String,Object> mapPolicyFormStateDE = new Map<String,Object>();
            mapPolicyFormStateDE.put('Name','Policy Form Test - DE');
            mapPolicyFormStateDE.put('State__c','DE');
            mapPolicyFormStateDE.put('Policy_Form__c',policyForm.Id);
            mapPolicyFormStateDE.put('Form_Variation_Description__c','test description');
            mapPolicyFormStateDE.put('Feature_Variation_Description__c','test description');
            
            Map<String,Object> mapPolicyFormStateCO = new Map<String,Object>();
            mapPolicyFormStateCO.put('Name','Policy Form Test - CO');
            mapPolicyFormStateCO.put('State__c','CO');
            mapPolicyFormStateCO.put('Policy_Form__c',policyForm.Id);
            mapPolicyFormStateCO.put('Form_Variation_Description__c','test description');
            mapPolicyFormStateCO.put('Feature_Variation_Description__c','test description');
            
            policyState.add((Filing_Status__c)TestDataFactory.operationOnObjectRecord(null, 'Filing_Status__c', mapPolicyFormStateAL));
            policyState.add((Filing_Status__c)TestDataFactory.operationOnObjectRecord(null, 'Filing_Status__c', mapPolicyFormStateDE));
            policyState.add((Filing_Status__c)TestDataFactory.operationOnObjectRecord(null, 'Filing_Status__c', mapPolicyFormStateCO));
            
            insert policyState;
            
            
        }
     }   
	
	private static testMethod void testGetDeleteablePolicyStates() {
        testData();
        Test.startTest();
        List<Filing_Status__c> lstAssertStates = CTRL_DeletePolicyFormStates.getDeleteablePolicyStates(policyForm.Id);
        System.assertEquals(3, lstAssertStates.size());
        Test.stopTest();
	}
	
	private static testMethod void testDeleteSelectedStateRecord() {
	    testData();
        Test.startTest();
        String message = CTRL_DeletePolicyFormStates.DeleteSelectedStateRecord(policyState);
        System.assertEquals('Delete Successful', message);
        //test alternate path
        String message2 = CTRL_DeletePolicyFormStates.DeleteSelectedStateRecord(policyState);
        System.assert(message2.contains('Error Occured!!'));
        Test.stopTest();
	}

}
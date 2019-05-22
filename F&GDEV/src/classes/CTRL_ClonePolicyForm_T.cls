@isTest
private class CTRL_ClonePolicyForm_T {
    
    public static User admin_User;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<String> stateList = new List<String>{'AK','DE','CO','AS'};
    public static List<Filing_Status__c> policyStates = new List<Filing_Status__c>();
    public static List<Policy_Form_Detail__c> policyForms = new List<Policy_Form_Detail__c>();
    public static List<Attachment> attachments = new List<Attachment>();
	 static void testData()
    {
    
        admin_User = TestDataFactory.createUser(true,'',SYSTEM_ADMINISTRATOR_PROFILE);
        
        insert admin_User;
        System.runAs(admin_User)
        {
        	
        	Map<String,Object>  policyFormsMap = new Map<String,Object>();
        	policyFormsMap.put('Insurance_Type__c','Life');
            policyFormsMap.put('Filing_Strategy__c','Individual');
            policyForms.add((Policy_Form_Detail__c) TestDataFactory.operationOnObjectRecord(null, 'Policy_Form_Detail__c', policyFormsMap));
            insert policyForms; 
            
            Map<String,Object> policyStatesMap = new Map<String,Object>();
            policyStatesMap.put('Policy_Form__c',policyForms[0].Id);
            for(String state : stateList)
            {
                policyStatesMap.put('State__c',state);
                policyStatesMap.put('Form_Variation_Description__c','Form is not good');
                policyStatesMap.put('Feature_Variation_Description__c','Form variation features');
                policyStates.add((Filing_Status__c) TestDataFactory.operationOnObjectRecord(null, 'Filing_Status__c', policyStatesMap));
            }
            insert policyStates;
            
            Map<String,Object> attachmentsMap = new Map<String,Object>();
            attachmentsMap.put('ParentId',policyStates[0].Id);
            attachmentsMap.put('Body',Blob.valueOf('Test blob for Attachment'));
            attachments.add((Attachment) TestDataFactory.operationOnObjectRecord(null, 'Attachment', attachmentsMap));
            insert attachments;
            
            
        } 
    }
     static testMethod void testClonePolicyFormWithChild() 
     {
        testData();
        System.runAs(admin_User)
        {
            Test.startTest();
            String assertMessage = CTRL_ClonePolicyForm.clonePolicyFormWithChild(policyForms[0].Id, 'Test new PolicyForm', policyStates[0].Id);
            Test.stopTest();
            System.assertEquals(18, assertMessage.length());   
        }
        
	}
	static testMethod void testGetPolicyFormStates()
	{
	    testData();
	    Test.startTest();
	    List<Filing_Status__c> lstAssertPolicyStates = new List<Filing_Status__c>();
	    lstAssertPolicyStates = CTRL_ClonePolicyForm.getPolicyFormStates(policyForms[0].Id);
	    System.assertEquals(stateList.size(),lstAssertPolicyStates.size());
	    Test.stopTest();
	}

}
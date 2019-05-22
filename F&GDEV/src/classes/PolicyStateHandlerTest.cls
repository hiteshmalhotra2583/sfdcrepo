@isTest
private class PolicyStateHandlerTest {
	
	@isTest static void CreatePolicyForms() {
		List<String> TestStateList = new List<String>{'AL', 'LA', 'ID', 'WY', 'FL'};

		// Batch Create Policy Forms
		List<Policy_Form_Detail__c> policyformList = (List<Policy_Form_Detail__c>)SmartFactory.createSObjectList('Policy_Form_Detail__c', false, 10);
		Integer i = 0;
		for(Policy_Form_Detail__c policyform : policyformList){
			policyform.Name = 'Policy Spec Name - GRP ' + i;
			i += 1;
		}
		insert policyformList;

		Map<Id, Policy_Form_Detail__c> policyformMap = new Map<Id, Policy_Form_Detail__c>([Select Id, Name from Policy_Form_Detail__c]);

		//	Create Policy State Objects for Insert
		List<Filing_Status__c> filingstatList = new List<Filing_Status__c>();
		for(String statecode : TestStateList){
			for(Policy_Form_Detail__c policyform : policyformList){
				filingstatList.add(new Filing_Status__c(Policy_Form__c = policyform.Id, State__c = statecode, Filing_Status__c='Filed'));
			}
		}
		insert filingstatList;

		//	Validate Names of State Availability Records
		for(Filing_Status__c filingstat : [Select Name, Policy_Form__c, State__c from Filing_Status__c])
		{
			System.assertEquals(policyformMap.get(filingstat.Policy_Form__c).Name + ' - ' + filingstat.State__c, filingstat.Name);
		}

		for(Filing_Status__c status : filingstatList){
			status.Filing_Status__c = 'Not Started';
		}
		update filingstatList;
	}
	
	static testmethod void  UpdatePolicyForms()
	{
	    List<String> TestStateList = new List<String>{'AL', 'LA', 'ID', 'WY', 'FL'};

		// Batch Create Policy Forms
		List<Policy_Form_Detail__c> policyformList = (List<Policy_Form_Detail__c>)SmartFactory.createSObjectList('Policy_Form_Detail__c', false, 10);
		Integer i = 0;
		for(Policy_Form_Detail__c policyform : policyformList){
			policyform.Name = 'Policy Spec Name - GRP ' + i;
			i += 1;
		}
		insert policyformList;

		Map<Id, Policy_Form_Detail__c> policyformMap = new Map<Id, Policy_Form_Detail__c>([Select Id, Name from Policy_Form_Detail__c]);

		//	Create Policy State Objects for Insert
		List<Filing_Status__c> filingstatList = new List<Filing_Status__c>();
		for(String statecode : TestStateList){
			for(Policy_Form_Detail__c policyform : policyformList){
				filingstatList.add(new Filing_Status__c(Policy_Form__c = policyform.Id, State__c = statecode, Filing_Status__c='Filed'));
			}
		}
		insert filingstatList;
        Test.startTest();
		for(Filing_Status__c status : filingstatList){
			status.Filing_Strategy__c = 'Group Dependent';
		}
		filingstatList[0].Filing_Strategy__c = 'Group Filing';
		filingstatList[0].State_Approval_Date__c = Date.today()+30;
		update filingstatList;
		Test.stopTest();
		for(Filing_Status__c assertFilingStatus : [Select Filing_Status__c, State_Approval_Date__c from Filing_Status__c where Policy_Form__c=:policyformList[0].Id])
		{
		    System.assertEquals('Approved - Dependent Group', assertFilingStatus.Filing_Status__c);
		    System.assertNotEquals(null, assertFilingStatus.State_Approval_Date__c);
		}
	}


}
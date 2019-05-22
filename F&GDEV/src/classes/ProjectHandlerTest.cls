@isTest
private class ProjectHandlerTest {

	@isTest static void CreateATINumberTest() {
		final String CustomSettingName = AutoNumber.CUST_SETTING_ATI;
		final Integer LastNumberStart = 9;

		Init(CustomSettingName, null, LastNumberStart);

		// Batch Create Several Records
		Integer recNum = 10;

		List<Project__c> projList = (List<Project__c>)SmartFactory.createSObjectList('Project__c', false, recNum);
		insert projList;

		Test.startTest();

		for(Project__c proj : projList){
			proj.Request_ATI_No__c = true;
		}
		update projList;

		Test.stopTest();

	//	-- Validate Field Auto-Number Updates

		//	Validate Last Number in Custom Setting
		System.assertEquals(LastNumberStart + recNum, AutoNumber.GetLastNumber(CustomSettingName));
		
		//	Validate Auto-Number on Fields
		Decimal autonumindex = LastNumberStart;
		for(Project__c proj : [Select ATI_Number__c from Project__c Order By ATI_Number__c]){
			autonumindex += 1;

			System.assertEquals(autonumindex, proj.ATI_Number__c);
		}

	}

	@isTest static void CreateBillCodeTest() {
		final String CustomSettingName = AutoNumber.CUST_SETTING_BILL_CODE;
		final Integer LastNumberStart = 6;

		// -- Batch Create Several Records --

		//	Map of Number of Records Created for Each Prefix
		Map<String, Integer> PrefixListRecNumMap = new Map<String, Integer>{
			'E'=>97
			,'L'=>17
			,'K'=>6
		};

		List<Project__c> crossPrefixProjectList = new List<Project__c>();
		for(String prefix : PrefixListRecNumMap.keySet()){
			Integer recNum = PrefixListRecNumMap.get(prefix);												//	Number of Records to Create to Test AutoNumbering Sequence

			List<Project__c> projList = new List<Project__c>();
			Init(CustomSettingName, prefix, LastNumberStart);												//	Create Custom Setting for Project with Prefix

			projList = (List<Project__c>)SmartFactory.createSObjectList('Project__c', false, recNum);
			for(Project__c proj : projList){
				//	Set Prefix for the Project
				proj.Bill_Code_Prefix__c = prefix;
			}
			crossPrefixProjectList.addAll(projList);
		}
		insert crossPrefixProjectList;

		Test.startTest();
		for(Project__c proj : crossPrefixProjectList){
			proj.Request_Bill_Code__c = true;
		}
		AutoNumber.isTest = true;
		update crossPrefixProjectList;
		Test.stopTest();

		//	Validate Field Auto-Number Updates
		for(String prefix : PrefixListRecNumMap.keySet()){
			Integer recNum = PrefixListRecNumMap.get(prefix);
			
			//	Validate Last Number in Custom Setting By AutoNumber
			Integer LastNumberIndex = LastNumberStart + recNum;
			if(LastNumberIndex > AutoNumber.BILL_CODE_MAX_INDEX)LastNumberIndex = AutoNumber.BILL_CODE_MAX_INDEX;
			System.assertEquals(LastNumberIndex, AutoNumber.GetLastNumber(CustomSettingName, prefix));
		}

		//	Validate Auto-Number on Fields
		Map<String, Integer> PrefixAutoNumIndexMap = new Map<String, Integer>();

		for(Project__c proj : [Select Bill_Code_Prefix__c, Bill_Code__c from Project__c  Where Bill_Code__c != null Order By Bill_Code_Prefix__c asc, Bill_Code__c asc]){
			if(!PrefixAutoNumIndexMap.containsKey(proj.Bill_Code_Prefix__c)){
				PrefixAutoNumIndexMap.put(proj.Bill_Code_Prefix__c, LastNumberStart);
			}

			String prefix = proj.Bill_Code_Prefix__c;

			Integer autonumindex = PrefixAutoNumIndexMap.get(prefix) + 1;
			PrefixAutoNumIndexMap.put(prefix, autonumindex);				//	Add New AutoNum to Map for Next Iteration

			String AutoNumValue = (autonumindex > AutoNumber.BILL_CODE_MAX_INDEX) ? null : prefix + ('0' + String.valueOf(autonumindex)).right(2);

			System.assertEquals(AutoNumValue, proj.Bill_Code__c);
		}
	}

	//	Initialize Custom Setting Value
	public static void Init(String name, String prefix, Integer lastnumber){
		if(prefix == null){
			prefix = AutoNumber.DEFAULT_PREFIX_KEY;
		}

		AutoNumber.SetLastNumber(name, prefix, lastnumber);
	}
}
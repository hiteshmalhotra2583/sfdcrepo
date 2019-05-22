@isTest
private class MarketingMaterialsTest {
	
	
	@isTest static void CreateAdReviewNoTest() {
		final String CustomSettingName = AutoNumber.CUST_SETTING_AD_REVIEW;
		final Integer LastNumberStart = 27;

		Init(CustomSettingName, null, LastNumberStart);

		// Batch Create Several Records
		Integer recNum = 10;

		List<Marketing_Materials__c> mktgmatList = (List<Marketing_Materials__c>)SmartFactory.createSObjectList('Marketing_Materials__c', false, recNum);
		insert mktgmatList;

		//	Create a List for Auto-Num on Insert
		List<Marketing_Materials__c> mktgmatforInsertList = mktgmatList.deepClone(false, false, false);

		Test.startTest();
		for(Integer i=0; i<mktgmatList.size(); i++){
			mktgmatList[i].Request_Ad_Review_No__c = true;
			mktgmatforInsertList[i].Request_Ad_Review_No__c = true;
		}

		update mktgmatList;

		recNum += recNum;				//	Add Record Numbers for Insert
		insert mktgmatforInsertList;
		Test.stopTest();

		//	-- Validate Field Auto-Number Updates --

		//	Validate Last Number in Custom Setting
		System.assertEquals(LastNumberStart + recNum, AutoNumber.GetLastNumber(CustomSettingName));

		//	Validate Auto-Number on Fields
		Decimal autonumindex = LastNumberStart;
		for(Marketing_Materials__c mktgmat : [Select Ad_Review_Number__c from Marketing_Materials__c Order By Ad_Review_Number__c]){
			autonumindex += 1;
			System.assertEquals(String.valueOf((DateTime.now().year())).Right(2) + '-' + ('0000' + String.valueOf(autonumindex)).Right(4), mktgmat.Ad_Review_Number__c);
		}

	}

	@isTest static void CreateMktgMatNumberTest() {
		final String CustomSettingName = AutoNumber.CUST_SETTING_MARKETING_MATERIAL;
		final Integer LastNumberStart = 136;

		//	Map of Number of Records Created for Each Prefix
		Map<String, Integer> PrefixListRecNumMap = new Map<String, Integer>{
			'ADLF'=>10,
			'ADMIN'=>17,
			'ADTJ'=>6,
			'ADV'=>3,
			'FG'=>175,
			'LMG'=>63,
			'NYCO'=>92,
			'OM'=>77,
			'OMAD'=>5,
			'OMCO'=>1,
			'PORT'=>30
		};

		List<Marketing_Materials__c> crossPrefixmktgmatList = new List<Marketing_Materials__c>();
		for(String prefix : PrefixListRecNumMap.keySet()){
			Integer recNum = PrefixListRecNumMap.get(prefix);												//	Number of Records to Create to Test AutoNumbering Sequence

			List<Marketing_Materials__c> mktgmatList = new List<Marketing_Materials__c>();
			Init(CustomSettingName, prefix, LastNumberStart);												//	Create Custom Setting for Project with Prefix

			mktgmatList = (List<Marketing_Materials__c>)SmartFactory.createSObjectList('Marketing_Materials__c', false, recNum);
			for(Marketing_Materials__c mktgmat : mktgmatList){
				mktgmat.Mkt_Form_Prefix__c = prefix;
			}
			crossPrefixmktgmatList.addAll(mktgmatList);
		}
		insert crossPrefixmktgmatList;

		Test.startTest();
		for(Marketing_Materials__c mktgmat : crossPrefixmktgmatList){
			mktgmat.Request_MM_No__c = true;
		}
		update crossPrefixmktgmatList;
		Test.stopTest();

		//	Validate Field Auto-Number Updates
		for(String prefix : PrefixListRecNumMap.keySet()){
			Integer recNum = PrefixListRecNumMap.get(prefix);
			//	Validate Last Number in Custom Setting By AutoNumber
			System.assertEquals(LastNumberStart+recNum, AutoNumber.GetLastNumber(CustomSettingName, prefix));
		}

		//	Validate Auto-Number on Fields
		Map<String, Integer> PrefixAutoNumIndexMap = new Map<String, Integer>();

		for(Marketing_Materials__c mktgmat : [Select Mkt_Form_Prefix__c, MktFormNumber__c from Marketing_Materials__c Order By Mkt_Form_Prefix__c asc, MktFormNumber__c asc]){
			if(!PrefixAutoNumIndexMap.containsKey(mktgmat.Mkt_Form_Prefix__c)){
				PrefixAutoNumIndexMap.put(mktgmat.Mkt_Form_Prefix__c, LastNumberStart);
			}

			String prefix = mktgmat.Mkt_Form_Prefix__c;

			Integer autonumindex = PrefixAutoNumIndexMap.get(prefix) + 1;
			PrefixAutoNumIndexMap.put(prefix, autonumindex);				//	Add New AutoNum to Map for Next Iteration

			System.assertEquals(('0000' + String.valueOf(autonumindex)).Right(4), mktgmat.MktFormNumber__c);
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
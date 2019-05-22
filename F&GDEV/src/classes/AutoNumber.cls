public class AutoNumber {
	public static final String DEFAULT_PREFIX_KEY = 'Default';
	
	public static final String CUST_SETTING_AD_REVIEW = 'Ad_Review';
	public static final String CUST_SETTING_ATI = 'ATI';
	public static final String CUST_SETTING_BILL_CODE = 'Bill_Code';
	public static final String CUST_SETTING_MARKETING_MATERIAL = 'Marketing_Material';

	public static final Integer BILL_CODE_MAX_INDEX = 99;

	public static final String MESSAGE_MAX_AUTONUMBER_SEQUENCE = 'The max autonumber sequence has been reached for this prefix.  Please contact your administrator.';

	public static Boolean isTest = false;

	//	--- Auto Number Process Methods ---
	//	-- Project Auto Number Methods --
	public static void ProcessATINumberRequests(List<Project__c> projectList){
		if(projectList.size() == 0)return;

		//	Get Last Number Custom Setting Value
		Integer lastnum = AutoNumber.GetLastNumber(AutoNumber.CUST_SETTING_ATI);

		//	Add List Size to Last Number
		Integer newlastNum = lastnum + projectList.size();

		//	Set Last Number Custom Setting Value
		AutoNumber.SetLastNumber(AutoNumber.CUST_SETTING_ATI, newlastNum);

		//	Update Records in List
		Integer index = 1;
		for(Project__c proj : projectList){
			proj.ATI_Number__c = lastnum + index;
			index += 1; 
		}
	}

	public static void ProcessBillCodeRequests(Map<String, List<Project__c>> prefixProjectListMap){
		if(prefixProjectListMap.size() == 0)return;

		for(String prefix : prefixProjectListMap.keySet()){
			List<Project__c> projectList = prefixProjectListMap.get(prefix);

			//	Get Last Number Custom Setting Value
			Integer lastnum = AutoNumber.GetLastNumber(AutoNumber.CUST_SETTING_BILL_CODE, prefix);

			if(lastNum < AutoNumber.BILL_CODE_MAX_INDEX){
				//	Add List Size to Last Number
				Integer newlastNum = lastnum + projectList.size();
				if(newlastNum > AutoNumber.BILL_CODE_MAX_INDEX)newlastNum = AutoNumber.BILL_CODE_MAX_INDEX;

				//	Set Last Number Custom Setting Value
				AutoNumber.SetLastNumber(AutoNumber.CUST_SETTING_BILL_CODE, prefix, newlastNum);
			}


			//	Update Records in List
			Integer index = 1;
			for(Project__c proj : projectList){
				if((lastnum + index) > AutoNumber.BILL_CODE_MAX_INDEX){
					if(!AutoNumber.IsTest){
						proj.addError(MESSAGE_MAX_AUTONUMBER_SEQUENCE);
					}
				}else{
					proj.Bill_Code__c = prefix +  ('0' + String.valueOf(lastnum + index)).right(2);
					index += 1; 
				}

			}
		}

	}

	//	-- Marketing Materials Auto Number Methods --
	public static void ProcessMktgMatsRequests(Map<String, List<Marketing_Materials__c>> prefixMktgmatsListMap){
		if(prefixMktgmatsListMap.size() == 0)return;

		for(String prefix : prefixMktgmatsListMap.keySet()){
			List<Marketing_Materials__c> mktgmatsList = prefixMktgmatsListMap.get(prefix);

			//	Get Last Number Custom Setting Value
			Integer lastnum = AutoNumber.GetLastNumber(AutoNumber.CUST_SETTING_MARKETING_MATERIAL, prefix);

			//	Add List Size to Last Number
			Integer newlastNum = lastnum + mktgmatsList.size();

			//	Set Last Number Custom Setting Value
			AutoNumber.SetLastNumber(AutoNumber.CUST_SETTING_MARKETING_MATERIAL, prefix, newlastNum);

			//	Update Records in List
			Integer index = 1;
			for(Marketing_Materials__c mktgmat : mktgmatsList){
				mktgmat.MktFormNumber__c = ('0000' + String.valueOf(lastnum + index)).Right(4);
				index += 1; 
			}
		}
	}

	public static void ProcessAdReviewRequests(List<Marketing_Materials__c> mktgmatsList){
		if(mktgmatsList.size() == 0)return;

		//	Get Last Number Custom Setting Value
		Integer lastnum = AutoNumber.GetLastNumber(AutoNumber.CUST_SETTING_AD_REVIEW);

		//	Add List Size to Last Number
		Integer newlastNum = lastnum + mktgmatsList.size();

		//	Set Last Number Custom Setting Value
		AutoNumber.SetLastNumber(AutoNumber.CUST_SETTING_AD_REVIEW, newlastNum);

		//	Update Records in List
		Integer index = 1;
		for(Marketing_Materials__c mktgmat : mktgmatsList){
			mktgmat.Ad_Review_Number__c = String.valueOf(DateTime.now().year()).Right(2) + '-' + ('0000' + String.valueOf(lastnum + index)).Right(4);
			index += 1; 
		}
	}

	//	--- Auto Number Utility Methods ---
	public static Integer GetLastNumber(String setting){
		return GetLastNumber(setting, null);
	}

	public static Integer GetLastNumber(String setting, String prefix){
		Integer lastNum = 0;

		if(prefix == null)prefix = DEFAULT_PREFIX_KEY;

		String lastNumJson = LastAutoNumber__c.getInstance(setting).Last_Number_Map__c;

		if(lastNumJson != null){
			Map<String, Integer> lastNumMap = (Map<String, Integer>)JSON.deserialize(lastNumJson, Map<String, Integer>.class);
			if(lastNumMap.containsKey(prefix)){
				lastNum = lastNumMap.get(prefix);
			}
		}

		return lastNum;
	}

	public static void SetLastNumber(String setting, Integer num){
		SetLastNumber(setting, null, num);
	}

	public static void SetLastNumber(String setting, String prefix, Integer num){
		LastAutoNumber__c instance = LastAutoNumber__c.getInstance(setting);

		if(prefix == null)prefix = DEFAULT_PREFIX_KEY;

		//	Last Number Setting is Not Defined
		if(instance == null){
			instance = new LastAutoNumber__c(Name = setting, Last_Number_Map__c = '{}');
			insert instance;
		}

		Map<String, Integer> lastnumMap = (Map<String, Integer>)JSON.deserialize(instance.Last_Number_Map__c, Map<String, Integer>.class);		//	get last number map for update

		lastNumMap.put(prefix, num);																											//	update map
		instance.Last_Number_Map__c = JSON.serialize(lastNumMap);																				//	serialize

		//	Update Cusotm Setting
		update instance;
	}
}
@isTest
private class ProductStatePolicyAssocHandlerTest {
	
	@isTest static void AssociateStatusTest() {
		initStateRecs();

		//	Create Policies
		List<String> TestStateList = new List<String>{'AL', 'LA', 'ID', 'WY', 'FL'};

		List<Policy_Form_Detail__c> policyformList = (List<Policy_Form_Detail__c>)SmartFactory.createSObjectList('Policy_Form_Detail__c', false, 5);
		Integer i = 0;
		for(Policy_Form_Detail__c policyform : policyformList){
			policyform.Name = 'Policy Spec Name ' + i;
			i += 1;
		}
		insert policyformList;

		Map<Id, Policy_Form_Detail__c> policyformMap = new Map<Id, Policy_Form_Detail__c>([Select Id, Name from Policy_Form_Detail__c]);

		//	Create Filing Status
		List<Filing_Status__c> filingstatList = new List<Filing_Status__c>();
		Integer j = 0;
		for(String statecode : TestStateList){
			for(Policy_Form_Detail__c policyform : policyformList){
				filingstatList.add(new Filing_Status__c(Policy_Form__c = policyform.Id, State__c = statecode, Filing_Status__c = 'In Progress'));
				j += 1;
			}
		}
		insert filingstatList;
		Map<Id, Filing_Status__c> filingStatMap = new Map<Id, Filing_Status__c>(filingstatList);

		//	Create Products
		List<Product_Specification__c> prodspecList = (List<Product_Specification__c>)SmartFactory.createSObjectList('Product_Specification__c', false, 2);
		Integer k = 0;
		for(Product_Specification__c prodspec : prodspecList){
			prodspec.Name = 'Prod Spec Name ' + k;
			k += 1;
		}
		insert prodspecList;

		List<State_Availability__c> stateavailList = new List<State_Availability__c>([Select Id from State_Availability__c]);
		//	List<Filing_Status__c> filingstatList = new List<Filing_Status__c>([Select Id from Filing_Status__c]);

		//	Create Product State Policies
		List<Product_State_Status__c> prodstatestatList = new List<Product_State_Status__c>();

		for(State_Availability__c stateavail : stateavailList){
			for(Filing_Status__c filingstat : filingstatList){
				prodstatestatList.add(new Product_State_Status__c(Filing_Status__c = filingstat.Id, Product_State_Availability__c = stateavail.Id));
			}
		}
		insert prodstatestatList;

		//	Validate Statuses Have Been Copied
		for(Product_State_Status__c prdstatestat : [Select Filing_Status__c, Policy_Form_Status__c from Product_State_Status__c]){
			System.assertEquals(filingStatMap.get(prdstatestat.Filing_Status__c).Filing_Status__c, prdstatestat.Policy_Form_Status__c);
		}

		// Batch Create Product Specs

	}
	
	private static void initStateRecs(){
		List<State__c> stateavailList = new List<State__c>();
		stateavailList.add(new State__c(Name='Alaska',StateCode__c = 'AK'));
		stateavailList.add(new State__c(Name='Alabama',StateCode__c = 'AL'));
		stateavailList.add(new State__c(Name='Arkansas',StateCode__c = 'AR'));
		stateavailList.add(new State__c(Name='Arizona',StateCode__c = 'AZ'));
		stateavailList.add(new State__c(Name='California',StateCode__c = 'CA'));
		stateavailList.add(new State__c(Name='Colorado',StateCode__c = 'CO'));
		stateavailList.add(new State__c(Name='Connecticut',StateCode__c = 'CT'));
		stateavailList.add(new State__c(Name='District of Columbia',StateCode__c = 'DC'));
		stateavailList.add(new State__c(Name='Delaware',StateCode__c = 'DE'));
		stateavailList.add(new State__c(Name='Florida',StateCode__c = 'FL'));
		stateavailList.add(new State__c(Name='Georgia',StateCode__c = 'GA'));
		stateavailList.add(new State__c(Name='Hawaii',StateCode__c = 'HI'));
		stateavailList.add(new State__c(Name='Iowa',StateCode__c = 'IA'));
		stateavailList.add(new State__c(Name='Idaho',StateCode__c = 'ID'));
		stateavailList.add(new State__c(Name='Illinois',StateCode__c = 'IL'));
		stateavailList.add(new State__c(Name='Indiana',StateCode__c = 'IN'));
		stateavailList.add(new State__c(Name='Kansas',StateCode__c = 'KS'));
		stateavailList.add(new State__c(Name='Kentucky',StateCode__c = 'KY'));
		stateavailList.add(new State__c(Name='Louisiana',StateCode__c = 'LA'));
		stateavailList.add(new State__c(Name='Massachusetts',StateCode__c = 'MA'));
		stateavailList.add(new State__c(Name='Maryland',StateCode__c = 'MD'));
		stateavailList.add(new State__c(Name='Maine',StateCode__c = 'ME'));
		stateavailList.add(new State__c(Name='Michigan',StateCode__c = 'MI'));
		stateavailList.add(new State__c(Name='Minnesota',StateCode__c = 'MN'));
		stateavailList.add(new State__c(Name='Missouri',StateCode__c = 'MO'));
		stateavailList.add(new State__c(Name='Mississippi',StateCode__c = 'MS'));
		stateavailList.add(new State__c(Name='Montana',StateCode__c = 'MT'));
		stateavailList.add(new State__c(Name='North Carolina',StateCode__c = 'NC'));
		stateavailList.add(new State__c(Name='North Dakota',StateCode__c = 'ND'));
		stateavailList.add(new State__c(Name='Nebraska',StateCode__c = 'NE'));
		stateavailList.add(new State__c(Name='New Hampshire',StateCode__c = 'NH'));
		stateavailList.add(new State__c(Name='New Jersey',StateCode__c = 'NJ'));
		stateavailList.add(new State__c(Name='New Mexico',StateCode__c = 'NM'));
		stateavailList.add(new State__c(Name='Nevada',StateCode__c = 'NV'));
		stateavailList.add(new State__c(Name='New York',StateCode__c = 'NY'));
		stateavailList.add(new State__c(Name='Ohio',StateCode__c = 'OH'));
		stateavailList.add(new State__c(Name='Oklahoma',StateCode__c = 'OK'));
		stateavailList.add(new State__c(Name='Oregon',StateCode__c = 'OR'));
		stateavailList.add(new State__c(Name='Pennsylvania',StateCode__c = 'PA'));
		stateavailList.add(new State__c(Name='Rhode Island',StateCode__c = 'RI'));
		stateavailList.add(new State__c(Name='South Carolina',StateCode__c = 'SC'));
		stateavailList.add(new State__c(Name='South Dakota',StateCode__c = 'SD'));
		stateavailList.add(new State__c(Name='Tennessee',StateCode__c = 'TN'));
		stateavailList.add(new State__c(Name='Texas',StateCode__c = 'TX'));
		stateavailList.add(new State__c(Name='Utah',StateCode__c = 'UT'));
		stateavailList.add(new State__c(Name='Virginia',StateCode__c = 'VA'));
		stateavailList.add(new State__c(Name='Vermont',StateCode__c = 'VT'));
		stateavailList.add(new State__c(Name='Washington',StateCode__c = 'WA'));
		stateavailList.add(new State__c(Name='Wisconsin',StateCode__c = 'WI'));
		stateavailList.add(new State__c(Name='West Virginia',StateCode__c = 'WV'));
		stateavailList.add(new State__c(Name='Wyoming',StateCode__c = 'WY'));


		insert stateavailList;
	}	

}
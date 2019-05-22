@isTest
private class CTRL_PolicyFormManagerTest {

	@isTest static void TestSearchPolicies(){
		CTRL_PolicyFormManager.searchPolicies('PolicyName');
	}

	@isTest static void TestGetFilingStatuses(){
		List<String> filingStatuses = CTRL_PolicyFormManager.getFilingStatuses();
	}

	@isTest static void TestWPolicy(){
		// Batch Create Policy Forms
		List<Policy_Form_Detail__c> policyformList = (List<Policy_Form_Detail__c>)SmartFactory.createSObjectList('Policy_Form_Detail__c', false, 1);
		Integer i = 0;
		for(Policy_Form_Detail__c policyform : policyformList){
			policyform.Name = 'Policy Spec Name ' + i;
			i += 1;
		}
		insert policyformList;

		//	Create Policy State Objects for Insert
		List<Filing_Status__c> filingstatList = new List<Filing_Status__c>();
		filingstatList.add(new Filing_Status__c(Policy_Form__c = policyformList[0].Id, State__c = 'AK', Filing_Status__c='Filed', File_Date_To_Vendor__c = Date.today()));
		filingstatList.add(new Filing_Status__c(Policy_Form__c = policyformList[0].Id, State__c = 'AK', Filing_Status__c='Approved', State_Approval_Date__c = Date.today()));
		filingstatList.add(new Filing_Status__c(Policy_Form__c = policyformList[0].Id, State__c = 'AK', Filing_Status__c='Objection', Objection_Deadline_Date__c = Date.today()));
		filingstatList.add(new Filing_Status__c(Policy_Form__c = policyformList[0].Id, State__c = 'AK', Filing_Status__c='Objection', Objection_Received_Date__c = Date.today()));
		filingstatList.add(new Filing_Status__c(Policy_Form__c = policyformList[0].Id, State__c = 'AK', Filing_Status__c='Objection', Objection_Response_Date__c = Date.today()));
		filingstatList.add(new Filing_Status__c(Policy_Form__c = policyformList[0].Id, State__c = 'AK', Filing_Status__c='In Progress', Target_File_Date__c = Date.today()));
		filingstatList.add(new Filing_Status__c(Policy_Form__c = policyformList[0].Id, State__c = 'AK', Filing_Status__c='Withdrawn', Filing_Withdrawn_Date__c = Date.today()));

		insert filingstatList;

		for(Filing_Status__c filingstat : filingstatList){
			new W_Policy(policyformList[0], filingstat);
		}

	}

	@isTest static void TestPolicyFormManager() {
		initStateRecs();
		List<State__c> stateList = Ctrl_PolicyFormManager.getStates();

		//	Create Project
		Project__c project = (Project__c)SmartFactory.createSObject('Project__c');
		insert project;

		//	Create Product State
		Product_Specification__c prodspec = (Product_Specification__c)SmartFactory.createSObject('Product_Specification__c');
		prodspec.Name = 'Prod Spec Name';
		prodspec.Project__c = project.Id;
		insert prodspec;

		// Batch Create Policy Forms
		List<Policy_Form_Detail__c> policyformList = (List<Policy_Form_Detail__c>)SmartFactory.createSObjectList('Policy_Form_Detail__c', false, 1);
		Integer i = 0;
		for(Policy_Form_Detail__c policyform : policyformList){
			policyform.Name = 'Policy Spec Name ' + i;
			i += 1;
		}
		insert policyformList;

		//	Create Project Policy
		insert new Project_Policy__c(Policy_Form__c=policyformList[0].Id, Project__c=project.Id);

		List<String> PolicyIdList = new List<String>();
		for(Policy_Form_Detail__c policyform : policyformList){
			PolicyIdList.add(policyform.Id);
		}

		Map<Id, Policy_Form_Detail__c> policyformMap = new Map<Id, Policy_Form_Detail__c>([Select Id, Name from Policy_Form_Detail__c]);

		//	Create Policy State Objects for Insert
		List<Filing_Status__c> filingstatList = new List<Filing_Status__c>();
		for(State__c state : stateList){
			for(Policy_Form_Detail__c policyform : policyformList){
				filingstatList.add(new Filing_Status__c(Policy_Form__c = policyform.Id, State__c = state.StateCode__c, Filing_Status__c='Filed'));
			}
		}
		insert filingstatList;


		//	Create Product State Policy form Association
		List<State_Availability__c> stateavailList = new List<State_Availability__c>([Select Name, Product_Specification__c, State__c from State_Availability__c]);

		List<Product_State_Status__c> pssList = new List<Product_State_Status__c>();
		for(State_Availability__c stateavail : stateavailList){
			for(Filing_Status__c filingstat : filingstatList){
					pssList.add(new Product_State_Status__c(Filing_Status__c=filingstat.Id, Product_State_Availability__c = stateavail.Id));
			}
		}
		insert pssList;
		

		//	W_Policy
		W_Policy policywrappr = new W_Policy(policyformList[0], filingstatList[0]);
		policywrappr.UISelected = true;
		//	system.debug('@@policywrappr: ' + policywrappr);


		//	PolicyFormStateAggr
		Map<String, Map<Id, W_Policy>> statepolicymap = new Map<String, Map<Id, W_Policy>>();
		statepolicymap.put('AK', new Map<Id, W_Policy>());
		statepolicymap.get('AK').put(policyformList[0].Id, policywrappr);

		//	Map<Id, Map<String, Map<Id, W_ProdStateAvail>>> prodstatepolicystatmap
		Map<Id, Map<String, Map<Id, W_ProdStateAvail>>> prodstatepolicystatmap = new Map<Id, Map<String, Map<Id, W_ProdStateAvail>>>();
		prodstatepolicystatmap.put(prodspec.Id, new Map<String, Map<Id, W_ProdStateAvail>>());
		for(State_Availability__c stateavail : stateavailList){

			if(!prodstatepolicystatmap.get(prodspec.Id).containsKey(stateavail.State__c)){
				prodstatepolicystatmap.get(prodspec.Id).put(stateavail.State__c, new Map<Id, W_ProdStateAvail>());
			}
			
			if(!prodstatepolicystatmap.get(prodspec.Id).get(stateavail.State__c).containsKey(stateavail.Id)){
				prodstatepolicystatmap.get(prodspec.Id).get(stateavail.State__c).put(stateavail.Id, new W_ProdStateAvail(stateavail));
			}
			
			Boolean hasProdStateStat = false;
			Boolean hasFilingStat = false;

			for(Product_State_Status__c pss : pssList){
				W_ProdStateStatus prodstatestat = new W_ProdStateStatus(pss);
				prodstatestat.InsertOrDelete = true;

				if(!hasProdStateStat)prodstatestat.ProductStateStatusId = null;
				hasProdStateStat = !hasProdStateStat;

				if(!hasProdStateStat){
					if(!hasFilingStat)prodstatestat.FilingStatusId = null;
					hasFilingStat = !hasFilingStat;
				}
				
				prodstatepolicystatmap.get(prodspec.Id).get(stateavail.State__c).get(stateavail.Id).PolicytoProdStateStat.put(pss.Id, prodstatestat);
			}

			break;
		}

		//	W_PolicyFormStateAggr
		W_PolicyFormStateAggregate policyformstateaggr = new W_PolicyFormStateAggregate();
		policyformstateaggr.AddPolicyFormState(policywrappr, 'AK', policywrappr.Id);
		policyformstateaggr.isEditableMap.put('Filing_Status__c', true);

		CTRL_PolicyFormManager.ProductReturn prodret = CTRL_PolicyFormManager.getProducts(String.valueOf(project.Id));
		CTRL_PolicyFormManager.PolicyReturn policyret = CTRL_PolicyFormManager.getPolicies(PolicyIdList);
		CTRL_PolicyFormManager.PolicyFormStateAggrReturn  policyaggrret = CTRL_PolicyFormManager.getPolicyFormStateAggr(statepolicymap);

		Ctrl_PolicyFormManager.MessageReturn messageret1 = CTRL_PolicyFormManager.saveStatePolicyStatus(policyformstateaggr);
		CTRL_PolicyFormManager.ProductReturn prodret2 = CTRL_PolicyFormManager.saveProdStatePolicyStatus(prodstatepolicystatmap);			//	Map<Id, Map<String, Map<Id, W_ProdStateAvail>>> prodstatepolicystatmap
		CTRL_PolicyFormManager.MessageReturn messageret2 = CTRL_PolicyFormManager.saveProjectPolicy(project.Id, PolicyIdList);
	}
	
	private static void initStateRecs(){
		List<State__c> stateList = new List<State__c>();
		stateList.add(new State__c(Name='Alaska',StateCode__c = 'AK'));
		stateList.add(new State__c(Name='Alabama',StateCode__c = 'AL'));
		stateList.add(new State__c(Name='Arkansas',StateCode__c = 'AR'));
		stateList.add(new State__c(Name='Arizona',StateCode__c = 'AZ'));
		stateList.add(new State__c(Name='California',StateCode__c = 'CA'));
		stateList.add(new State__c(Name='Colorado',StateCode__c = 'CO'));
		stateList.add(new State__c(Name='Connecticut',StateCode__c = 'CT'));
		stateList.add(new State__c(Name='District of Columbia',StateCode__c = 'DC'));
		stateList.add(new State__c(Name='Delaware',StateCode__c = 'DE'));
		stateList.add(new State__c(Name='Florida',StateCode__c = 'FL'));
		stateList.add(new State__c(Name='Georgia',StateCode__c = 'GA'));
		stateList.add(new State__c(Name='Hawaii',StateCode__c = 'HI'));
		stateList.add(new State__c(Name='Iowa',StateCode__c = 'IA'));
		stateList.add(new State__c(Name='Idaho',StateCode__c = 'ID'));
		stateList.add(new State__c(Name='Illinois',StateCode__c = 'IL'));
		stateList.add(new State__c(Name='Indiana',StateCode__c = 'IN'));
		stateList.add(new State__c(Name='Kansas',StateCode__c = 'KS'));
		stateList.add(new State__c(Name='Kentucky',StateCode__c = 'KY'));
		stateList.add(new State__c(Name='Louisiana',StateCode__c = 'LA'));
		stateList.add(new State__c(Name='Massachusetts',StateCode__c = 'MA'));
		stateList.add(new State__c(Name='Maryland',StateCode__c = 'MD'));
		stateList.add(new State__c(Name='Maine',StateCode__c = 'ME'));
		stateList.add(new State__c(Name='Michigan',StateCode__c = 'MI'));
		stateList.add(new State__c(Name='Minnesota',StateCode__c = 'MN'));
		stateList.add(new State__c(Name='Missouri',StateCode__c = 'MO'));
		stateList.add(new State__c(Name='Mississippi',StateCode__c = 'MS'));
		stateList.add(new State__c(Name='Montana',StateCode__c = 'MT'));
		stateList.add(new State__c(Name='North Carolina',StateCode__c = 'NC'));
		stateList.add(new State__c(Name='North Dakota',StateCode__c = 'ND'));
		stateList.add(new State__c(Name='Nebraska',StateCode__c = 'NE'));
		stateList.add(new State__c(Name='New Hampshire',StateCode__c = 'NH'));
		stateList.add(new State__c(Name='New Jersey',StateCode__c = 'NJ'));
		stateList.add(new State__c(Name='New Mexico',StateCode__c = 'NM'));
		stateList.add(new State__c(Name='Nevada',StateCode__c = 'NV'));
		stateList.add(new State__c(Name='New York',StateCode__c = 'NY'));
		stateList.add(new State__c(Name='Ohio',StateCode__c = 'OH'));
		stateList.add(new State__c(Name='Oklahoma',StateCode__c = 'OK'));
		stateList.add(new State__c(Name='Oregon',StateCode__c = 'OR'));
		stateList.add(new State__c(Name='Pennsylvania',StateCode__c = 'PA'));
		stateList.add(new State__c(Name='Rhode Island',StateCode__c = 'RI'));
		stateList.add(new State__c(Name='South Carolina',StateCode__c = 'SC'));
		stateList.add(new State__c(Name='South Dakota',StateCode__c = 'SD'));
		stateList.add(new State__c(Name='Tennessee',StateCode__c = 'TN'));
		stateList.add(new State__c(Name='Texas',StateCode__c = 'TX'));
		stateList.add(new State__c(Name='Utah',StateCode__c = 'UT'));
		stateList.add(new State__c(Name='Virginia',StateCode__c = 'VA'));
		stateList.add(new State__c(Name='Vermont',StateCode__c = 'VT'));
		stateList.add(new State__c(Name='Washington',StateCode__c = 'WA'));
		stateList.add(new State__c(Name='Wisconsin',StateCode__c = 'WI'));
		stateList.add(new State__c(Name='West Virginia',StateCode__c = 'WV'));
		stateList.add(new State__c(Name='Wyoming',StateCode__c = 'WY'));

		insert stateList;
	}
}
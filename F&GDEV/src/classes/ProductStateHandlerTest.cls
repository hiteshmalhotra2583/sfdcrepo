@isTest
public class ProductStateHandlerTest {
	@isTest static void CreateProductState() {
		initStateRecs();

		// Batch Create Product Specs
		List<Product_Specification__c> prodspecList = (List<Product_Specification__c>)SmartFactory.createSObjectList('Product_Specification__c', false, 10);
		Integer i = 0;
		for(Product_Specification__c prodspec : prodspecList){
			prodspec.Name = 'Prod Spec Name ' + i;
			i += 1;
		}
		insert prodspecList;

		//	Create a Map of Product Specs
		Map<Id, Product_Specification__c> prodspecMap = new Map<Id, Product_Specification__c>([Select Id, Name from Product_Specification__c]);

		//	Validate Names of State Availability Records
		for(State_Availability__c stateavail : [Select Name, Product_Specification__c, State__c from State_Availability__c]){
			System.assertEquals(prodspecMap.get(stateavail.Product_Specification__c).Name + ' - ' + stateavail.State__c, stateavail.Name);
		}
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
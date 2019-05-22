public with sharing class MarketingMaterialsHandler extends BaseTriggerHandler {
	
	
	private List<Marketing_Materials__c> newMarketingMaterials;
    private List<Marketing_Materials__c> oldMarketingMaterials;
    private Map<ID, Marketing_Materials__c> newMarketingMaterialMap;
    private Map<ID, Marketing_Materials__c> oldMarketingMaterialMap;
	
	public MarketingMaterialsHandler()
    {
        oldMarketingMaterials = (List<Marketing_Materials__c>)Trigger.old;
        newMarketingMaterials = (List<Marketing_Materials__c>)Trigger.new;
        newMarketingMaterialMap = (Map<ID, Marketing_Materials__c>)Trigger.newMap;
        oldMarketingMaterialMap = (Map<ID, Marketing_Materials__c>)Trigger.oldMap;
    }
    
    @TestVisible
    protected override void beforeInsert()
    {
    	if(TriggerCheck.canRun('TH_MARKETINGMATERIALSHANDLER'))
    	{
    		requestAutonumber(Trigger.isBefore, Trigger.isUpdate, Trigger.isInsert, oldMarketingMaterialMap, newMarketingMaterialMap, newMarketingMaterials);
    	}
    }
    
    
    @TestVisible
    protected override void beforeUpdate()
    {
		if(TriggerCheck.canRun('TH_MARKETINGMATERIALSHANDLER'))
    	{
			requestAutonumber(Trigger.isBefore, Trigger.isUpdate, Trigger.isInsert, oldMarketingMaterialMap, newMarketingMaterialMap, newMarketingMaterials);
    	}
    }
	
	public void requestAutonumber(Boolean isBefore, Boolean isUpdate, Boolean isInsert, Map<Id, Marketing_Materials__c> oldMap, Map<Id, Marketing_Materials__c> newMap
		, List<Marketing_Materials__c> newList)
	{
		
		if(isBefore && (isUpdate || isInsert)){
			List<Marketing_Materials__c> adreviewProcList = new List<Marketing_Materials__c>(); 
			Map<String, List<Marketing_Materials__c>> prefixmktgmatsProcListMap = new Map<String, List<Marketing_Materials__c>>(); 


			//	Create List of Records for Processing
			for(Marketing_Materials__c newMktMats : newList){
				Id key = newMktMats.Id;

				//	Capture Records for Retrieve of New ATI Numbers
				if(  (isInsert || (isUpdate && !oldMap.get(key).Request_Ad_Review_No__c)) && newMktMats.Request_Ad_Review_No__c ){
					adreviewProcList.add(newMktMats);			
				}

				//	Capture Prefix for Marketing Materials
				String prefix;
				if(  (isInsert || (isUpdate && !oldMap.get(key).Request_MM_No__c)) && newMktMats.Request_MM_No__c ){
					prefix = newMktMats.Mkt_Form_Prefix__c;
				}

				if(!String.isBlank(prefix)){
					if(!prefixmktgmatsProcListMap.containsKey(prefix)){
						prefixmktgmatsProcListMap.put(prefix, new List<Marketing_Materials__c>());
					}
					prefixmktgmatsProcListMap.get(prefix).add(newMktMats);			
				}

			}

			//	Send to AutoNumber Algo
			AutoNumber.ProcessAdReviewRequests(adreviewProcList);
			AutoNumber.ProcessMktgMatsRequests(prefixmktgmatsProcListMap);
		}

	}
}
public with sharing class ProductStateHandler extends BaseTriggerHandler {
	
	
	private List<State_Availability__c> newStateAvailability;
    private List<State_Availability__c> oldStateAvailabilitys;
    private Map<ID, State_Availability__c> newStateAvailabilityMap;
    private Map<ID, State_Availability__c> oldStateAvailabilitylMap;
	
	public ProductStateHandler()
    {
        oldStateAvailabilitys = (List<State_Availability__c>)Trigger.old;
        newStateAvailability = (List<State_Availability__c>)Trigger.new;
        newStateAvailabilityMap = (Map<ID, State_Availability__c>)Trigger.newMap;
        oldStateAvailabilitylMap = (Map<ID, State_Availability__c>)Trigger.oldMap;
    }
    
    
     @TestVisible
    protected override void beforeInsert()
    {
    	if(TriggerCheck.canRun('TH_PRODUCTSTATEHANDLER'))
        {
    		nameProductStateRecord(Trigger.isBefore, Trigger.isInsert, newStateAvailability);
        }
    }
    
	public void nameProductStateRecord(Boolean isBefore, Boolean isInsert, List<State_Availability__c> newList) {
		if(isBefore && isInsert){
			//	Retrieve List of Product Names

			//	-- Create Set of Product Spec Ids
			Set<Id> ProductIdSet = new Set<Id>();
			for(State_Availability__c prodstate : newList){
				ProductIdSet.add(prodstate.Product_Specification__c);
			}

			//	-- Create Map of Product Spec Id to Product Name
			Map<Id, Product_Specification__c> prodspecMap = new Map<Id, Product_Specification__c>([Select Id, Name from Product_Specification__c Where Id in:ProductIdSet]);

			for(State_Availability__c prodstate : newList){
				if(prodspecMap.containsKey(prodstate.Product_Specification__c)){
					prodstate.Name = prodspecMap.get(prodstate.Product_Specification__c).Name + ' - ' + prodstate.State__c;
				}
			}
		}
	}
}
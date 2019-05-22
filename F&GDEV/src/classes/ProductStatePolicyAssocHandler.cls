public with sharing class ProductStatePolicyAssocHandler  extends BaseTriggerHandler {
	
	
	private List<Product_State_Status__c> newProductStateStatus;
    private List<Product_State_Status__c> oldProductStateStatuss;
    private Map<ID, Product_State_Status__c> newProductStateStatusMap;
    private Map<ID, Product_State_Status__c> oldProductStateStatuslMap;
	
	public ProductStatePolicyAssocHandler()
    {
        oldProductStateStatuss = (List<Product_State_Status__c>)Trigger.old;
        newProductStateStatus = (List<Product_State_Status__c>)Trigger.new;
        newProductStateStatusMap = (Map<ID, Product_State_Status__c>)Trigger.newMap;
        oldProductStateStatuslMap = (Map<ID, Product_State_Status__c>)Trigger.oldMap;
    }
    
    
     @TestVisible
    protected override void beforeInsert()
    {
    	if(TriggerCheck.canRun('TH_PRODUCTSTATEPOLICYASSOCHANDLER'))
        {
    		transferStatus(Trigger.isBefore, Trigger.isInsert, newProductStateStatus);
        }
    }
    
	public void transferStatus(Boolean isBefore, Boolean isInsert, List<Product_State_Status__c> newList)
	 {
		if(isBefore && isInsert){
			//	Retrieve List of Product Names

			//	-- Create Set of Policy Ids
			Set<Id> FilingStatIdSet = new Set<Id>();
			for(Product_State_Status__c pss : newList){
				FilingStatIdSet.add(pss.Filing_Status__c);
			}

			//	-- Create Map of Product Spec Id to Product Name
			Map<Id, Filing_Status__c> filingstatMap = new Map<Id, Filing_Status__c>([Select Id, Filing_Status__c from Filing_Status__c Where Id in:FilingStatIdSet]);

			for(Product_State_Status__c prodstatstatus : newList){
				if(filingstatMap.containsKey(prodstatstatus.Filing_Status__c)){
					prodstatstatus.Policy_Form_Status__c = filingstatMap.get(prodstatstatus.Filing_Status__c).Filing_Status__c;
				}
			}
		}
	}
}
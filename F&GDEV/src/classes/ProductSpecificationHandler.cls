public with sharing class ProductSpecificationHandler  extends BaseTriggerHandler {
	
	
	private List<Product_Specification__c> newProduct_Specification;
    private List<Product_Specification__c> oldProduct_Specifications;
    private Map<ID, Product_Specification__c> newProduct_SpecificationMap;
    private Map<ID, Product_Specification__c> oldProduct_SpecificationlMap;
	
	public ProductSpecificationHandler()
    {
        oldProduct_Specifications = (List<Product_Specification__c>)Trigger.old;
        newProduct_Specification = (List<Product_Specification__c>)Trigger.new;
        newProduct_SpecificationMap = (Map<ID, Product_Specification__c>)Trigger.newMap;
        oldProduct_SpecificationlMap = (Map<ID, Product_Specification__c>)Trigger.oldMap;
    }
    
    
     @TestVisible
    protected override void afterInsert()
    {
    	if(TriggerCheck.canRun('TH_PRODUCTSPECIFICATIONHANDLER'))
        {
    		createStateAvailRecs(trigger.isAfter, trigger.isInsert, newProduct_SpecificationMap);
        }
    }
    
    
    @TestVisible
    protected override void afterUpdate()
    {
		if(TriggerCheck.canRun('TH_PRODUCTSPECIFICATIONHANDLER'))
		{
			updateStateAvailRecs(trigger.isAfter,newProduct_Specification,oldProduct_SpecificationlMap,newProduct_SpecificationMap);
		}
    }
    
    public  void createStateAvailRecs(Boolean isAfter, Boolean isInsert, Map<Id, Product_Specification__c> newmap){
        if(isAfter && isInsert){
            List<State_Availability__c> stateavailList = new List<State_Availability__c>();

            for(State__c state : State__c.getAll().values())
            {
               if(!state.excludeFromProductStateCreation__c)
               {
	                //  Loop All Product Spec Records and Create a State Avail Record for Every Spec Record for Every State
	                for(Id prodid : newmap.keySet())
	                {
	                    stateavailList.add(new State_Availability__c(Product_Specification__c = prodid, State__c = state.StateCode__c));
	                }
               }
            }

            //  Insert State Availability if the Recs Exist
            if(stateavailList.size() > 0){
                insert stateavailList;
            }
        }

    }
    
    
     public static void updateStateAvailRecs(Boolean isAfter,List<Product_Specification__c> newProductSpecfication,
     										 Map<Id, Product_Specification__c> oldmap, 
     										 Map<Id, Product_Specification__c> newMap)
     {
        if(isAfter)
        {
        	List<Id> idsforWhichNameChanged = new List<Id>();
        	for(Product_Specification__c ps: newProductSpecfication)
        	{
        		if(oldmap.get(ps.Id).Name != ps.Name)
        		{
        			idsforWhichNameChanged.add(ps.Id);
        		}
        	}
        	
        	
        	if(! idsforWhichNameChanged.isEmpty())
        	{
            	Map<Id,List<State_Availability__c>> byTranxcationIdMap = DAL_StateAvailability.getByTranxcationIdMap(idsforWhichNameChanged);
            	List<State_Availability__c> toUpdateState_Availability = new List<State_Availability__c>();
                for(Id i: idsforWhichNameChanged)
                {
                    for(State_Availability__c s: byTranxcationIdMap.get(i))
                    {
                        toUpdateState_Availability.add(new State_Availability__c(Id=s.Id,
                                                                                 Name = newMap.get(s.TranscationId__c).Name+'-'+s.State__c));
                    }
                }
            	
            	if(!toUpdateState_Availability.isEmpty())
            	{
            		update toUpdateState_Availability;
            	}
        	}
        	
        }

    }
}
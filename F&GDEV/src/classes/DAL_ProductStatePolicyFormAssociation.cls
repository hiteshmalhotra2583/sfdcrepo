public with sharing class DAL_ProductStatePolicyFormAssociation
{
	
	public static List<Product_State_Status__c> getByFilingStatusIds(List<Id> fillingStatusIds)
	{
		return [SELECT 
					   Id,
					   Name,
					   Filing_Status__c
				  FROM
				  		Product_State_Status__c
				  WHERE 
				  	    Filing_Status__c IN: fillingStatusIds];
	}
	
	
	public static List<Product_State_Status__c> getByProductStateAvailabilityIds(List<Id> productStateAvailabilityIds)
	{
		return [SELECT
						ID,
						Filing_Status__c,
						Product_State_Availability__c
				    FROM
				        Product_State_Status__c
				     WHERE
				         Product_State_Availability__c IN:productStateAvailabilityIds];
	}
	
	
	public static Map<Id,Product_State_Status__c> getByfillingStatusMap(List<Id> fillingStatusIds)
	{
		Map<Id,Product_State_Status__c> fillinstatusIdProductStateStatusMap = new Map<Id,Product_State_Status__c>();
		
		for(Product_State_Status__c pd:getByFilingStatusIds(fillingStatusIds))
		{
			fillinstatusIdProductStateStatusMap.put(pd.Filing_Status__c,pd);
		}
		
		return fillinstatusIdProductStateStatusMap;
	}
	
	
	public static Map<Id,Product_State_Status__c> getByProductStateAvailabilityIdsMap(List<Id> productStateAvailabilityIds)
	{
		Map<Id,Product_State_Status__c> productStateAvailabilityIdProductStatus  = new Map<Id,Product_State_Status__c>();
		for(Product_State_Status__c pstate:getByProductStateAvailabilityIds(productStateAvailabilityIds))
		{
			productStateAvailabilityIdProductStatus.put(pstate.Product_State_Availability__c,pstate);
		}	
		
		return productStateAvailabilityIdProductStatus;			         
	}
	
    
}
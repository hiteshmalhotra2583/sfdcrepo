public class DAL_ProductSpecification {
	
	
	public static Map<Id,Product_Specification__c> getByIds(List<Id> ids)
	{
		return new Map<Id,Product_Specification__c>([
					SELECT
							ID,
							Name
					    FROM
					        Product_Specification__c
					     WHERE
					         Id IN:ids]);
	}
    
}
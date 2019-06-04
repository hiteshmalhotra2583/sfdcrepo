public class DAL_MarketingMaterial {

    public static Map<Id,Marketing_Materials__c> getByIds(List<Id> ids)
	{
		return new Map<Id,Marketing_Materials__c>([
					SELECT
							ID,
							Name
					    FROM
					        Marketing_Materials__c
					     WHERE
					         Id IN:ids]);
	}
}
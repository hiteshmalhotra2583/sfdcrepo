public class DAL_ProductState 
{
    public static List<State_Availability__c> getProductStatesWithChild(Set<string> productIds) {
        return [Select 
                    Id, 
                    State__c, 
                    Product_Specification__c,
                    Name,
                            (
                                Select 
                                Id,
                                Filing_Status__c, 
                                Product_State_Availability__c, 
                                Product_State_Availability__r.State__c,
                                Policy_Form_Status__c 
                                from Product_State_Statuses__r
                            )
                from State_Availability__c 
                where Product_Specification__c In : productIds order by createdDate];   
    }
   
    public static List<State_Availability__c> getProductStatesByParentId(Set<Id> productIds) {
        return [Select 
        			    Id,
		                Name, 
		                State__c, 
		                Product_Specification__c,
		                Product_Specification__r.name
		          FROM 
		                State_Availability__c
		          WHERE
		                Product_Specification__c IN: productIds 
		       ORDER BY State__c];
    }
}
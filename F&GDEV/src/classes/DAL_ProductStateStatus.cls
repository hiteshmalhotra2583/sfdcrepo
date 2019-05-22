public class DAL_ProductStateStatus {
    
    public static List<Product_State_Status__c> getProductStatusByIds(Set<Id> lstProductStatusIds) 
    {
        return [
                Select 
                Id, 
                Product_State_Availability__r.State__c, 
                Product_State_Availability__r.Product_Specification__r.Name,
                Filing_Status__r.Policy_Form__r.Name 
                from Product_State_Status__c where 
                Id 
                IN: lstProductStatusIds
                Order by 
                Product_State_Availability__r.State__c
                ];
    }
    
    public static List<Product_State_Status__c> getProductStatusByParent(Set<Id> setPolicyForm, Set<ID> setProductState)
    {
        return [
                Select 
                Id, 
                Product_State_Availability__c, 
                Filing_Status__c 
                from 
                Product_State_Status__c
                Where 
                Filing_Status__c IN:setPolicyForm 
                OR 
                Product_State_Availability__c IN:setProductState
                ];
    }

}
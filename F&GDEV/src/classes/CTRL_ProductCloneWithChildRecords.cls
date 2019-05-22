public class CTRL_ProductCloneWithChildRecords {
    
	@auraEnabled
    public static String cloneWithProducts(String productId, String productNewName)
    {
        HLPR_ProductCloneWithChildRecords cloneProductObj = new HLPR_ProductCloneWithChildRecords(productId);
        return cloneProductObj.cloneWithChildren(productNewName);
    }
    
    @auraenabled
    public static Product_Specification__c  getProductName(String productId)
    {
        return DAL_ProductSpecification.getByIds(new List<Id>{Id.valueOf(productId)}).values()[0];
    }
}
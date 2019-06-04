public class CTRL_MarketingMaterialClone {
	
    @auraEnabled
    public static String cloneMarketingMaterials(String marketingMaterialId, String marketingMaterialNewName)
    {
        HLPR_MarketingMaterialClone cloneProductObj = new HLPR_MarketingMaterialClone(marketingMaterialId);
        return cloneProductObj.cloneWithChildren(marketingMaterialNewName);
    }
    
    @auraenabled
    public static Marketing_Materials__c  getMarketingMaterialName(String marketingMaterialId)
    {
        return DAL_MarketingMaterial.getByIds(new List<Id>{Id.valueOf(marketingMaterialId)}).values()[0];
    }
}
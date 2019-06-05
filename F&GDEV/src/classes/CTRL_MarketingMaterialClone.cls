public class CTRL_MarketingMaterialClone {
	
    @auraEnabled
    public static String cloneMarketingMaterials(String marketingMaterialId)
    {
        HLPR_MarketingMaterialClone cloneProductObj = new HLPR_MarketingMaterialClone(marketingMaterialId);
        return cloneProductObj.cloneMarketingMaterial();
    }
    

}
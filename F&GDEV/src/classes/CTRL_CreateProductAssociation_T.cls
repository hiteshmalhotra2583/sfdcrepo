@isTest
private class CTRL_CreateProductAssociation_T {
    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Filing_Status__c> filingStatus = new List<Filing_Status__c>();
    public static List<Policy_Form_Detail__c> policyForms = new List<Policy_Form_Detail__c>();
    public static List<State_Availability__c> stateAvailabilitys = new List<State_Availability__c>();
    public static List<Product_Specification__c> products = new List<Product_Specification__c>();
    public static List<String> productStates = new List<String> {'AL','AK','AZ','CO'};
    public static List<String> policyFormStates = new List<String> {'AL','AK','DE','MI'};
    public static List<State__c> states = new List<State__c>();
    
    static void testData()
    {
    
        admin_User = TestDataFactory.createUser(true,true,SYSTEM_ADMINISTRATOR_PROFILE);
        
       // insert admin_User;
        System.runAs(admin_User)
        {
        	
        	for(String state:productStates)
        	{
        	    states.add(new State__c(Name=state,StateCode__c=state));
        	}
        	insert states;
        	Map<String,Object> policyFormDetailsMap = new Map<String,Object>();
            policyFormDetailsMap.put('Insurance_Type__c','Life');
        	for(Integer i = 0 ; i <count; i++)
            {
                policyForms.add((Policy_Form_Detail__c) TestDataFactory.operationOnObjectRecord(null, 'Policy_Form_Detail__c', policyFormDetailsMap));
            }
            insert policyForms; 
            
            for(Integer i = 0 ; i <count; i++)
            {
                products.add((Product_Specification__c) TestDataFactory.operationOnObjectRecord(null, 'Product_Specification__c', null));
            }
            insert products;
            
            Map<String,Object> productSpecificationsMaps = new Map<String,Object>();
            productSpecificationsMaps.put('Product_Specification__c',products[0].Id);
            
            for(String state : productStates)
            {
                productSpecificationsMaps.put('State__c',state);
                stateAvailabilitys.add((State_Availability__c) TestDataFactory.operationOnObjectRecord(null, 'State_Availability__c', productSpecificationsMaps));
            }
            insert stateAvailabilitys; 
            
            Map<String,Object> filingStatusMap = new Map<String,Object>();
            filingStatusMap.put('Policy_Form__c',policyForms[0].Id);
            for(String state : policyFormStates)
            {
                filingStatusMap.put('State__c',state);
                filingStatus.add((Filing_Status__c) TestDataFactory.operationOnObjectRecord(null, 'Filing_Status__c', filingStatusMap));
            }
            insert filingStatus; 
        } 
    
    }
    static testMethod void testCreateProductAssociations()
    {
        testData();
        List<State__c> lstStates = CTRL_CreateProductAssociation.getStates();
        CTRL_CreateProductAssociation.WRPR_ResultObj resultWrapper = CTRL_CreateProductAssociation.createProductAssociations( products,policyForms,new List<String>{'AL'});
        //assert
        System.assert(resultWrapper.lstSuccess.size()>1);
        resultWrapper = new CTRL_CreateProductAssociation.WRPR_ResultObj();
        List<String> testingStates = new List<String> {'AL','AK','AZ','WA','WY'};
        resultWrapper = CTRL_CreateProductAssociation.createProductAssociations( products,policyForms,testingStates);
        System.assert(resultWrapper.lstErrors.size()>1);
        CTRL_CreateProductAssociation.createProductAssociations( null,null,testingStates);
        CTRL_CreateProductAssociation.createProductAssociations( products,null,testingStates);
        CTRL_CreateProductAssociation.createProductAssociations( null,policyForms,testingStates);
    }
}
public class CTRL_CreateProductAssociation {
   
     @AuraEnabled
    public static List<State__c> getStates() 
    {
        List<State__c> returnlstStates = new List<State__c>();
        for(State__c s: State__c.getAll().values())
        {
        	if(!s.excludeFromProductStateCreation__c)
        	returnlstStates.add(s);
        }
        returnlstStates.sort();
        
        return  returnlstStates;
    }
   
    @AuraEnabled
    public static WRPR_ResultObj createProductAssociations(List<Product_Specification__c> lstProducts,
    														  List<Policy_Form_Detail__c> lstPolicyForms, 
    														  List<String> lstStates)
    {
       
        WRPR_ResultObj resultObj = new WRPR_ResultObj();
        List<WRPR_Result> lstSuccessMessage = new List<WRPR_Result>();
        List<WRPR_Result> lstErrorMessage = new List<WRPR_Result>();
        Set<String> setStatesInvolved = new Set<String>();
        Map<Id,Product_Specification__c> mapProductsSelected;
        Map<Id,Policy_Form_Detail__c> mapPolicyForms;
        List<Product_State_Status__c> lstProductStatusToInsert = new List<Product_State_Status__c>();
        Map<String,Product_State_Status__c> mapProductStatusToInsert = new Map<String,Product_State_Status__c>();
        
        if(  lstProducts != null && !lstProducts.IsEmpty() 
        	 && lstPolicyForms !=null  && !lstPolicyForms.IsEmpty() 
        	 && lstStates !=null  && !lstStates.IsEmpty())
         {
            
            setStatesInvolved.addAll(lstStates);
            setStatesInvolved.remove(null);
            Set<String> setStatesFilingStatus = new Set<String>(setStatesInvolved);
            Set<String> setStatesStateAvailability = new Set<String>(setStatesInvolved);
            Map<String,String> mapProductsWithBasePolicyFormId = new Map<String,String>();
            mapProductsSelected = new Map<Id, Product_Specification__c>(lstProducts);
            mapPolicyForms = new Map<Id, Policy_Form_Detail__c>(lstPolicyForms);
            
            //query child FilingStatus and State Availability records
            Map<Id, Filing_Status__c> mapPolicyForm = new Map<Id,Filing_Status__c>(DAL_FilingStatus.getByParentIds(new List<Id>(mapPolicyForms.keySet())));
            Map<Id, State_Availability__c> mapProdState  = new Map<Id, State_Availability__c>(DAL_ProductState.getProductStatesByParentId(mapProductsSelected.keySet()));
           
            //convert maps into maps with state keys
            Map<String,List<Filing_Status__c>> mapStateFilingStatus = convertMapToMap(mapPolicyForm.values(),setStatesInvolved,setStatesFilingStatus );
           
            Map<String,List<State_Availability__c>> mapStateProdState = convertMapStateAvailabilityToMap(mapProdState.values(),setStatesInvolved,setStatesStateAvailability);

            //query existing record before adding it to the list
            List<Product_State_Status__c> lstProductStateStatus = new List<Product_State_Status__c>();
            lstProductStateStatus = DAL_ProductStateStatus.getProductStatusByParent(mapPolicyForm.keySet(),mapProdState.keySet());
           
            //create a map of filing status and product status combination
            Set<String> setFilingStatusProductStateCombination = new Set<String>();
            if(lstProductStateStatus!=null && !lstProductStateStatus.isEmpty()) 
            {
                for(Product_State_Status__c prodStateAssociation : lstProductStateStatus) 
                {
                    setFilingStatusProductStateCombination.add(prodStateAssociation.Product_State_Availability__c +''+ prodStateAssociation.Filing_Status__c);
                }
            }
           
            if(mapStateProdState!=null 
               && !mapStateProdState.IsEmpty() 
               && mapStateFilingStatus!=null 
               && !mapStateFilingStatus.IsEmpty() ) 
              {
                for(String state: setStatesInvolved)
                 {
                    List<Filing_Status__c> lstStatePolicyForm = new List<Filing_Status__c>();
                    List<State_Availability__c> lstStateProdState = new List<State_Availability__c>();
                    Boolean stateHasRecords = true;
                    
                    //add error messages for state records
                    if(!mapStateFilingStatus.containsKey(state) && state!=null) 
                    {
                        lstErrorMessage.add(getResultObj('Policy form status records not found for state:  '+state,state,''));
                        stateHasRecords = false;
                    }
                    if(!mapStateProdState.containsKey(state) && state!=null)
                    {
                        lstErrorMessage.add(getResultObj('Product state status records not found for state:  '+state,state,''));
                        stateHasRecords = false;
                    }
                    
                    //iterate through all records
                    if(stateHasRecords)
                    {
                       for(Filing_Status__c policyForm : mapStateFilingStatus.get(state)) 
                        {
                            for(State_Availability__c StateProd : mapStateProdState.get(state))
                             {
                                if(setFilingStatusProductStateCombination.contains(StateProd.Id + '' +policyForm.Id)) 
                                {
                                    lstErrorMessage.add(getResultObj('A product association record already exists for the state:' +state +
                                                                ' and the Policyform:  '+policyform.Policy_Form__r.name + ' and Product:  ' + StateProd.Product_Specification__r.name,state,StateProd.Product_Specification__r.name));
                                    //the combination already exists. 
                                    //skip the loop
                                    continue;
                                }
                                
                                //base policy form already linked for that product
                                if(mapProductsWithBasePolicyFormId.containsKey(StateProd.Product_Specification__c) && policyForm.Policy_Form__r.Base_Policy_Form__c) 
                                {
                                    lstErrorMessage.add(getResultObj('Base policy form already linked with the product:  '+StateProd.Product_Specification__r.name,state,StateProd.Product_Specification__r.name));
                                    //skip the loop
                                    continue;
                                } 
                                if(policyForm.Policy_Form__r.Base_Policy_Form__c!=null && policyForm.Policy_Form__r.Base_Policy_Form__c) 
                                {
                                    mapProductsWithBasePolicyFormId.put(StateProd.Id,policyForm.Id);
                                }
                                Product_State_Status__c objProductStateStatus = new Product_State_Status__c(Product_State_Availability__c =StateProd.Id, Filing_Status__c=policyForm.Id);
                                 if(!mapProductStatusToInsert.containsKey(String.valueOf(StateProd.Id) + String.valueOf(policyForm.Id)))
                                 {
                                     mapProductStatusToInsert.put(String.valueOf(StateProd.Id) + String.valueOf(policyForm.Id),objProductStateStatus);
                                 }
                            }
                        } 
                    }
                    
                }
            }
            else if (mapStateProdState.isEmpty()) 
            {
                lstErrorMessage.add(getResultObj('Product state status records not found for selected states','',''));
            }
            else if(mapStateFilingStatus.isEmpty()) 
            {
                lstErrorMessage.add(getResultObj('Policy form state status records not found for selected states','',''));
            }
            try {
                   if(mapProductStatusToInsert != null
                    && !mapProductStatusToInsert.isEmpty()) 
                    {
                        insert mapProductStatusToInsert.values();
                    }
                //query inserted records and add to the success list
                List<Product_State_Status__c> lstProductStateStatusSuccess = new List<Product_State_Status__c>();
                Map<Id,Product_State_Status__c> mapTempProductStateStatus = new Map<Id,Product_State_Status__c>(mapProductStatusToInsert.values());
                lstProductStateStatusSuccess = DAL_ProductStateStatus.getProductStatusByIds(mapTempProductStateStatus.keySet());
                
                for(Product_State_Status__c successRecord : lstProductStateStatusSuccess) 
                {
                    WRPR_Result resultString = new WRPR_Result();
                    resultString.resultValue = 'Record added for State:  ' + successRecord.Product_State_Availability__r.State__c + ' for Product:  ' +successRecord.Product_State_Availability__r.Product_Specification__r.Name+
                                        ' Policy form:  '+ successRecord.Filing_Status__r.Policy_Form__r.Name;
                    resultString.state =  successRecord.Product_State_Availability__r.State__c;
                    resultString.product = successRecord.Product_State_Availability__r.Product_Specification__r.Name;
                    lstSuccessMessage.add(resultString);
                }
            } catch(Exception ex) {
                lstErrorMessage = new List<WRPR_Result>();
                //WRPR_Result resultString = new WRPR_Result();
                lstErrorMessage.add(getResultObj('Error occured during insert operation'+ex.getMessage(),'',''));
            }
            
        } 
        else 
        {
            if(lstProducts == null || lstProducts.isEmpty())
            {
                lstErrorMessage.add(getResultObj('No Product records provided','',''));
            }
            if(lstPolicyForms == null || lstPolicyForms.isEmpty())
            {
                lstErrorMessage.add(getResultObj('No Policy form records provided','',''));
            }
        }
        lstSuccessMessage.sort();
        lstErrorMessage.sort();
        resultObj.lstSuccess = lstSuccessMessage;
        resultObj.lstErrors = lstErrorMessage;
        return resultObj;
    }
    
    public static Map<String,List<Filing_Status__c>> convertMapToMap(List<Filing_Status__c> policyForms, 
    																 Set<String> setStatesInvolved,
    																 Set<String> setStatesFilingStatus)
    {
    	//convert maps into maps with state keys
	    Map<String,List<Filing_Status__c>> mapStateFilingStatus = new Map<String,List<Filing_Status__c>>();
	    Map<String,List<State_Availability__c>> mapStateProdState = new Map<String,List<State_Availability__c>>();
	    for(Filing_Status__c policyForm: policyForms) 
	    {
	        //add only those for which states are selected
	        if(setStatesInvolved.contains(policyForm.State__c)) 
	        {
	            setStatesFilingStatus.remove(policyForm.State__c);
	            if(mapStateFilingStatus.containsKey(policyForm.State__c))
	            {
	                mapStateFilingStatus.get(policyForm.State__c).add(policyForm);
	            } 
	            else
	            {
	                mapStateFilingStatus.put(policyForm.State__c, new List<Filing_Status__c>{policyForm});
	            }
	        }
	    }
        return mapStateFilingStatus;
    }
    
    public static Map<String,List<State_Availability__c>> convertMapStateAvailabilityToMap(List<State_Availability__c> mapProdStates,
    																				 Set<String> setStatesInvolved,
    																				 Set<String> setStatesStateAvailability)
    {
    	//convert maps into maps with state keys
    	Map<String,List<State_Availability__c>> mapStateProdState = new Map<String,List<State_Availability__c>>();
	    for(State_Availability__c prodState: mapProdStates) 
	    {
                if(setStatesInvolved.contains(prodState.State__c)) 
                {
                    setStatesStateAvailability.remove(prodState.State__c);
                    if(mapStateProdState.containsKey(prodState.State__c)) 
                    {
                        mapStateProdState.get(prodState.State__c).add(prodState);
                    } 
                    else 
                    {
                        mapStateProdState.put(prodState.State__c, new List<State_Availability__c>{prodState});
                    }
                }
            }
        return mapStateProdState;
    }
    
    
    
    public class WRPR_Result implements  comparable
    {
        @AuraEnabled 
        public string resultValue;
        @AuraEnabled
        public string state;
        @AuraEnabled
        public string product;
        
        public integer compareTo(object objToCompare) {
            WRPR_Result resultObj = (WRPR_Result) objToCompare;
            if(this.product < resultObj.product)
                return -1;
            if(this.product > resultObj.product)
                return 1;
            return 0;
        }
    }
    
    private static WRPR_Result getResultObj(String messageSTR, String state, String product) 
    {
        WRPR_Result resultObj = new WRPR_Result();
        resultObj.resultValue =  messageSTR;
        resultObj.state = state;
        resultObj.product = product;
        return resultObj;
    }
   
    public class WRPR_ResultObj
    {
        @AuraEnabled
        public List<WRPR_Result> lstSuccess;
        @AuraEnabled
        public List<WRPR_Result> lstErrors;
    }
}
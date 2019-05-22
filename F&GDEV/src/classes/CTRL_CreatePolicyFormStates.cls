public class CTRL_CreatePolicyFormStates
{
	
	@AuraEnabled
    public static List<String> getselectOptions(String getFrom,String objectName,String  methodOrFieldName, String parentRecordId) {
        Map<String,String> mapStateOptions = new Map<String,String>();
        mapStateOptions = CTRL_CreateMassPolicyForm.getselectOptions(getFrom,objectName,methodOrFieldName);
        mapStateOptions.keySet().removeAll(policyStatesAlreadyCreated(parentRecordId));
        mapStateOptions.values().sort();
        return mapStateOptions.values();
    }
    
    @AuraEnabled
    public static String createChildPolicyStates(String policyFormId, List<String> selectedStates)
    {
        String message = 'State records created';
        List<Filing_Status__c> lstFilingStatusToInsert = new List<Filing_Status__c>();
        List<Id> policyFormIds = new List<Id>(); 
        policyFormIds.add(Id.valueof(policyFormId));
        Policy_Form_Detail__c parentRecord = DAL_PolicyFormDetail.getByIds(policyFormIds)[0];
        try 
        {
            for(String state : selectedStates)
            {
                Filing_Status__c filingStatusObj = new Filing_Status__c(Policy_Form__c = parentRecord.Id, State__c =state  );
                lstFilingStatusToInsert.add(filingStatusObj);
            }
            
            if(lstFilingStatusToInsert!=null && !lstFilingStatusToInsert.isEmpty()) {
				insert lstFilingStatusToInsert;                
            }
        }catch(Exception ex)
         {
            message = 'Error occured while creating state records' + ex.getMessage();
        }
        
        return message;
    }  
   
   
    private Static Set<String> policyStatesAlreadyCreated(String recordId)
    {
        Set<String> policyStates = new Set<String>();
        List<Id> recordIds = new List<Id>(); 
        recordIds.add(Id.valueof(recordId));
        List<Filing_Status__c> policyFormStates = DAL_FilingStatus.getByParentIds(recordIds);
        for(Filing_Status__c state: policyFormStates) 
        {
            policyStates.add(state.State__c);
        }
        
        return policyStates;
    }
}
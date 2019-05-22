public class TH_ApprovalState extends BaseTriggerHandler {
	
	
	private List<Approval_State__c> newApprovalState;
    private List<Approval_State__c> oldApprovalState;
    private Map<ID, Approval_State__c> newApprovalStateMap;
    private Map<ID, Approval_State__c> oldApprovalStatelMap;
	
	public TH_ApprovalState()
    {
        oldApprovalState = (List<Approval_State__c>)Trigger.old;
        newApprovalState = (List<Approval_State__c>)Trigger.new;
        newApprovalStateMap = (Map<ID, Approval_State__c>)Trigger.newMap;
        oldApprovalStatelMap = (Map<ID, Approval_State__c>)Trigger.oldMap;
    }
    
     @TestVisible
    protected override void afterInsert()
    {
    	if(TriggerCheck.canRun('TH_APPROVALSTATE'))
        {
    		// Upate the parent object to append the name and set the status to active
    		setApprovedStatesOnPolicyForm(oldApprovalStatelMap, newApprovalStateMap);
    		
        }
    }
    public void setApprovedStatesOnPolicyForm(Map<Id, Approval_State__c> oldMap, Map<Id, Approval_State__c> newMap)
    {
        Set<Id> setPolicyForms = new Set<Id>();
        Map<Id,Set<String>> mapPolicyFormToUpdate = new Map<Id,Set<String>>();
        List<Policy_Form_Detail__c> lstPolicyFormToUpdate = new List<Policy_Form_Detail__c>();
        for(Approval_State__c policyState: newMap.values())
        {
            setPolicyForms.add(policyState.Policy_Form__c);
        }
       
        if(setPolicyForms!=null && !setPolicyForms.isEmpty())
        {
            //query all children of the policyforms
            List<Approval_State__c> lstPolicyState = DAL_Approval_State.getApprovalStateByParentIds(setPolicyForms);
            for(Approval_State__c policyState : lstPolicyState)
            {
                if(mapPolicyFormToUpdate.containsKey(policyState.Policy_Form__c))
                {
                    mapPolicyFormToUpdate.get(policyState.Policy_Form__c).add(policyState.Situs_State__c);  
                } else
                {
                    mapPolicyFormToUpdate.put(policyState.Policy_Form__c, new Set<String>{policyState.Situs_State__c});
                }
            }
            
            for(Id policyFormId: mapPolicyFormToUpdate.keySet())
            {
                Policy_Form_Detail__c pf = new Policy_Form_Detail__c(Id=policyFormId);
                pf.Status__c = 'Active';
                pf.Approved_States__c = String.Join(new List<String>(mapPolicyFormToUpdate.get(policyFormId)),';');
                lstPolicyFormToUpdate.add(pf);
            }
        }
        
        if(lstPolicyFormToUpdate!=null && !lstPolicyFormToUpdate.isEmpty())
        {
            BaseTriggerHandler.bypass('TH_POLICYFORMDETAILHANDLER');
            update lstPolicyFormToUpdate;
            BaseTriggerHandler.clearByPass('TH_POLICYFORMDETAILHANDLER');    
        }
        
    }
}
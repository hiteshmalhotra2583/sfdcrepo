public class PolicyFormDetailHandler extends BaseTriggerHandler {
	
	
	private List<Policy_Form_Detail__c> newPolicyFormDetail;
    private List<Policy_Form_Detail__c> oldPolicyFormDetail;
    private Map<ID, Policy_Form_Detail__c> newPolicyFormDetailMap;
    private Map<ID, Policy_Form_Detail__c> oldPolicyFormDetaillMap;
	
	public PolicyFormDetailHandler()
    {
        oldPolicyFormDetail = (List<Policy_Form_Detail__c>)Trigger.old;
        newPolicyFormDetail = (List<Policy_Form_Detail__c>)Trigger.new;
        newPolicyFormDetailMap = (Map<ID, Policy_Form_Detail__c>)Trigger.newMap;
        oldPolicyFormDetaillMap = (Map<ID, Policy_Form_Detail__c>)Trigger.oldMap;
    }

  @TestVisible
    protected override void afterUpdate()
    {
		if(TriggerCheck.canRun('TH_POLICYFORMDETAILHANDLER'))
		{
			changePolicyFormStatesName(newPolicyFormDetail,oldPolicyFormDetaillMap,newPolicyFormDetailMap);
		}
    }
    
    public void changePolicyFormStatesName(List<Policy_Form_Detail__c> newPolicyFormDetail,
     										 Map<Id, Policy_Form_Detail__c> oldPolicyFormDetaillMap, 
     										 Map<Id, Policy_Form_Detail__c> newPolicyFormDetailMap)
     {
        	List<Id> idsforWhichNameChanged = new List<Id>();
        	for(Policy_Form_Detail__c ps: newPolicyFormDetail)
        	{
        		if(oldPolicyFormDetaillMap.get(ps.Id).Name != ps.Name)
        		{
        			idsforWhichNameChanged.add(ps.Id);
        		}
        	}
        	
        	
        	if(! idsforWhichNameChanged.isEmpty())
        	{
            	Map<Id,List<Filing_Status__c>> byParentIdMap = DAL_FilingStatus.getByParentIdMap(idsforWhichNameChanged);
            	List<Filing_Status__c> toUpdatePolicyFormState = new List<Filing_Status__c>();
                for(Id i: idsforWhichNameChanged)
                {
                    for(Filing_Status__c s: byParentIdMap.get(i))
                    {
                        toUpdatePolicyFormState.add(new Filing_Status__c(Id=s.Id,
                                                       Name = newPolicyFormDetailMap.get(s.Policy_Form__c).Name+'-'+s.State__c));
                    }
                }
            	if(!toUpdatePolicyFormState.isEmpty())
            	{
            		update toUpdatePolicyFormState;
            	}
        	}
        	
     }

}
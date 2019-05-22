public with sharing class DAL_FilingStatus
{
	public static List<Filing_Status__c> getByParentIds(List<Id> parentIds)
    {
        return [SELECT
                       Id,
                       Name,
                       State__c,
                       Policy_Form__c,
                       Policy_Form__r.Base_Policy_Form__c,
                	   Policy_Form__r.Name
                   FROM
                       Filing_Status__c
                  WHERE 
                       Policy_Form__c IN:parentIds];
	
    }
	
	public static Map<Id,List<Filing_Status__c>> getByParentIdMap(List<Id> parentIds)
    {
        List<Filing_Status__c> policyFormStates = getByParentIds(parentIds);
										                       
		Map<Id,List<Filing_Status__c>>	tranxcationIdMap = new Map<Id,List<Filing_Status__c>>();	
		for(Filing_Status__c policyFormState: policyFormStates)
		{
			List<Filing_Status__c> policyFormStat  = null;
			{
				if(tranxcationIdMap.get(policyFormState.Policy_Form__c) != null)
				{
					policyFormStat  = tranxcationIdMap.get(policyFormState.Policy_Form__c);
				}else
				{
					policyFormStat  = new List<Filing_Status__c>();
				}
		        policyFormStat.add(policyFormState);
			}
			tranxcationIdMap.put(policyFormState.Policy_Form__c,policyFormStat);
		}
		
		return tranxcationIdMap;			                       
    }
    
    public static List<Filing_Status__c> getByParentIDsAndFilingStrategy(List<Id> parentIds)
    {
        return [ Select
                        Id,
                        Name,
                        Policy_Form__c,
                        State_Approval_Date__c,
                        Situs_State__c,
                        Filing_Status__c,
                        Filing_Strategy__c
                    FROM
                        Filing_Status__c
                    WHERE
                        Policy_Form__c IN:parentIds
                    AND
                        Filing_Strategy__c like '% Dependent'
                    AND
                        (Policy_Form__r.Approved_States__c = null
                         OR Policy_Form__r.Approved_States__c = '')
            ];
    }
    
}
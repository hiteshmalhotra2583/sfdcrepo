public class DAL_Approval_State {
    
    public static List<Approval_State__c> getPrimaryApprovalStateByParentIds(Set<Id> parentIds)
    {
        return [SELECT
                        Id,
                        Name,
                        Is_Primary__c,
                        Policy_Form__c
                    FROM
                        Approval_State__c
                  WHERE 
                  		Policy_Form__c IN : parentIds
                    AND 
                        Is_Primary__c = True
                ];
                        
    }
    public static List<Approval_State__c> getApprovalStateByParentIds(Set<Id> parentIds)
    {
        return [SELECT
                        Id,
                        Name,
                        Is_Primary__c,
                        Policy_Form__c,
                        Situs_State__c
                    FROM
                        Approval_State__c
                  WHERE 
                        Policy_Form__c IN : parentIds
                		Order by Situs_State__c
                ];
                        
    }

}
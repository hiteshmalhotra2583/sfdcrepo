public with sharing class PolicyStateHandler extends BaseTriggerHandler {
	
	
	private List<Filing_Status__c> newFilingStatus;
    private List<Filing_Status__c> oldFilingStatuss;
    private Map<ID, Filing_Status__c> newFilingStatusMap;
    private Map<ID, Filing_Status__c> oldFilingStatuslMap;
	
	public PolicyStateHandler()
    {
        oldFilingStatuss = (List<Filing_Status__c>)Trigger.old;
        newFilingStatus = (List<Filing_Status__c>)Trigger.new;
        newFilingStatusMap = (Map<ID, Filing_Status__c>)Trigger.newMap;
        oldFilingStatuslMap = (Map<ID, Filing_Status__c>)Trigger.oldMap;
    }
    
    
     @TestVisible
    protected override void beforeInsert()
    {
    	if(TriggerCheck.canRun('TH_POLICYSTATEHANDLER'))
        {
    		namePolicyStateRecord(Trigger.isBefore, Trigger.isInsert, newFilingStatus);
        }
    }
    
    @TestVisible
    protected override void afterUpdate()
    {
		if(TriggerCheck.canRun('TH_POLICYSTATEHANDLER'))
		{
			policyStateStatusChange(Trigger.isAfter, Trigger.isUpdate, oldFilingStatuslMap, newFilingStatusMap);
			//
			setApprovalDateOnPoilcyForm(oldFilingStatuslMap, newFilingStatusMap);
		}
    }
    
    // Requirement to Functionality to update dependent filings when the situs state or compact record is approved
   public void setApprovalDateOnPoilcyForm(Map<Id, Filing_Status__c> oldMap, Map<Id, Filing_Status__c> newMap)
   {
   	   Set<Id> setPolicyFormAffected = new Set<Id>();
   	   Map<Id,Filing_Status__c> mapGroupFilingPolicyFormDateTime = new Map<Id,Filing_Status__c>();
   	   Map<Id,Filing_Status__c> mapCompactFilingPolicyFormDateTime = new Map<Id,Filing_Status__c>();
   	   List<Filing_Status__c> lstFilingStatusToUpdate = new List<Filing_Status__c>();
   	   for(Filing_Status__c policyState : newMap.values()) 
   	   {
   	    	system.debug(' policyState.State_Approval_Date__c::::'+ policyState.Submitted_to_State_Date__c);
   	    	
   	    	if(policyState.Submitted_to_State_Date__c == null)
   	       {
	   	    	if(  policyState.State_Approval_Date__c == null &&
	   	    		(policyState.Filing_Strategy__c == 'Group Filing' 
	   	    		 || policyState.Filing_Strategy__c == 'Compact Filing'))
	   	    	{
	   	    		Trigger.new[0].addError('Approval date is required for Group filing and Compact filing ');
   	    	}
   	       }
   	   }
   	   
   	   
   	   for(Filing_Status__c policyState : newMap.values()) 
   	   {
   	       if( policyState.State_Approval_Date__c != null 
   	       	 && policyState.Filing_Strategy__c != null
   	       	 && policyState.Filing_Strategy__c.contains('Filing')) 
   	        {
   	           if(policyState.Filing_Strategy__c == 'Group Filing') 
   	           {
   	               mapGroupFilingPolicyFormDateTime.put(policyState.Policy_Form__c,policyState);
   	              
   	           }
   	           if(policyState.Filing_Strategy__c == 'Compact Filing') 
   	           {
   	               mapCompactFilingPolicyFormDateTime.put(policyState.Policy_Form__c,policyState);
   	               
   	               
   	           }
   	           Filing_Status__c policyStateToUpdate = new Filing_Status__c(id=policyState.Id);
   	           policyStateToUpdate.Filing_Status__c = 'Approved';
   	           lstFilingStatusToUpdate.add(policyStateToUpdate);
   	           setPolicyFormAffected.add(policyState.Policy_Form__c);
   	       }
   	   }
   	   
   	   if(setPolicyFormAffected != null && !setPolicyFormAffected.isEmpty()) 
   	   {
   	       //query group dependent policy form records and set Approval date on policy forms
   	       List<Filing_Status__c> lstPolicyFormsChild = new List<Filing_Status__c>();
   	       lstPolicyFormsChild = DAL_FilingStatus.getByParentIDsAndFilingStrategy(new List<Id>(setPolicyFormAffected));
   	       if(lstPolicyFormsChild != null && !lstPolicyFormsChild.isEmpty())
   	       {
   	           for(Filing_Status__c policyState : lstPolicyFormsChild)
   	           {
   	               if(mapGroupFilingPolicyFormDateTime.containsKey(policyState.Policy_Form__c))
   	               {
   	                   policyState.State_Approval_Date__c = mapGroupFilingPolicyFormDateTime.get(policyState.Policy_Form__c).State_Approval_Date__c;
   	                   policyState.Situs_State__c = mapGroupFilingPolicyFormDateTime.get(policyState.Policy_Form__c).State__c;
   	                   policyState.Filing_Status__c = 'Approved - Dependent Group';
   	                   lstFilingStatusToUpdate.add(policyState);
   	                   
   	               }
   	               if(mapCompactFilingPolicyFormDateTime.containsKey(policyState.Policy_Form__c))
   	               {
   	                   policyState.State_Approval_Date__c = mapCompactFilingPolicyFormDateTime.get(policyState.Policy_Form__c).State_Approval_Date__c;
   	                   policyState.Situs_State__c = mapCompactFilingPolicyFormDateTime.get(policyState.Policy_Form__c).State__c;
   	                   policyState.Filing_Status__c = 'Approved - Dependent Compact';
   	                   lstFilingStatusToUpdate.add(policyState);
   	               }
                        
                        
   	           }
   	           if(lstFilingStatusToUpdate!=null && !lstFilingStatusToUpdate.isEmpty())
   	           {
   	               BaseTriggerHandler.bypass('POLICYSTATEHANDLER');
   	               update lstFilingStatusToUpdate;
   	               BaseTriggerHandler.clearBypass('POLICYSTATEHANDLER');
   	           }
   	           
   	       }
   	       //create Approval_State__c for each situs state
   	       Map<Id,Filing_Status__c> mapSitusStates = new Map<Id,Filing_Status__c>();
   	       mapSitusStates.putAll(mapGroupFilingPolicyFormDateTime);
   	       mapSitusStates.putAll(mapCompactFilingPolicyFormDateTime);
   	       createApprovalState(mapSitusStates);
   	   }
   }
    
   // Requirement to Functionality to update dependent filings when the situs state or compact record is approved
   public void setApprovalStatus()
   {
   	  for(Filing_Status__c fs:newFilingStatus)
   	  {
   	  	if(fs.State_Approval_Date__c  != null)
        {
        	fs.Filing_Status__c = 'Approved';
        }   	  	
   	  }
   }
   
   public void createApprovalState(Map<Id,Filing_Status__c> mapPolicyFromSitusStates) 
   {
      If(mapPolicyFromSitusStates!=null && !mapPolicyFromSitusStates.isEmpty())
      {
          List<Approval_State__c> lstApprovalStateToInsert = new List<Approval_State__c>();
          Set<Id> policyFormsHavePrimaryApprovalState = new Set<Id>();
          //check if policy form has primary Approval_state
          List<Approval_State__c> lstPrimaryApprovalState = new List<Approval_State__c>();
          lstPrimaryApprovalState = DAL_Approval_State.getPrimaryApprovalStateByParentIds(mapPolicyFromSitusStates.keySet());
          for(Approval_State__c approvedState : lstPrimaryApprovalState) 
          {
              policyFormsHavePrimaryApprovalState.add(approvedState.Policy_Form__c);
          }
          for(Filing_Status__c policyState : mapPolicyFromSitusStates.values())
          {
              Approval_State__c situsState = new Approval_State__c();
              situsState.Policy_Form__c = policyState.Policy_Form__c;
              situsState.Approval_Date_Time__c = policyState.State_Approval_Date__c;
              if(!policyFormsHavePrimaryApprovalState.contains(policyState.Policy_Form__c)) 
              {
                  situsState.Is_Primary__c = true;
              }
              situsState.Situs_State__c = policyState.State__c;
              lstApprovalStateToInsert.add(situsState);
          }
          if(lstApprovalStateToInsert!=null && !lstApprovalStateToInsert.isEmpty())
          {
              insert lstApprovalStateToInsert;
          }
      }
   }
    
    
	public void namePolicyStateRecord(Boolean isBefore, Boolean isInsert, List<Filing_Status__c> newList) {
		
		if(isBefore && isInsert){
			//	Retrieve List of Product Names

			//	-- Create Set of Product Spec Ids
			Set<Id> policyIdSet = new Set<Id>();
			for(Filing_Status__c filingstat : newList){
				policyIdSet.add(filingstat.Policy_Form__c);
			}

			//	-- Create Map of Product Spec Id to Product Name
			Map<Id, Policy_Form_Detail__c> policyspecMap = new Map<Id, Policy_Form_Detail__c>(DAL_PolicyFormDetail.getByIds(new List<Id>(policyIdSet)));

			for(Filing_Status__c filingstat : newList){
				if(policyspecMap.containsKey(filingstat.Policy_Form__c)){
					filingstat.Name = policyspecMap.get(filingstat.Policy_Form__c).Name + ' - ' + filingstat.State__c;
				}
			}
		}
	}

	public void policyStateStatusChange(Boolean isAfter, Boolean isUpdate, Map<Id, Filing_Status__c> oldMap, Map<Id, Filing_Status__c> newMap){
		if(isAfter && isUpdate){
			Set<Id> FilingStatSetforUpd = new Set<Id>();

			for(Id key : newMap.keySet()){
				//	Only Process Records with Changed Filing Status
				if(oldMap.get(key).Filing_Status__c != newMap.get(key).Filing_Status__c){
					FilingStatSetforUpd.add(key);
				}
			}

			if(FilingStatSetforUpd.size() > 0)
			{
				List<Product_State_Status__c> pssforUpdList = new List<Product_State_Status__c>();
				for(Product_State_Status__c pss : [Select Id, Filing_Status__c, Filing_Status__r.Filing_Status__c from Product_State_Status__c Where Filing_Status__c in: FilingStatSetforUpd])
				{
					pss.Policy_Form_Status__c = pss.Filing_Status__r.Filing_Status__c;
					pssforUpdList.add(pss);
				}

				//	Update Product State Status with New Filing Status Value
				if(pssforUpdList.size() > 0)
				{
					update pssforUpdList;
				}
			}
		}
	}
    
}
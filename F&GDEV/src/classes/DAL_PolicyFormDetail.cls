public with sharing class DAL_PolicyFormDetail {
	
	public static List<Policy_Form_Detail__c> getByIds(List<Id> ids)
	{
		return [Select 
					   id,
					   Name,
					   Approved_States__c
			      FROM 
			      	  Policy_Form_Detail__c
			    WHERE 
			    	 Id IN:ids];
	}	
    
    
    public static List<Policy_Form_Detail__c> getByName(String formName)
	{
		return [SELECT 
						Id,
						Name,
						createddate
			       FROM 
			       		Policy_Form_Detail__c
			      WHERE 
			           Name=:formName 
			     ORDER by createddate desc];
	}	
	
	public static List<Policy_Form_Detail__c> getByPolicyFormDetailIds(List<Id> policyIds)
	{
		return [Select Id, 
					   Name,
					   Policy_Form_Name__c,
					   Project__c,
               		   Status__c, 
                       Policy_Form_Type__c,
	                   (Select
	                   		  Id,
                              State__c, 
	                    	  Filing_Status__c, 
	                   		  File_Date_To_Vendor__c, 
	                  		  Filing_Followup_Date__c,
	                   		  State_Approval_Date__c, 
	                   		  Submitted_to_State_Date__c, 
	                   		  Objection_Deadline_Date__c,
	                    	  Objection_Received_Date__c,
	                          Objection_Response_Date__c,
                        	  Most_Recent_Objection_Response_Date__c,
	                          Target_File_Date__c, 
	                    	  Filing_Withdrawn_Date__c,
	                  		  Filing_Notes__c, 
	                  		  Filing_Notes_Status_Notes__c 
	                     FROM 
	                     	  Filing_Statuses__r) 
                   FROM 
                        Policy_Form_Detail__c
                  WHERE
                        Id in: policyIds];
	}
}
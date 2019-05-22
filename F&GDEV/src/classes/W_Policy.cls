global with sharing class W_Policy 
{
	global W_Policy(Policy_Form_Detail__c policy, Filing_Status__c filingstatus)
	 {
		this(policy);
		this.Status = filingstatus.Filing_Status__c;

		//	Calculate and Set Date
		if(this.Status == 'Filed'){
			if(filingstatus.File_Date_To_Vendor__c != null){
				this.StatusDate = filingstatus.File_Date_To_Vendor__c.format();
			}else if (filingstatus.Filing_Followup_Date__c != null){
				this.StatusDate = filingstatus.Filing_Followup_Date__c.format();
			}
            //Label : Submitted to State Date field
            else if(filingstatus.Submitted_to_State_Date__c != null){
				this.StatusDate = filingstatus.Submitted_to_State_Date__c.format();
			}
		}else if (this.Status == 'Approved'){
			if(filingstatus.State_Approval_Date__c != null){
				this.StatusDate = filingstatus.State_Approval_Date__c.format();
			}
		}else if (this.Status == 'Objection'){
			if(filingstatus.Objection_Deadline_Date__c != null){
				this.StatusDate = filingstatus.Objection_Deadline_Date__c.format();
			}else if (filingstatus.Objection_Received_Date__c != null){
				this.StatusDate = filingstatus.Objection_Received_Date__c.format();
			}else if (filingstatus.Objection_Response_Date__c != null){
				this.StatusDate = filingstatus.Objection_Response_Date__c.format();
            }
            //Rollup field from Filing Objection object
            else if(filingstatus.Most_Recent_Objection_Response_Date__c != null){
                this.StatusDate = filingstatus.Most_Recent_Objection_Response_Date__c.format();
            }

		}else if (this.Status == 'Targeted'){
			if(filingstatus.Target_File_Date__c != null){
				this.StatusDate = filingstatus.Target_File_Date__c.format();
			}

		}else if (this.Status == 'Withdrawn'){
			if(filingstatus.Filing_Withdrawn_Date__c != null){
				this.StatusDate = filingstatus.Filing_Withdrawn_Date__c.format();
			}

		}	

		this.FilingStatusId = filingstatus.Id;
		this.FilingStatusObj = filingstatus;
	}

	global W_Policy(Policy_Form_Detail__c policy) {
		this.Id = policy.Id;
		this.Name = policy.Name;
		this.FormName = policy.Policy_Form_Name__c;	
        this.PolicyFormType = policy.Policy_Form_Type__c;
        this.PolicyFormStatus = policy.Status__c;
		this.UISelected = false;
	}

	//	public Policy_Form_Detail__c PolicyInstance{get{return pvtPolicy;}}
	global Id Id{get; set;}
	global Id FilingStatusId {get; set;}
	global Id FilingStatusAvailId {get; set;}
	
	global String Name {get; set;}
	global String FormName {get; set;}
	global String Status {get; set;}
	global String StatusDate {get; set;}

	global Boolean UISelected{get; set;}
    global String PolicyFormType{get;set;}
    global String PolicyFormStatus{get;set;}
	global Filing_Status__c FilingStatusObj {get; set;}
     

}
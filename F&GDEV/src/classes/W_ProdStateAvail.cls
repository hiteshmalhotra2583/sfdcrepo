global with sharing class W_ProdStateAvail
{
	global W_ProdStateAvail(State_Availability__c stateavail) {
		this.StateAvailId = stateavail.Id;
		this.PolicytoProdStateStat = new Map<Id, W_ProdStateStatus>();	
	}
    global W_ProdStateAvail(State_Availability__c stateavail,String ltng) {
		this.StateAvailId = stateavail.Id;
        this.Status = stateavail.Status__c;
        if(!string.isBlank(stateavail.Status__c)){
            if(stateavail.Status__c=='Approved'){
                this.StatusDate = stateavail.Approval_Date__c;
            }else if(stateavail.Status__c=='Filing Targeted'){
                this.StatusDate = stateavail.Target_Launch_Date__c;
            }else if(stateavail.Status__c=='Launched'){
                this.StatusDate = stateavail.Launch_Date__c;
            }else if(stateavail.Status__c=='Pulled'){
                this.StatusDate = stateavail.Pull_Date__c;
            }
        }
		this.PolicytoProdStateStat = new Map<Id, W_ProdStateStatus>();	
	}

	global Id StateAvailId{get; set;}
	global Map<Id, W_ProdStateStatus> PolicytoProdStateStat	{get; set;}
    global String Status{get; set;}
    global Date StatusDate{get; set;}
}
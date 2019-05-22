public with sharing class ProjectHandler extends BaseTriggerHandler {
	
	
	private List<Project__c> newProject;
    private List<Project__c> oldProjects;
    private Map<ID, Project__c> newProjectMap;
    private Map<ID, Project__c> oldProjectlMap;
	
	public ProjectHandler()
    {
        oldProjects = (List<Project__c>)Trigger.old;
        newProject = (List<Project__c>)Trigger.new;
        newProjectMap = (Map<ID, Project__c>)Trigger.newMap;
        oldProjectlMap = (Map<ID, Project__c>)Trigger.oldMap;
    }
    
    
     @TestVisible
    protected override void beforeUpdate()
    {
    	if(TriggerCheck.canRun('TH_PROJECTHANDLER'))
        {
    		requestAutonumber(Trigger.isBefore, Trigger.isUpdate,oldProjectlMap, newProjectMap);
        }
    }
    
	public void requestAutonumber(Boolean isBefore, Boolean isUpdate, Map<Id, Project__c> oldMap, Map<Id, Project__c> newMap){
		if(isBefore && isUpdate){
			List<Project__c> atiNumberProcList = new List<Project__c>(); 
			Map<String, List<Project__c>> prefixbillCodeProcListMap = new Map<String, List<Project__c>>(); 

			//	Create List of Records for Processing
			for(Id key : newMap.keySet()){
				Project__c oldProj = oldMap.get(key);
				Project__c newProj = newMap.get(key);

				//	ATI Number Checkbox Has Been Checked - Retrieve New ATI Number
				if(!oldProj.Request_ATI_No__c && newProj.Request_ATI_No__c){
					atiNumberProcList.add(newProj);					
				}

				//	Bill Code Checkbox Has Been Checked - Retrieve New Bill Code
				if(!oldProj.Request_Bill_Code__c && newProj.Request_Bill_Code__c){
					String prefix = newProj.Bill_Code_Prefix__c;
					if(prefix != null){
						if(!prefixbillCodeProcListMap.containsKey(prefix)){
							prefixbillCodeProcListMap.put(prefix, new List<Project__c>());
						}
						prefixbillCodeProcListMap.get(prefix).add(newProj);			
					}
				}

			}

			//	Send to AutoNumber Algo
			AutoNumber.ProcessATINumberRequests(atiNumberProcList);
			AutoNumber.ProcessBillCodeRequests(prefixbillCodeProcListMap);
		}
	}
}
public with sharing class TriggerCheck {
	
	private static TriggerCheck instance = null;
    private static Id currentUserId = null;
    public Map<String, Boolean> triggerStatus = null;

    private void load() {
        currentUserId = UserInfo.getUserId();
        String bypassApex = [SELECT
        							 ByPassTrigger__c  
        					 FROM  
        					 		User 
                            WHERE
                            		 Id = :UserInfo.getUserId() LIMIT 1].ByPassTrigger__c ;
                            		 
        triggerStatus = new Map<String, Boolean>();                
        if (byPassApex != null) 
        {
            List<String> triggerList = bypassApex.split(';'); 
            for (String triggerName : triggerList)
            {
                if (triggerName != null && triggerName != '')
                {
                    triggerStatus.put(triggerName, false);
                }
            }
        }
    }
                            
    public static TriggerCheck getInstance() {
        if (instance == null) { 
            instance = new TriggerCheck();
        }
        if (currentUserId != UserInfo.getUserId()) {
            instance.load();
        }
        return instance;
    }
    
    public static void deactivateTrigger(String name) {
        getInstance().triggerStatus.put(name, false);
    }

    public static void activateTrigger(String name) {
        getInstance().triggerStatus.put(name, true);
    }
   
    public static boolean canRun(String name) {
        if (getInstance().triggerStatus.containsKey(name)) 
        {
            return (getInstance().triggerStatus.get(name));
            
        }
        return true;
    }    
    
}
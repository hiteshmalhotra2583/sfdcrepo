@isTest
private  class TriggerCheck_T {
   
    @isTest
    private static void test() {
        
        Profile p = [select id from profile where name='Utilisateur Standard' OR name='Standard User' LIMIT 1]; 
        
        User u = new User(alias = 'standt', email='standarduser@testorg.com',emailencodingkey='UTF-8', 
                          lastname='Testing', languagelocalekey='en_US', localesidkey='en_US', 
                          profileid = p.Id, timezonesidkey='America/Los_Angeles', 
                          username='standarduser@seb.com', 
                          ByPassTrigger__c  ='TR01;TR02',
                          ByPassValidation__c  =true);
                          
          insert u;                
         
        System.runAs(u) {
            System.assert(TriggerCheck.canRun('TR01') == false);
            System.assert(TriggerCheck.canRun('TR03') == true);
            
            TriggerCheck.deactivateTrigger('TR03');
            System.assert(TriggerCheck.canRun('TR03') == false);
            
            TriggerCheck.activateTrigger('TR01');
            System.assert(TriggerCheck.canRun('TR01') == true);          
         }
    }
}
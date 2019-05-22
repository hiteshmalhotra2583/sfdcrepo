@isTest
private class CTRL_CustomSearchByNameComponent_T {
    
    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<String> lstStates = new List<String>{'AK','AL','AZ'};
    public static List<State__c> states = new List<State__c>();
    public static Account testAccount = new Account();
    static void testData()
    {
        
        admin_User = TestDataFactory.createUser(true,true,SYSTEM_ADMINISTRATOR_PROFILE);
        system.runAs(admin_User)
        {
            for(String state: lstStates)
            {
                states.add(new State__c(Name=state, StateCode__c=state));
            }
            insert states;
            Map<String,Object> mapAccountDetails = new Map<String,Object>();
            mapAccountDetails.put('Name','test account');
            mapAccountDetails.put('LID__LinkedIn_Company_Id__c','12');
            testAccount = (Account)TestDataFactory.operationOnObjectRecord(null, 'Account', mapAccountDetails);
            insert testAccount;
        }
    }
    private static testMethod void testGetStates()
    {
        CTRL_CustomSearchByNameComponent.getStates();
    }
    private static testMethod void testGetRecordsByName()
    {
        testData();
        List<Account> lstAccount = (List<Account>)CTRL_CustomSearchByNameComponent.getRecordsByName('Account','test account', 'createdById', null);
        System.assertEquals(1, lstAccount.size());
        List<Account> searchAgain = (List<Account>)CTRL_CustomSearchByNameComponent.getRecordsByName('Account','test account', null, lstAccount);
        System.assertEquals(0, searchAgain.size());
    }
}
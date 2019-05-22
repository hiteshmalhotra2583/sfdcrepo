@isTest
private class DAL_FilingStrategy_T {

    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Filing_Strategy__c> filingStrategys = new List<Filing_Strategy__c>();
    
    static void testData()
    {
    
        admin_User = TestDataFactory.createUser(true,'',SYSTEM_ADMINISTRATOR_PROFILE);
        
        insert admin_User;
        System.runAs(admin_User)
        {
            for(Integer i = 0 ; i <count; i++)
            {
                filingStrategys.add((Filing_Strategy__c) TestDataFactory.operationOnObjectRecord(null, 'Filing_Strategy__c', null));
            }
            insert filingStrategys; 
        } 
    
    }
    
    static testMethod void getByIdsMapTest() {
     
     testData();
     Test.startTest();
     DAL_FilingStrategy.getALL();
     DAL_FilingStrategy.getIULFillingStrategyRecords();
     DAL_FilingStrategy.getMYGAFillingStrategyRecords();
     DAL_FilingStrategy.getFIAFillingStrategyRecords();
     Test.stopTest();
        
    }
}
@isTest
private class TestDataFactory_T {
	
	 public static User admin_User;
	 public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
	 
     public static Integer count =1;
    static testMethod void testDataFactoryMethod()
    {
    	Test.startTest();
        admin_User = TestDataFactory.createUser(true, true, '');
        
	    TestDataFactory.generateRandomString(count);
	    TestDataFactory.generaterandomInteger(10);
	    TestDataFactory.generateRandomEmail();
	    TestDataFactory.getRandomBoolean();
        Test.stopTest();
    }
}
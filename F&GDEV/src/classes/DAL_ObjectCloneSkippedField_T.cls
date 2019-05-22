@isTest
private class DAL_ObjectCloneSkippedField_T {
    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static Object_clone_skipped_field__mdt objectCloneSkippedFields = new Object_clone_skipped_field__mdt();
    
    static void testData()
    {
         admin_User = TestDataFactory.createUser(true,'',SYSTEM_ADMINISTRATOR_PROFILE);
        
        insert admin_User;
        System.runAs(admin_User)
        {

            objectCloneSkippedFields= (Object_clone_skipped_field__mdt) TestDataFactory.operationOnObjectRecord(null, 'Object_clone_skipped_field__mdt', null);
            objectCloneSkippedFields.put('Parent_Object_Name__c','Product_Specification__c');
            objectCloneSkippedFields.put('Object_Name__c','State_Availability__c');
            objectCloneSkippedFields.put('Field_Name__c','Name');
            
        } 
    }
	private static testMethod void testGetChildSkipListByParentName() {
        testData();
        
        Test.startTest();
        Map<String,Set<String>> mapObjectClone = DAL_ObjectCloneSkippedField.getChildSkipListByParentName('Product_Specification__c');
        System.assert(mapObjectClone!=null);
        Test.stopTest();
	}

}
public class CTRL_CustomSearchByNameComponent {
	
	@auraEnabled
    public static List<Sobject> getRecordsByName(String objName, String searchString, String morefields, List<Sobject> selectedRecords) {
        System.debug('--selectedRecords--'+ selectedRecords);
        return DAL_SearchSobjectByName.getSobjectRecordsByName(objName, searchString, morefields, selectedRecords);
    }
    
    @AuraEnabled
    public static List<State__c> getStates(){
        return State__c.getAll().values();
    }
}
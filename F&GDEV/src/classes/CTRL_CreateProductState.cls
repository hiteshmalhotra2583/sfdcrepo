public class CTRL_CreateProductState {
	
	@testVisible private static final string DELETED_SUCCESSFULLY = 'Deleted Successfully';
	@testVisible private static final string NO_RECORD_FOUND = 'No Related Records Found!!!';
	@testVisible private static final string NO_RECORD_FOUND_TODELETE = 'No Related Records Found To Delete!!!';
	@testVisible private static final string CHILD_RECORDEXIST = 'The child records exist. Due to which the deletion is not possible';
	
	@AuraEnabled
	public static String deleteProductStateRecords(String parentId)
	{
		List<State_Availability__c> stateAvailablitys = DAL_StateAvailability.getByTranxcationId(parentId);
		List<Id> stateAvailabiltyIds  = new List<Id>();
		for(State_Availability__c sA: stateAvailablitys)
		{
			stateAvailabiltyIds.add(sA.Id);
		}
		
		Map<Id,Product_State_Status__c> stateAvailabiltyIdKeyMap = 
		DAL_ProductStatePolicyFormAssociation.getByProductStateAvailabilityIdsMap(stateAvailabiltyIds);
       
        if(stateAvailablitys.isEmpty())
		{
			return NO_RECORD_FOUND_TODELETE;
		}
        
        if(stateAvailabiltyIdKeyMap.values().isEmpty())
		{
			delete stateAvailablitys;
			return DELETED_SUCCESSFULLY;
		}
		else
		{
			return CHILD_RECORDEXIST;
		}
	}

}
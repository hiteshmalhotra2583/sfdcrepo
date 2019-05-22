public class CTRL_DeletePolicyFormStates {
    //Method to fetch the policystates which can be deleted
    Private static final string SUCCESS_MESSAGE = 'Delete Successful';
    Private static final string ERROR_MESSAGE = 'Error Occured!!';
    @Auraenabled
    public static List<Filing_Status__c> getDeleteablePolicyStates(String parentRecordId) {
        //List<PolicyFormStateWrapper> lstPolicyStateWrapper;
        //fetch all policy form states
        Map<Id,List<Filing_Status__c>> mapPolicyFormStatesWithParentID = DAL_FilingStatus.getByParentIdMap(new List<Id>{parentRecordId});
        //convert the list of Filing status to id map
        Map<Id,Filing_Status__c> mapPolicyFormStates = new Map<Id,Filing_Status__c>(mapPolicyFormStatesWithParentID.get(parentRecordId));
                                    
        if(mapPolicyFormStates!=null && !mapPolicyFormStates.isEmpty()) {
            //fetch the list of Filing_Status__c records which has association with junction object
            Map<Id,Product_State_Status__c> mapProductStateStatus = new Map<Id,Product_State_Status__c>();
            mapProductStateStatus = DAL_ProductStatePolicyFormAssociation.getByfillingStatusMap(new List<Id>(mapProductStateStatus.keySet()));
            //remove the products which has association
            mapPolicyFormStates.keySet().removeAll(mapProductStateStatus.keySet());
        }
        List<Filing_Status__c> returnVal = mapPolicyFormStates.values();
        returnVal.sort();
        return returnVal;

    }
    @Auraenabled
    public static String deleteSelectedStateRecord(List<Filing_Status__c> selectedStates){
        String message=SUCCESS_MESSAGE;
        Savepoint sp = Database.setSavepoint();
        try {
            
            if(selectedStates!=null && !selectedStates.isEmpty()) {
                delete selectedStates;
            }
        } catch(Exception ex) {
            Database.rollback(sp);
            message = ERROR_MESSAGE + ex.getMessage();
            return message;
        }
        
        return message;
    }
}
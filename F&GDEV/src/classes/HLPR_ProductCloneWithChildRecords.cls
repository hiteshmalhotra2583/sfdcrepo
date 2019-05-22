//Controller class to clone product and it's child records
public class HLPR_ProductCloneWithChildRecords {
   
    //private static final String SUCCESS_MESSAGE = 'Clone is Successful you will be redirected to new Record';
    private static final String ERROR_MESSAGE = 'Error Occurred!!';
    public Id recordId {get;set;}
    public String parentObjName {get;set;}
    public List<ChildObjectWrapper> childObjWrapperList {get;set;}
    private final Set<String> setSTRChildObjectsToBeConverted = new Set<String>{'State_Availability__c', 
    																			'PlanCode__c',
    																			'Marketing_Materials__c',
    																			'Product_State_Status__c',
    																			'Product_to_Plan_Code_Association__c',
    																			'Marketing_to_Product_State_Association__c'};
        
    //constructor
    public HLPR_ProductCloneWithChildRecords(String recordId) {
        this.recordID = recordId;
        childObjWrapperList = new List<ChildObjectWrapper>();
        parentObjName = UtilityClass.getObjectNameFromId(recordId);
        List<Schema.ChildRelationship> childObjList = UtilityClass.getChildRelationshipsFromId(recordId);
        for(Schema.ChildRelationship child : childObjList) {
            String childObjectName = (String)child.getChildSObject().getDescribe().getName();
            if(child.getChildSObject().getDescribe().isQueryable() && setSTRChildObjectsToBeConverted.contains(child.getChildSObject().getDescribe().getName())){
                String fieldName = String.valueOf(child.getField());
                if(child.getField().getDescribe().isCreateable()) {
                    childObjWrapperList.add(new ChildObjectWrapper(child.getChildSObject().getDescribe().getName(),true,recordId,String.valueOf(child.getField())));
                }
            }
        }
    }
    
    
    public String cloneWithChildren(String parentObjectNewName) {
        SavePoint sp = Database.setSavepoint();
        String message = '';
        try {
            //get skipped fields list for the parentobject
            Map<String,Set<String>> mapChildObjSkipList  = new Map<String,Set<String>>();
            mapChildObjSkipList = DAL_ObjectCloneSkippedField.getChildSkipListByParentName(parentObjName);
            // Clone parent object record first
            List<Sobject> clonedParentObj = UtilityClass.cloneObject(parentObjName,recordId,true,null,null,mapChildObjSkipList);
            clonedParentObj[0].put('Name',parentObjectNewName);
            BaseTriggerHandler.bypass('PRODUCTSPECIFICATIONHANDLER');
            insert clonedParentObj;
            BaseTriggerHandler.clearBypass('PRODUCTSPECIFICATIONHANDLER');
            // Clone child records
            
            List<sobject> childObjList = new List<sobject>();
            if(childObjWrapperList.size() > 0) {
                for(ChildObjectWrapper obj : childObjWrapperList) {
                    List<Sobject> clonedChildObj = UtilityClass.cloneObject(obj.objName,obj.recordId,false,obj.relationshipName,clonedParentObj.get(0).Id,mapChildObjSkipList);
                    if(clonedChildObj.size() > 0){
                        childObjList.addAll(clonedChildObj);
                    }
                }
            }
            Database.SaveResult[] lstSaveResult = Database.insert(childObjList,true);
            // Iterate through each returned result
			for (Database.SaveResult sr : lstSaveResult) {
			    if (sr.isSuccess()) {
			        // Operation was successful, so get the ID of the record that was processed
			        System.debug('Successfully inserted record ID: ' + sr.getId());
			    }
			    else {
			        // Operation failed, so get all errors                
			        for(Database.Error err : sr.getErrors()) {
			            System.debug('The following error has occurred.');                    
			            System.debug(err.getStatusCode() + ': ' + err.getMessage());
			            System.debug('fields that affected this error: ' + err.getFields());
			        }
			    }
			}    
            message = String.valueOf(clonedParentObj[0].get('Id'));
            cloneProductStateStatuses(message);
            
            // call the future method only after the code control reaches here and delete records
            cloneAttachmentsToFiles(String.valueOf(recordId), String.valueOf(clonedParentObj[0].Id));
            
        } catch(Exception ex) {
            Database.rollback(sp);
            message = ERROR_MESSAGE+ ex.getMessage();
        }
        return message;
    }
   
   
   
    @future
    private static void cloneAttachmentsToFiles(String oldProductFormId, String newProductFormId)
    {
        reparentFiles(oldProductFormId,newProductFormId);
        List<Attachment> lstPolicyFormAttachments = DAL_Attachment.getAttachmentsByParentIds(new List<Id>{oldProductFormId});
        List<ContentVersion> lstContentVersion = new List<ContentVersion>();
        List<ContentDocumentLink> lstContentDocument = new List<ContentDocumentLink>();
        Set<Id> setAttachmentsToDelete = new Set<Id>();
        System.debug('--Attachment--' + lstPolicyFormAttachments.size());
        if(lstPolicyFormAttachments!=null && !lstPolicyFormAttachments.isEmpty())
        {
            for(Attachment attach : lstPolicyFormAttachments)
            {
                //Insert ContentVersion
                ContentVersion cVersion = new ContentVersion();
                cVersion.ContentLocation = 'S'; //S-Document is in Salesforce. E-Document is outside of Salesforce. L-Document is on a Social Netork.
                cVersion.PathOnClient = attach.Name;//File name with extention
                cVersion.Origin = 'H';//C-Content Origin. H-Chatter Origin.
                cVersion.OwnerId = attach.OwnerId;//Owner of the file
                cVersion.Title = attach.Name;//Name of the file
                cVersion.VersionData = attach.Body;//File content
                lstContentVersion.add(cVersion);
                setAttachmentsToDelete.add(attach.Id);
            }

            insert lstContentVersion;
           
            //query ContentDocumentId for each lstContentVersion
            List<ContentVersion> lstContentVersionForDocId = new List<ContentVersion>();
            lstContentVersionForDocId = [Select ContentDocumentId FROM ContentVersion where ID IN:lstContentVersion];
            for(ContentVersion cVersion : lstContentVersionForDocId)
            {
                ContentDocumentLink cDocLink = new ContentDocumentLink();
                cDocLink.ContentDocumentId = cVersion.ContentDocumentId;//Add ContentDocumentId
                cDocLink.LinkedEntityId = newProductFormId;//Add LinkedEntityId with the newly created 
                cDocLink.ShareType = 'I';//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                cDocLink.Visibility = 'AllUsers';//AllUsers, InternalUsers, SharedUsers
                lstContentDocument.add(cDocLink);
            }
            insert lstContentDocument;
            if(setAttachmentsToDelete!=null && !setAttachmentsToDelete.isEmpty())
            {
                deleteRecords(setAttachmentsToDelete);    
            }
            
        }
        deleteRecords(new Set<Id>{Id.valueOf(oldProductFormId)});
    }
   
   
    private static void deleteRecords(Set<Id> setRecordsToDelete) 
    {
        List<sObject> lstObjToDelete = new List<sObject>();
        if(setRecordsToDelete!=null && !setRecordsToDelete.isEmpty()) 
        {
            for(Id objId : setRecordsToDelete) 
            {
                String ObjectName = UtilityClass.getObjectNameFromId(objId);
                sObject sObj = Schema.getGlobalDescribe().get(ObjectName).newSObject() ;
                sobj.put('Id',objId);
                lstObjToDelete.add(sobj);
            }
        }
        if(lstObjToDelete!=null && !lstObjToDelete.isEmpty())
        {
            delete lstObjToDelete;
        }
    }
    
    private static void reparentFiles(String oldPolicyFormStateId, String newPolicyFormStateId)
    {
        List<ContentDocumentLink> lstContentDocumentLink = 
        DAL_ContentDocumentLink.getContentDocumentLinkByParentID(new List<Id> {Id.valueOf(oldPolicyFormStateId)});
        List<ContentDocumentLink> lstContentDocumentToInsert  = new List<ContentDocumentLink>();
        for(ContentDocumentLink link : lstContentDocumentLink)
        {
            ContentDocumentLink newLink = new ContentDocumentLink();
            newLink.LinkedEntityId = newPolicyFormStateId;
            newLink.ContentDocumentId = link.ContentDocumentId;
            newLink.ShareType= 'I';
            lstContentDocumentToInsert.add(newLink);
        }
        insert lstContentDocumentToInsert;
    }
   
    private void cloneProductStateStatuses(String message)
    {
        //Get newly created records and existing ones
        List<State_Availability__c> lstProductStates = DAL_ProductState.getProductStatesWithChild(new Set<String>{message,recordId});
        Map<String,State_Availability__c> mapProductStatesOriginal = new Map<String,State_Availability__c>();
        Map<String,State_Availability__c> mapProductStatesCloned = new Map<String,State_Availability__c>();
        if(lstProductStates!=null && !lstProductStates.isEmpty()) {
            for(State_Availability__c prodState : lstProductStates) {
                //cloned map
                if(prodState.Product_Specification__c==message) {
                    mapProductStatesCloned.put(prodState.State__c,prodState);
                }
                if(prodState.Product_Specification__c==recordId) {
                    mapProductStatesOriginal.put(prodState.State__c,prodState);
                }

            }
            
            //loop through the original map and add values from cloned map
            List<Product_State_Status__c> lstProductStateStatusToInsert = new List<Product_State_Status__c>();
            for(State_Availability__c prodStateCloned: mapProductStatesCloned.values()) {
                State_Availability__c prodStateOriginal = mapProductStatesOriginal.get(prodStateCloned.State__c);
                for(Product_State_Status__c prodStateStatusOrginal : prodStateOriginal.Product_State_Statuses__r) {
                    Product_State_Status__c prodStateStatusCloning = new Product_State_Status__c();
                    prodStateStatusCloning.Filing_Status__c = prodStateStatusOrginal.Filing_Status__c;
                    prodStateStatusCloning.Policy_Form_Status__c = prodStateStatusOrginal.Policy_Form_Status__c;
                    prodStateStatusCloning.Product_State_Availability__c = prodStateCloned.Id;
                    lstProductStateStatusToInsert.add(prodStateStatusCloning);
                }
            }
            
        try{
            BaseTriggerHandler.bypass('PRODUCTSPECIFICATIONHANDLER');
            Database.SaveResult[] srList = Database.insert(lstProductStateStatusToInsert,true);
            BaseTriggerHandler.clearBypass('PRODUCTSPECIFICATIONHANDLER');
            // Iterate through each returned result
			for (Database.SaveResult sr : srList) {
			    if (sr.isSuccess()) {
			        // Operation was successful, so get the ID of the record that was processed
			        System.debug('Successfully inserted record ID: ' + sr.getId());
			    }
			    else {
			        // Operation failed, so get all errors                
			        for(Database.Error err : sr.getErrors()) {
			            System.debug('The following error has occurred.');                    
			            System.debug(err.getStatusCode() + ': ' + err.getMessage());
			            System.debug('fields that affected this error: ' + err.getFields());
			        }
			    }
            //insert lstProductStateStatusToInsert;
          }
         } catch(Exception ex) {
          System.debug('Error occured ' + ex.getMessage());
        }
      }
    } 
    
    
    public class ChildObjectWrapper {
        
        public String objName {get;set;}
        public Boolean isSelected {get;set;}   
        public String recordId {get;set;}	
        public String relationshipName {get;set;}
        
        
        ChildObjectWrapper(String objName,Boolean isSelected, String recordId, String relationshipName){
            this.objName = objName;
            this.isSelected = isSelected;
            this.recordId = recordId;
            this.relationshipName = relationshipName;
        }
        
    }
}
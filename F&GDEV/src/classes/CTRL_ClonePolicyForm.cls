public class CTRL_ClonePolicyForm {
    public static final String ERROR_MESSAGE = 'Error Occurred! there was an error occurred while cloning the object';
    @auraenabled
    public static List<Filing_Status__c> getPolicyFormStates(String policyFormId) 
    {
        return DAL_FilingStatus.getByParentIds(new List<Id> {policyFormId});
    }
    @auraenabled
    public static Policy_Form_Detail__c getPolicyForm(String policyFormId)
    {
        return DAL_PolicyFormDetail.getByIds(new List<Id>{Id.valueOf(policyFormId)})[0];
    }
    @auraenabled
    public static String clonePolicyFormWithChild(String recordId, String newPolicyFormName, String policyFormStateId)
    {
        Policy_Form_Detail__c clonedPolicyForm ;
        Filing_Status__c clonedFilingStatus;
        String message;
        Savepoint sp = Database.setSavepoint();
        try 
        {
            //clone parent object record first
            clonedPolicyForm = (Policy_Form_Detail__c) cloneObject(recordID)[0];
            clonedPolicyForm.put('Name',newPolicyFormName);
            insert clonedPolicyForm;

            //clone associated child object which is selected
            clonedFilingStatus = (Filing_Status__c) cloneObject(policyFormStateId)[0];
            clonedFilingStatus.put('Policy_Form__c', clonedPolicyForm.Id);
            insert clonedFilingStatus;
            
            //reparent the policy form association record
            List<Product_State_Status__c> lstPolicyStateStatus = new List<Product_State_Status__c>();
            lstPolicyStateStatus = DAL_ProductStatePolicyFormAssociation.getByFilingStatusIds(new List<Id>{Id.valueOf(policyFormStateId)});
            if(lstPolicyStateStatus!=null && !lstPolicyStateStatus.isEmpty())
            {
                lstPolicyStateStatus[0].Filing_Status__c = clonedFilingStatus.Id;
                update lstPolicyStateStatus;
            }
            message = clonedPolicyForm.Id;
            
        } catch(Exception ex) 
        {
            Database.Rollback(sp);
            message = ERROR_MESSAGE + ex.getMessage();
            return message;
        }
        // call the future method only after the code control reaches here and delete records
        cloneAttachmentsToFiles(policyFormStateId, clonedFilingStatus.Id, recordId);
        return message;
        
    }
    
    @future
    private static void cloneAttachmentsToFiles(String oldPolicyFormStateId, String newPolicyFormStateId, String recordId)
    {
        reparentFiles(oldPolicyFormStateId,newPolicyFormStateId,recordId);
        List<Attachment> lstPolicyFormAttachments = DAL_Attachment.getAttachmentsByParentIds(new List<Id>{oldPolicyFormStateId});
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
                cDocLink.LinkedEntityId = newPolicyFormStateId;//Add LinkedEntityId with the newly created 
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
        deleteRecords(new Set<Id>{Id.valueOf(oldPolicyFormStateId)});
    }
    
    private static List<Sobject> cloneObject(String recordId) 
    {
        String objectName = UtilityClass.getObjectNameFromId(recordId);
        Map<String,Set<String>> mapChildObjSkipList  = new Map<String,Set<String>>();
        mapChildObjSkipList = DAL_ObjectCloneSkippedField.getChildSkipListByParentName(objectName);
        return UtilityClass.cloneObject(objectName,recordId,true,null,null,mapChildObjSkipList);  
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
    
    private static void reparentFiles(String oldPolicyFormStateId, String newPolicyFormStateId, String recordId)
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
}
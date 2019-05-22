public class DAL_ContentDocumentLink {
    public static List<ContentDocumentLink> getContentDocumentLinkByParentID(List<Id> contentParentIds)
    {
        return [Select Id,
                        ContentDocumentId,
                        LinkedEntityId
                   FROM 
                   		ContentDocumentLink
                   WHERE 
                        LinkedEntityId IN: contentParentIds];    
    }
}
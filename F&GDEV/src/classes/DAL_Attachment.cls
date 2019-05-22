public class DAL_Attachment {
    
    public static List<Attachment> getAttachmentsByParentIds(List<Id> parentIds)
    {
        return [SELECT 
                        Id, 
                        Name, 
                        Body, 
                        ContentType, 
                        ParentId,
                        OwnerId 
                   FROM 
                        Attachment 
                   WHERE 
                        ParentId IN:parentIds];
    }

}
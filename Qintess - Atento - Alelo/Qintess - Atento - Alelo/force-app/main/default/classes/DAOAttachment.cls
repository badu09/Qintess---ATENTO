public with sharing class DAOAttachment {
	public static List<Attachment> getAttachmentById(List<Id> listId) {
        List<Attachment> listAttachment = [SELECT
	        									Id,
	        									Name,
	        									ContentType,
	        									BodyLength,
	        									Body,
	        									Description,
	        									IsPrivate
	        								FROM
	        									Attachment
	        								WHERE
	        									Id IN: listId
	        								ORDER BY Name];
                                         
        return listAttachment;
    }
    
    public static List<Attachment> getAttachmentByParentId(Id parentId) {
        List<Attachment> listAttachment = [SELECT
	        									Id,
	        									Name,
	        									ContentType,
	        									BodyLength,
	        									Body,
	        									Description,
	        									IsPrivate
	        								FROM
	        									Attachment
	        								WHERE
	        									ParentId =: parentId
	        								AND
	        									BodyLength < 3000000
	        								ORDER BY Name];
                                         
        return listAttachment;
    }
}
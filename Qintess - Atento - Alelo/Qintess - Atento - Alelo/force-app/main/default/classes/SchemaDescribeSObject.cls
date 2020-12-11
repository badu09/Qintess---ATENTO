public class SchemaDescribeSObject 
{
	private static final SchemaDescribeSObject instance = new SchemaDescribeSObject();
    
    private SchemaDescribeSObject(){}
    
    public static SchemaDescribeSObject getInstance()
    {
        return instance;
    }
    
    public Set<String> getAllFieldsObject(String objectName)
    {   
        Schema.SObjectType describeSObject = Schema.getGlobalDescribe().get(objectName);
        
        Set<String> fields = describeSObject.getDescribe().fields.getMap().keySet();
        
        return fields;
    }
        
}
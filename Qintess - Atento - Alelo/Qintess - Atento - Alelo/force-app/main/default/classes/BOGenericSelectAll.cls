public with sharing class BOGenericSelectAll {
	private static final String QUERY_SELECT = 'SELECT ';
    private static final String QUERY_FROM = ' FROM ';
    private static final String QUERY_WHERE = ' WHERE ';
    public static String QUERY_FILTER = null;
    public static String QUERY_ORDER = null;
    public static String QUERY_LIMIT = null;
    private static transient List<Schema.DescribeFieldResult> fields {get;set;}
	
	public static List<SObject> getObjectSearch(String apiName)
    { 
    	Schema.DescribeSObjectResult objDescribe = getDescribeFieldResult(apiName);
    	
    	getObjectFields(objDescribe);
    	
    	String getAllQuery = buildQuerySearch(fields, objDescribe);
    	
    	system.debug('Query criada: ' + getAllQuery);
    	
    	return Database.query(getAllQuery);
    }
    
    private static Schema.DescribeSObjectResult getDescribeFieldResult(String apiName)
    {
     	Schema.DescribeSObjectResult objDescribe; 
        
        Schema.SObjectType objType = BOSchemaManager.getObjectSchema(apiName);
				
		if(objType != null) 
		{
			objDescribe = objType.getDescribe();
		}
				
		return objDescribe;	
	}
    
    private static void getObjectFields(Schema.DescribeSObjectResult objDescribe)
    {
    	fields = new List<Schema.DescribeFieldResult>();
    	
        Map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
     	     	
     	for(Schema.SObjectField sof : fieldMap.values())
     	{
     		fields.add(sof.getDescribe());
     	}	
    }
    
    private static String buildQuerySearch(List<Schema.DescribeFieldResult> queryFields, DescribeSObjectResult obj)
    {
        String query = QUERY_SELECT;
        
        for(Schema.DescribeFieldResult dfr : queryFields)
        {
        	query += dfr.getName() + ',';        	
        }
        
        query = query.subString(0,query.length() - 1);
        query += QUERY_FROM;
        query += obj.getName();
        
        if(QUERY_FILTER <> null) 
        {      
    		query += QUERY_WHERE;
    		query += QUERY_FILTER.replace('{', '').replace('}', '');
        }

        if(QUERY_ORDER <> null) 
        {  
        	query += ' ORDER BY ';
        	query += QUERY_ORDER;
        }
        
        if(QUERY_LIMIT <> null) 
        {  
        	query += ' LIMIT ';
        	query += QUERY_LIMIT;
        }
        
        system.debug('Build Query Search == ' + query); 
        
        return query;
    }
}
public with sharing class BOSchemaManager {
	private static Map<String, Schema.SObjectType> sobjectSchemaMap;
     
	public static Map<String,Schema.SObjectType> getSchemaMap()
	 {
	     if(sobjectSchemaMap == null)
	     {
	         sobjectSchemaMap = Schema.getGlobalDescribe();
	     }
	     return sobjectSchemaMap;
	 }
	 
     //Retrieve the specific Schema.SobjectType for a object so we can inspect it
     public static Schema.SObjectType getObjectSchema(String objectAPIName)
     {
         getSchemaMap();
         Schema.SObjectType aSObjectType = sobjectSchemaMap.get(objectAPIName);
         return aSobjectType;
     }
}
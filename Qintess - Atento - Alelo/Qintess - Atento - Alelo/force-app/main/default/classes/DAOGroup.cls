public class DAOGroup {
    public static List<Group> getGroup() {
        List<Group> lGroup;
        lGroup = [SELECT Id, Name FROM Group WHERE Type = 'Queue'];
        return lGroup;
    }
    
    public static Group getDeveloperNameGroup(String devName,String typeQueue){
        
        try{
            String query = 'SELECT Id, Name, DeveloperName, Type FROM Group where Type ='+'\''+typeQueue+'\'';
            query+=' and DeveloperName LIKE '+ '\''+devName+'%\''+'ORDER BY Name DESC LIMIT 1';
            System.debug('query' + query);
            Group groupNames = new Group();
            
            groupNames = Database.query(query);
            
            return groupNames;
        }catch (Exception e){
            return null;
        }
        
    }
    
    public static List<Group> getGroupBySet(Set<Id> setIds){
        
        List<Group> lstGroup = new List<Group>();
        
        try{
            lstGroup = [SELECT Id, Name, DeveloperName, Type FROM Group 
                        WHERE Type = 'Queue'
                        AND Id IN :setIds];
            
            return lstGroup;
            
        }catch (Exception e){
            return null;
        }
        
    }
    
    public static Group insereGroup(Group objGroup){
        
        try{
            
            insert objGroup;
            
        }catch(Exception e){
            
            return null;
            
        }
        return objGroup;
    }
    
}
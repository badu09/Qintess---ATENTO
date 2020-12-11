public class DAOProfile {

    public static Profile getProfileByName(String name) {
        return [SELECT Id FROM Profile WHERE Name = :name];        
    }

    public static List<Profile> getProfileByContainsName(String name) {
        return [SELECT Id FROM Profile WHERE Name LIKE :'%' + name + '%'];
    }
    
    public static Profile getProfileById(String id) {
        return [SELECT Id, Name FROM Profile WHERE Id = :id];        
    }
}
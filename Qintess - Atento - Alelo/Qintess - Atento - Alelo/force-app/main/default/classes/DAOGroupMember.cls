public with sharing class DAOGroupMember {
    
    private static final DAOGroupMember instance = new DAOGroupMember();
    
    public static DAOGroupMember getInstance()  {
        return instance;
    }
    
    
    public DAOGroupMember() {
        
    }
    
    public List<GroupMember> insereGroupMember(List<GroupMember> listGroupMemberObj){
        
        try{
            
            insert listGroupMemberObj;
            
        }catch (Exception e ){
            return null;
        }
        
        return listGroupMemberObj;
    }
}
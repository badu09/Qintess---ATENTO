public class AuxiliarUpdateEstrategiaImplantacao {
    
    public AuxiliarUpdateEstrategiaImplantacao(){
        
    }
    
    @future
    public static void updateEstrategiaImplant(String estrategiaImpl){
        Estrategia_Implantacao__c estrategiaObj= (Estrategia_Implantacao__c) JSON.deserialize(estrategiaImpl, Estrategia_Implantacao__c.class);
        
            upsert estrategiaObj;
            System.debug('update = ' + estrategiaObj); 
        
    }
    
}
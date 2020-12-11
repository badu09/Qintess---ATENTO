public with sharing class DAOEstrategiaImplantacao {
    
    
    private static final DAOEstrategiaImplantacao instance = new DAOEstrategiaImplantacao();
    
    public static DAOEstrategiaImplantacao getInstance()  {
        return instance;
    }
    
    public DAOEstrategiaImplantacao() {
        
    }
    
    
    public Estrategia_Implantacao__c getEstrategiaImplantacaoById(String idEstrategia) {
        return [SELECT Data_Fim_Vigencia__c,Data_Inicio_Vigencia__c,Id,Fila_Nova__c,Fila_Contatado__c,
                Quantidade_Maxima_Tentativas__c,Implantacao_Fidelizada__c,Fila_Agendado__c,
                Id_Relatorio_Estrategia__c,Nome_Relatorio_Estrategia__c,Ativado__c
                FROM Estrategia_Implantacao__c WHERE Id = :idEstrategia];
    }
    
    public List<Estrategia_Implantacao__c> getAllEstrategiaImplantacao(){
        List<Estrategia_Implantacao__c> allEstrategias = [SELECT Data_Fim_Vigencia__c,Data_Inicio_Vigencia__c,Id,Fila_Nova__c,Fila_Contatado__c,
                                                          Quantidade_Maxima_Tentativas__c,Implantacao_Fidelizada__c,Fila_Agendado__c,
                                                          Id_Relatorio_Estrategia__c,Nome_Relatorio_Estrategia__c,Ativado__c
                                                          FROM Estrategia_Implantacao__c];
        return allEstrategias;
        
    }
    
    public List<Estrategia_Implantacao__c> getEstrategiaImplantacaoBySet(Set<Id> setIds){
        List<Estrategia_Implantacao__c> allEstrategias = [SELECT Data_Fim_Vigencia__c,Data_Inicio_Vigencia__c,Id,Fila_Nova__c,Fila_Contatado__c,
                                                          Quantidade_Maxima_Tentativas__c,Implantacao_Fidelizada__c,Fila_Agendado__c,
                                                          Id_Relatorio_Estrategia__c,Nome_Relatorio_Estrategia__c,Ativado__c
                                                          FROM Estrategia_Implantacao__c
                                                          WHERE Id IN :setIds];
        return allEstrategias;
        
    }
    
    public  Estrategia_Implantacao__c updateEstrategiaImplantacao(Estrategia_Implantacao__c estrategiaImplantacao){
        
        try{
            upsert estrategiaImplantacao;
        }catch(Exception e){
            System.debug('ERRO AO INSERIR IMPLANTAÇÃO ESTRATEGICA ' + e.getMessage());
            return null;
        }
        
        return estrategiaImplantacao;
        
    }
    
}
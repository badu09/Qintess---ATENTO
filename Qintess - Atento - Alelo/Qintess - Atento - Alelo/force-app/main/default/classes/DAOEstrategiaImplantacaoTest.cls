@isTest
private class DAOEstrategiaImplantacaoTest 
{

    static testMethod void getAllEstrategiaImplantacaoTest() 
    {
        
        Estrategia_Implantacao__c estrat = new Estrategia_Implantacao__c();
        estrat.Data_Fim_Vigencia__c = System.today().addDays(2);
        estrat.Data_Inicio_Vigencia__c = System.today().addDays(1);
        estrat.Implantacao_Fidelizada__c = 'Vigente Com Fidelização';
        estrat.Id_Relatorio_Estrategia__c = '123';
        estrat.Quantidade_Maxima_Tentativas__c = 1;
        insert estrat;

        DAOEstrategiaImplantacao.getInstance().getAllEstrategiaImplantacao();

    }
    
    static testMethod void getEstrategiaImplantacaoBySetTest() 
    {
        
        Estrategia_Implantacao__c estrat = new Estrategia_Implantacao__c();
        estrat.Data_Fim_Vigencia__c = System.today().addDays(2);
        estrat.Data_Inicio_Vigencia__c = System.today().addDays(1);
        estrat.Implantacao_Fidelizada__c = 'Vigente Com Fidelização';
        estrat.Id_Relatorio_Estrategia__c = '123';
        estrat.Quantidade_Maxima_Tentativas__c = 1;
        insert estrat;

        Set<Id> setIds = new Set<Id>();
        setIds.add(estrat.Id);
            
        DAOEstrategiaImplantacao.getInstance().getEstrategiaImplantacaoBySet(setIds);

    }
    
}
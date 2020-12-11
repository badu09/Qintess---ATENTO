@isTest
private class CtrlCobrancaTeste {
    
    static CtrlCobranca controller;
    
    static testMethod void Test_Method01(){
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName ='Teste';
        opp.CloseDate = date.valueOf(system.now());
        insert opp;
        
        Produtos_Alelo__c produto = new Produtos_Alelo__c();
        produto.Oportunidade__c = opp.id;
        insert produto;
        
        Cobranca__c cobranca = new Cobranca__c();
        cobranca.Produtos_Alelo__c = produto.id;
        cobranca.Oportunidade__c = opp.id;
        cobranca.Status__c = 'Cobranca';
        cobranca.Data_Hora_Tabulacao__c = date.valueOf(system.now());
        insert cobranca;
        
        List<Cobranca__c> lCobranca = new List<Cobranca__c>();
        lCobranca.add(cobranca);
        
        Test.startTest();
        ApexPages.StandardController controllerPage = new ApexPages.StandardController(opp);
        controller = new CtrlCobranca(controllerPage);

        controller.carregaProduto();
        controller.salvar();
        
        test.stopTest();
    }
}
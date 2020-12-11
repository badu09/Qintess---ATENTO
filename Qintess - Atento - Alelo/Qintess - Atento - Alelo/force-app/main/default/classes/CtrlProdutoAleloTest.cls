@isTest
private class CtrlProdutoAleloTest {

    static CtrlProdutoAlelo controller;
    
    @isTest static void test_method(){
       
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName ='Teste';
        opp.CloseDate = date.valueOf(system.now());
        insert opp;
        
        Produtos_Alelo__c produto = new Produtos_Alelo__c();
        produto.Oportunidade__c = opp.id;
        insert produto;
        
        List<Opportunity> lstOpp = new List<Opportunity>();
        lstOpp.add(opp);
        
        Test.startTest();
        ApexPages.StandardController controllerPage = new ApexPages.StandardController(opp);
		controller = new CtrlProdutoAlelo(controllerPage);
        
        controller.lOportunidade = lstOpp;
        
        controller.salvar();
        controller.alterarObservacao();
        //controller.limparTabulacao();
        
        
        test.stopTest();
    }
    
    static testmethod void test(){
        CtrlProdutoAlelo.testMaker();
    }
}
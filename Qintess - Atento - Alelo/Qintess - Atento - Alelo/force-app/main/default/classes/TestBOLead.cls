@isTest
private class TestBOLead {

    static testMethod void testConsultarIndicacaoBradesco() {
        Test.startTest();
    	Test.setMock(WebServiceMock.class, new WSIndicacoesMockImpl());
        BOLead.consultarIndicacaoBradesco();
        Test.stopTest();
    }

    static testMethod void testconsultarIndicacaoBB() {
        Test.startTest();
    	Test.setMock(WebServiceMock.class, new WSIndicacoesMockImpl());
        BOLead.consultarIndicacaoBB();
        Test.stopTest();
    }

    static testMethod void testconsultarIndicacaoSantander() {
        Test.startTest();
    	Test.setMock(WebServiceMock.class, new WSIndicacoesMockImpl());
        BOLead.consultarIndicacaoSantander();
        Test.stopTest();
    }
    
    // static testMethod void testConvertLead() {
    //     String leadsJson = '[{"Status":"SEM CONTATO (004)", "LastName":"AMBIENTEBRASIL","Company":"AMBIENTE BRASIL ENG TECN E DES SOL LIMP","Phone":"21 35252452","Telefone2__c":"21 35253452","Telefone3__c":"21 974046729","Telefone4__c":"21 32642166","Telefone5__c":"21 995718247","Nome_da_Campanha__c":"Banco do Brasil","CNPJ__c":"07812337000142","Name":"AMBIENTEBRASIL"}]';
    //   	List<Lead> leads = (List<Lead>)JSON.deserialize(leadsJson, List<Lead>.class);
    //   	insert leads;
    //     Test.startTest();
    //   	BOLead.convertLead(leads[0]);
    //     Test.stopTest();
    // }
}
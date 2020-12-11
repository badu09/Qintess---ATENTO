@isTest
private class TestBO {

	/*
    static testMethod void testBOLead() {
        Test.startTest();
        BOLead.consultarIndicacaoBradesco();
        BOLead.consultarIndicacaoBB();
        BOLead.consultarIndicacaoSantander();
        Test.stopTest();
    }*/
    
    static testMethod void testBOGenericSelectAll() {
        Test.startTest();
        BOGenericSelectAll.getObjectSearch('Produtos_Alelo__c'); 
        Test.stopTest();
    }
}
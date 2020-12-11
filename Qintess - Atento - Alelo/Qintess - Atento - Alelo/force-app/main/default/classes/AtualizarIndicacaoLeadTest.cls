@isTest
public class AtualizarIndicacaoLeadTest {

	static testmethod void testQueueable() {
        TestData.getLead();
        Integer codigoBanco = 1;
		List<Lead> listBanco = [SELECT Id, Name FROM Lead LIMIT 2];
        AtualizarIndicacaoLead atualizarJob = new AtualizarIndicacaoLead(codigoBanco, listBanco);
        Test.startTest();        
        System.enqueueJob(atualizarJob);
        Test.stopTest();        
    }
}
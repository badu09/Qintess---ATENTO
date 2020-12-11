@isTest
public class AtualizarIndicacaoOpportunityTest {

	static testmethod void testQueueable() {
        TestData.getOpportunity();
        Integer codigoBanco = 1;
		List<Opportunity> listBanco = [SELECT Id, Name FROM Opportunity LIMIT 2];
        AtualizarIndicacaoOpportunity atualizarJob = new AtualizarIndicacaoOpportunity(codigoBanco, listBanco);
        Test.startTest();        
        System.enqueueJob(atualizarJob);
        Test.stopTest();        
    }
}
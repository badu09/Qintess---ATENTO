@isTest
private class TestCtrlSegementacaoDistribuicao {

    static testMethod void testCtrlSegementacaoDistribuicao() {
        PageReference pageRef = new PageReference('/apex/SegementacaoDistribuicao');
        Test.setCurrentPage(pageRef);
      	Test.startTest();
      	
      	List<Mailing_Distribution__c> listMailingDistribution = TestData.getListMailingDistribution();
      	//List<Group> listGroup= TestData.getListGroup(); 
      	
      	CtrlSegmentacaoDistribuicao controller = new CtrlSegmentacaoDistribuicao();
      	
      	controller.save();
      	
        Test.stopTest();
    }
}
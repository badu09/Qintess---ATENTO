@isTest
private class TestTrigger {

    static testMethod void testTrigger() {
        Test.startTest();
        TestData.getListImplantacao();
        Test.stopTest();
    }

    static testMethod void testTriggerUpdateRelationID() {
        Test.startTest();
		Opportunity op = TestData.getOpportunity();
		EmailMessage email = new EmailMessage();
		email.Oportunidade__c = op.Id;
		insert email;
        Test.stopTest();
    }
}
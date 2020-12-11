@isTest
private class TestAccountStructure {

    static testMethod void testAccountStructure() {
     	Test.startTest();
     	
     	Account objAccount = TestData.getAccount();
     	
     	AccountStructure accountStructure = new AccountStructure();
     	accountStructure.setcurrentId(objAccount.Id);
     	
     	accountStructure.getObjectStructure();
     	
     	Test.stopTest();
    }
}
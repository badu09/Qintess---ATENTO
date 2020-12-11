@isTest
private class TestBOOlos {

    static testMethod void myUnitTest() {
        Test.startTest();
        Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
        Datetime dataInicio = Datetime.newInstance(2016, 10, 04, 0, 0, 0);
        Datetime dataFim = Datetime.newInstance(2016, 10, 04, 24, 59, 59);
        BOOlos.getCallData(dataInicio, dataFim);
        Test.stopTest();
    }
}
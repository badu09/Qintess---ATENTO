@isTest
private class TestConvertLead {

    static testMethod void myUnitTest() {
        Lead lead = new Lead();
        
        lead.Phone = '1146137928';
        lead.LastName = 'Santos';
        lead.Company = 'Ribeiros Bar';
        lead.CNPJ__C = '33469410000135';
        lead.Status1__c = 'CONTATO';
        lead.Status = 'NÃO TEM INTERESSE (002)';
        lead.Description = 'Wathever';
        
        insert lead;
        //lead.Status = 'AGENDAMENTO (001)';
        
        update lead;
        
        delete lead;
    }
}
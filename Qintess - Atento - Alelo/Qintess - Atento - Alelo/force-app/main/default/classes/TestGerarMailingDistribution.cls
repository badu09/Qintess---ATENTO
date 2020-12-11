@isTest
private class TestGerarMailingDistribution {

    static testMethod void gerarLead() {
        Lead lead = new Lead();
        lead.Nome_da_campanha__c = 'Campanha de Classe de Test';
        lead.Phone = '1139393939';
        // lead.Name = 'Lead da Classe de Test';
        lead.LastName = 'Test';
        lead.Company = 'Empresa da Classe de Test';
        lead.CNPJ__C = '46787578000130';
        lead.email = 'cloud@bsitecnologia.com.br';
        
        insert lead;
    }
}
@isTest(SeeAllData=true) 
private class SoftphoneSearchControllerTest {   
    
    private static testMethod void testDoSearch() {
       SoftphoneSearchController softphoneSearchController = new SoftphoneSearchController();       
       softphoneSearchController.contactName = 'Lauren';
       softphoneSearchController.doSearch();       
    }
    
    private static testMethod void testGetLeads() {
        String leadsJson = '[{"Status":"NOVO", "LastName":"AMBIENTEBRASIL","Company":"AMBIENTE BRASIL ENG TECN E DES SOL LIMP","Phone":"21 35252452","Telefone2__c":"21 35253452","Telefone3__c":"21 974046729","Telefone4__c":"21 32642166","Telefone5__c":"21 995718247","Nome_da_Campanha__c":"Banco do Brasil","CNPJ__c":"07812337000142","Name":"AMBIENTEBRASIL"}]';
      	List<Lead> leads = (List<Lead>)JSON.deserialize(leadsJson, List<Lead>.class);
      	insert leads;
        
        SoftphoneSearchController.getLeads(leads[0].Phone);
    }
}
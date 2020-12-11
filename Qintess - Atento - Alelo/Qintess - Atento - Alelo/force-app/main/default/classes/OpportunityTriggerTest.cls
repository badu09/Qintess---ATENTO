@isTest
public class OpportunityTriggerTest {
	@isTest static void updateOppotunity() {
		Test.startTest();
		Account newAccount = new Account(Name = 'Juliana', CPF_CNPJ__c = '63518800094');

		Database.insert(newAccount);
		Opportunity newOpportunity =
				New Opportunity(name = 'Nova oportunidade', StageName = 'A', AccountId = newAccount.Id,
						CloseDate = Date.today(), campanha__c = '123');

		Database.insert(newOpportunity);
		Produtos_Alelo__c newProdutoAlelo =
				new Produtos_Alelo__c(Valor_Implantado__c = 1.500, Oportunidade__c = newOpportunity.Id);



		Database.insert(newProdutoAlelo);

		newOpportunity.StageName = 'Implantação concluída';
		Database.update(newOpportunity);
		Test.stopTest();

	}


}
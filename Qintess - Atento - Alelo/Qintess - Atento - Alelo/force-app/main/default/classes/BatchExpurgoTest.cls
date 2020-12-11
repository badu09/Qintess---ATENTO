@IsTest
private class BatchExpurgoTest {

	@IsTest
	static void metodoOne(){
		Datetime data = Datetime.now().addDays(-1).addYears(-1);

		User user = [SELECT ID FROM USER LIMIT 1];
		Opportunity oportunidade = TestData.getOpportunity();
		Lead lead = TestData.getLead();


//		EmailMessage emailMessage = new DAOEmailMessage();

		Tempo_Operador__c t1 = new Tempo_Operador__c();
		t1.Operador__c = user.id;
		t1.Tipo_da_Acao__c = 'Atendimento';
		t1.Data_Hora_Inicio__c = Datetime.Now();
		t1.Data_Hora_Fim__c = Datetime.Now() + 1;
		insert t1;
		Test.setCreatedDate(t1.Id,data);

		Tarifas_Carrinho__c tarifa = new Tarifas_Carrinho__c();
		Produtos_Alelo__c produto = new Produtos_Alelo__c();
		produto.Oportunidade__c = oportunidade.id;
		produto.Numero_do_Contrato__c = '123';
		insert produto;
		tarifa.Name = 'Teste';
		tarifa.Produtos_Alelo__c = produto.Id;
		insert tarifa;
		Test.setCreatedDate(tarifa.Id,data);


		ScheduleExpurgo s = new ScheduleExpurgo ();
		String schedule = '0 1 * * * ?';

		Test.startTest();
		System.schedule('Test ScheduleExpurgo', schedule, s);
		Test.stopTest();
	}
}
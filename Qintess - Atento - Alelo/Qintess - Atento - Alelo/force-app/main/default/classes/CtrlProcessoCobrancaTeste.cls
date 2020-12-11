@isTest
private class CtrlProcessoCobrancaTeste {
    
    static CtrlProcessoCobranca controller;
    @isTest
    static  void Test_Method01(){
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName ='Teste';
        opp.CloseDate = date.valueOf(system.now());
        insert opp;
        
        Produtos_Alelo__c produto = new Produtos_Alelo__c();
        produto.Oportunidade__c = opp.id;
        insert produto;
        
        Cobranca__c cobranca = new Cobranca__c();
        cobranca.Produtos_Alelo__c = produto.id;
        cobranca.Oportunidade__c = opp.id;
        cobranca.Status__c = 'Cobranca';
        cobranca.Data_Hora_Tabulacao__c = date.valueOf(system.now());
        insert cobranca;


		Profile prof = [SELECT Id,Name FROM Profile Where Name =: 'Operador - Cobrança'];
		System.debug('perfil  ' + prof);

		User usuario = new User();
		usuario.ProfileId = prof.id;
		usuario.UserName = 'ClovisRicardoJose@ultraMail.com.filas';
		usuario.LastName = 'Atento';
		usuario.Email = 'Email@123.com';
		usuario.Alias = 'Alias';
		usuario.CommunityNickname ='Communt';
		usuario.timeZoneSidKey = 'GMT';
		usuario.localeSidKey = 'pt_BR';
		usuario.emailEncodingKey = 'ISO-8859-1';
		usuario.languageLocaleKey = 'pt_BR';
		usuario.Equipe__c = 'ATIVO';


		System.runAs(usuario){
			Test.startTest();
			ApexPages.StandardController controllerPage = new ApexPages.StandardController(cobranca);
			controller = new CtrlProcessoCobranca(controllerPage);

			CtrlProcessoCobranca.implantar(cobranca.id, opp.id);
			//controller.implantar(cobranca.id, opp.id);

			Test.stopTest();
		}
	}
}
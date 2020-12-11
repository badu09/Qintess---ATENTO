@IsTest (seeAllData=True)
public class CtrlTabulaLeadTest {

	static testmethod void TestCtrltabulaLead(){

		PageReference PageRefLead = new PageReference('/apex/TabulaLead');
		Test.setCurrentPage(PageRefLead);
		Test.startTest();

		Lead lead = [SELECT id FROM Lead LIMIT 1];
		ApexPages.StandardController sc = new ApexPages.StandardController(lead);
		CtrlTabulaLead controller = new CtrlTabulaLead(sc);

		controller.LeadObj = lead;
		controller.leadObj.Phone = '1139567473';
		controller.telefone = '1139567473';
		controller.tabulacao1 = '039';
		controller.selecionarTabulacao();
		controller.salvar();

		controller.LeadObj = lead;
		controller.leadObj.Telefone2__c = '1139567475';
		controller.telefone = '1139567475';
		controller.tabulacao1 = '039';
		controller.selecionarTabulacao();
		controller.salvar();

		controller.LeadObj = lead;
		controller.leadObj.Telefone3__c = '1139567479';
		controller.telefone = '1139567479';
		controller.tabulacao1 = '039';
		controller.selecionarTabulacao();
		controller.salvar();

		controller.LeadObj = lead;
		controller.leadObj.Telefone4__c = '1139567478';
		controller.telefone = '1139567478';
		controller.tabulacao1 = '039';
		controller.selecionarTabulacao();
		controller.salvar();

		controller.LeadObj = lead;
		controller.leadObj.Telefone5__c = '1139567471';
		controller.telefone = '1139567471';
		controller.tabulacao1 = '033';
		controller.leadObj.Agendamento_Retorno__c = Datetime.newInstance(2067, 4, 9, 14,54,2);
		controller.selecionarTabulacao();
		controller.salvar();








		controller.getTabulacoes();
		controller.selecionarTabulacao();
		controller.salvar();




	}

}
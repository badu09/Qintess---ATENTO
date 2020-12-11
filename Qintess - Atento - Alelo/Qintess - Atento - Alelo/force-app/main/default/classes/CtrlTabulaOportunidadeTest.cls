@istest (seeAllData=True)
public class CtrlTabulaOportunidadeTest {

	static testmethod void testCtrlTabulaOportunidade(){
		PageReference PageRefOportunidade = new PageReference('/apex/TabulaOportunidade');
		Test.setCurrentPage(PageRefOportunidade);
		Test.startTest();

		Opportunity oportunidade = [SELECT id FROM Opportunity where Data_da_Auditoria__c != null LIMIT 1 OFFSET 2];
		ApexPages.StandardController cs = new ApexPages.StandardController(oportunidade);
		CtrlTabulaOportunidade controller = new CtrlTabulaOportunidade(cs);
		controller.tabulacao1 = '033';
		controller.selecionarTabulacao();
		controller.fakeOportunidade.Agendamento_Retorno__c = Datetime.newInstance(2068, 4, 9, 14,54,2);
		controller.salvar();
		controller.getTabulacoes();




	}
}
@IsTest(seeAllData=True)

public class CtrlConsultaReceptivoTest {

	static testmethod void TestCtrlConsultaReceptivo(){

		PageReference pageRefReceptivo = new PageReference('/apex/ConsultaReceptivo');
		Test.setCurrentPage(pageRefReceptivo);
		Test.startTest();

		CtrlConsultaReceptivo controller = new CtrlConsultaReceptivo();

		controller.cnpjCpf = [SELECT CNPJ__c from Lead WHERE CNPJ__c != null limit 1].CNPJ__c;

		controller.consultar();
		controller.novoLead();
		controller.gravarLead();


	}
}
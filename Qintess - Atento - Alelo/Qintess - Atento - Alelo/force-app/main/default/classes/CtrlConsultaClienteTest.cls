@istest/**
 * Created by guilhermeandrade on 04/09/17.
 */
public class CtrlConsultaClienteTest {

	static testmethod void TestCtrlConsultaCliente(){

		PageReference pageRefCliente = new PageReference('/apex/ConsultaCliente');
		Test.setCurrentPage(pageRefCliente);
		Test.startTest();
		ApexPages.currentPage().getParameters().put('Contrato','12234317');
		CtrlConsultaCliente consulta = new CtrlConsultaCliente();

		consulta.cancelar();
		consulta.consultar();
		CtrlConsultaCliente.validarCNPJ('31789401000104');





	}

}
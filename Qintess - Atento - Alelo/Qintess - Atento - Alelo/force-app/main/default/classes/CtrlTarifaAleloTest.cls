@IsTest (seeAllData=True)
public class CtrlTarifaAleloTest {

	static testmethod void TestCtrlTarifaAlelo(){
	PageReference pageRefTarifa = new PageReference('/apex/TarifaAlelo');
	Test.setCurrentPage(pageRefTarifa);
	Test.startTest();

		CtrlTarifaAlelo tarifa = new CtrlTarifaAlelo();
		tarifa.carregarTarifa();
		tarifa.pesquisar();
		tarifa.salvar();
		tarifa.cancelar();



	}

}
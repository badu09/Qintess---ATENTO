@IsTest
public class GerarCsvFilasMTest{

	@IsTest
	static void test_method_one() {

		GerarCsvFilasM.PedidoFila wc = new GerarCsvFilasM.PedidoFila('00Q19000004m3WJ','00G3g000000EURIEA4');
		List<GerarCsvFilasM.PedidoFila> lista = new List<GerarCsvFilasM.PedidoFila>();
		lista.add(wc);

		DAOOrgWideEmailAddress.getEmailAddress();

		GerarCsvFilasM.enviarCSVEmail(lista);
	}
}
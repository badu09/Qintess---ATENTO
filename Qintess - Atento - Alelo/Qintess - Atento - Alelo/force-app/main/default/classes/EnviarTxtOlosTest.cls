@IsTest
public class EnviarTxtOlosTest {

	@IsTest
	static void test_method_one(){

		EnviarTxtOlos.WrapperClass wc = new EnviarTxtOlos.WrapperClass();
		wc.IdSF = '00Q19000004m3WJ';
		List<EnviarTxtOlos.WrapperClass> lista = new List<EnviarTxtOlos.WrapperClass>();
		lista.add(wc);

		DAOOrgWideEmailAddress.getEmailAddress();

		EnviarTxtOlos.enviarMaillingOlos(lista);
        


	}

}
@isTest
public class BOImplantacaoTest {
	@isTest
	public static void insereImplantacao(){
		Implantacao__c novaImplantacao = new Implantacao__c();
		novaImplantacao.Agencia_Digito__c = 0.000;
		novaImplantacao.Banco__c = 'BANCO BRADESCO';
		novaImplantacao.BillingCity__c = '3469';
		novaImplantacao.Canal_de_Venda__c = 'Agência bancária';
		novaImplantacao.CPF_CNPJ__c = '20490623000105';
		novaImplantacao.Data_do_Cadastramento__c = Date.newInstance(2019,9,18);
		novaImplantacao.Data_do_Mailing__c = Date.newInstance(2019,9,19);
		novaImplantacao.Email_Operacional__c = 'juliana.neres@resourceit.com';
		novaImplantacao.Email__c = 'juliana.neres@resourceit.com';
		novaImplantacao.Faturamento_Previsto_Implantacao__c = 145.200;
		novaImplantacao.Faturamento__c = 145.200;
		novaImplantacao.Forma_de_Pagamento__c = 'Antecipado';
		novaImplantacao.Interlocutor_Operacao__c = 'THIAGO CARDOSO FERREIRA';
		novaImplantacao.LastName__c = 'THIAGO CARDOSO FERREIRA';
		novaImplantacao.Name = 'a071R00000YTSS4';
		novaImplantacao.Nome_da_Campanha__c = 'MAILING IMPLANTAÇÃO';
		novaImplantacao.Nome_de_Produto_Alelo__c = 'ALELO AUTO';
		novaImplantacao.Nome_do_Vendedor__c = 'BANCO BRADESCO S.A';
		novaImplantacao.Numero_do_Contrato__c = '50000000';
		novaImplantacao.Numero__c = 0.000;
		novaImplantacao.OwnerId = '00536000003dHMmAAM';
		novaImplantacao.Razao_Social__c = 'EMPRESA XPTO LTDA';
		novaImplantacao.Rua_de_entrega__c = 'Av. Santo Amaro';
		novaImplantacao.Telefone_2__c = '22834230';
		novaImplantacao.Telefone_Operacional__c = '22834230';
		novaImplantacao.Usuarios__c = '33';
		novaImplantacao.Codigo_do_Banco__c = '1';

		Test.startTest();
		insert novaImplantacao;
		Test.stopTest();
	}
}
@IsTest
public class ScheduleBatchImplantacaoTest {

    @TestSetup
    static void setup() {
        BatchImplantacaoConfig__c config = new BatchImplantacaoConfig__c();
        config.Ativo__c = true;
        config.Gravar_Logs__c = true;
        config.Tentativas_de_Processamento_Maxima__c = 1;
        config.Limites__c = 50;

        insert config;
    }

    @IsTest
    static void test_method_one(){
        Implantacao__c impl = new Implantacao__c();
        impl.CPF_CNPJ__c = '62516629000146';
        impl.Bairro__c = 'Centro';
        impl.BillingCity__c = 'São Paulo';
        impl.Estado_Provincia_de_entrega__c = 'SP';
        impl.Numero__c = 123;
        impl.Rua_de_entrega__c = 'Rua Test Test';
        impl.Telefone_2__c = '21212121';
        impl.Numero_do_Contrato__c = '123';
        impl.Razao_Social__c = 'Empresa Test';
        impl.Nome_da_Campanha__c = 'Campanha Test';
        impl.Interlocutor_Operacao__c = 'Test';
        impl.LastName__c = 'Name Test';
        impl.DDDCelular__c = 11;
        impl.dddfax__c = 11;
        impl.DDD__c = 11;
        impl.DDDRedidencial__c = 11;
        impl.Email__c = 'atentotest@atento.com.br';
        impl.Fax__c = '21212121';
        impl.Ramal__c = 21212121;
        impl.Telefone__c = '21212121';
        impl.Tipo__c = 'Decisor';
        impl.Telefone_Residencial__c = '21212121';
        impl.Interlocutor_Operacao__c = 'test';
        impl.Celular_Operacional__c = '921212121';
        impl.DDDCelular_Operacional__c = 11;
        impl.dddfax_Operacional__c = 11;
        impl.DDD_Operacional__c = 11;
        impl.DDDRedidencial__c = 11;
        impl.Email_Operacional__c = 'atentobr@atento.com.br';
        impl.Fax_Operacional__c = '21212121';
        impl.Ramal_Operacional__c = 21212121;
        impl.Telefone_Operacional__c = '21212121';
        impl.Telefone_Residencial_Operacional__c = '21212121';
        impl.Canal_de_Venda__c = 'Telefone';
        impl.Cobranca__c = 'Test';
        impl.Data_do_Cadastramento__c = Date.today().addDays(-100);
        impl.Data_do_Mailing__c = Date.today();
        impl.DDDVendedor__c = 11;
        impl.Entrega__c = 'test';
        impl.Nome_do_Vendedor__c = 'Nome Teste';
        impl.Operacao__c = 'Test';
        impl.Sistema_de_Pedidos__c = 'Aprovado';
        impl.Status__c = 'Aberto';
        impl.Telefone_Vendedor__c = '21212121';
        impl.Usuarios__c = 'Test';
        impl.VendedorRamal__c = 21212121;
        impl.Phone__c = '21212121';
		impl.Agencia_Debito_em_Conta__c = 0001;
        impl.Agencia_Debito_em_Conta__c = 1;
        impl.Banco__c = '724';
        impl.Banco_Debito_em_Conta__c = 'BB';
        impl.Faturamento__c = 123;
        impl.Faturamento_Previsto_Implantacao__c = 123;
        impl.Forma_de_Pagamento__c = 'Cartão';
        impl.Nome_de_Produto_Alelo__c = 'Alelo Refeição';
        impl.Numero_do_Contrato__c = '123';
        
        
        Test.startTest();
        insert impl;
        
        String jobId = System.schedule('ScheduleBatchImplantacao2', '0 0 0 3 9 ? 2022', new ScheduleBatchImplantacao());
        Test.stopTest();
    }

    @IsTest
    static void test_method_two(){
        Implantacao__c impl = new Implantacao__c();
        impl.CPF_CNPJ__c = '62516629000146';
        impl.Bairro__c = 'Centro';
        impl.BillingCity__c = 'São Paulo';
        impl.Estado_Provincia_de_entrega__c = 'SP';
        impl.Numero__c = 123;
        impl.Rua_de_entrega__c = 'Rua Test Test';
        impl.Telefone_2__c = '21212121';
        impl.Numero_do_Contrato__c = '123';
        impl.Razao_Social__c = 'Empresa Test';
        impl.Nome_da_Campanha__c = 'Campanha Test';
        impl.Interlocutor_Operacao__c = 'Test';
        impl.LastName__c = 'Name Test';
        impl.DDDCelular__c = 11;
        impl.dddfax__c = 11;
        impl.DDD__c = 11;
        impl.DDDRedidencial__c = 11;
        impl.Email__c = 'atentotest@atento.com.br';
        impl.Fax__c = '21212121';
        impl.Ramal__c = 21212121;
        impl.Telefone__c = '21212121';
        impl.Tipo__c = 'erro';
        impl.Telefone_Residencial__c = '21212121';
        impl.Interlocutor_Operacao__c = 'test';
        impl.Celular_Operacional__c = '921212121';
        impl.DDDCelular_Operacional__c = 11;
        impl.dddfax_Operacional__c = 11;
        impl.DDD_Operacional__c = 11;
        impl.DDDRedidencial__c = 11;
        impl.Email_Operacional__c = 'atentobr@atento.com.br';
        impl.Fax_Operacional__c = '21212121';
        impl.Ramal_Operacional__c = 21212121;
        impl.Telefone_Operacional__c = '21212121';
        impl.Telefone_Residencial_Operacional__c = '21212121';
        impl.Canal_de_Venda__c = 'Telefone';
        impl.Cobranca__c = 'Test';
        impl.Data_do_Cadastramento__c = Date.today().addDays(-100);
        impl.Data_do_Mailing__c = Date.today();
        impl.DDDVendedor__c = 11;
        impl.Entrega__c = 'test';
        impl.Nome_do_Vendedor__c = 'Nome Teste';
        impl.Operacao__c = 'Test';
        impl.Sistema_de_Pedidos__c = 'Aprovado';
        impl.Status__c = 'Aberto';
        impl.Telefone_Vendedor__c = '21212121';
        impl.Usuarios__c = 'Test';
        impl.VendedorRamal__c = 21212121;
        impl.Phone__c = '21212121';
        impl.Agencia_Debito_em_Conta__c = 0001;
        impl.Agencia_Debito_em_Conta__c = 1;
        impl.Banco__c = '724';
        impl.Banco_Debito_em_Conta__c = 'BB';
        impl.Faturamento__c = 123;
        impl.Faturamento_Previsto_Implantacao__c = 123;
        impl.Forma_de_Pagamento__c = 'Cartão';
        impl.Nome_de_Produto_Alelo__c = 'Alelo Refeição';
        impl.Numero_do_Contrato__c = '123';


        Test.startTest();
        insert impl;

        String jobId = System.schedule('ScheduleBatchImplantacao2', '0 0 0 3 9 ? 2022', new ScheduleBatchImplantacao());
        Test.stopTest();
    }
}
@isTest
public class TabuladorAleloControllerTest {
    
    @isTest
    public static void testGetAccountInfo(){
        Account acct_test = TestData.getAccount();
        Account acct = TabuladorAleloController.getAccountInfo(acct_test.Id);
        System.assert(acct != null, 'O método "getAccountInfo" não retornou o registro Account esperado.');
    }
    
    @isTest
    public static void testGetNameUser(){
    	String name = TabuladorAleloController.getNameUser();
        System.debug(name);
    }
    
    @isTest
    public static void testGetAccounts(){
        Account acct = TestData.getAccount();
        acct.GrupoRelacionamentoId__c = '10';
        update acct;
        List<Account> accts = TabuladorAleloController.getAccounts('10');
        System.assertEquals(1, accts.size(), 'O método "getAccounts" não retornou o registro Account esperado.');
        List<Account> accts2 = TabuladorAleloController.getAccounts('');
        System.assertEquals(0, accts2.size(), 'O método "getAccounts" retornou contas não esperadas.');
    }
    
    @isTest
    public static void testGetProdutosAleloByAccountId(){
        Opportunity oppt = TestData.getOpportunity();
        Produtos_Alelo__c prod = TestData.getProdutoAlelo(oppt.Id, 'Produto Teste');
        Produtos_Alelo__c prod2 = TestData.getProdutoAlelo(oppt.Id, 'Produto Teste 2');

        List<Produtos_Alelo__c> listProd = TabuladorAleloController.getProdutosAleloByAccountId(oppt.AccountId);
        System.assertEquals(2, listProd.size(), 'O método "getProdutosAleloByAccountId" não retornou os registros Produtos_Alelo__c esperados.');
    }
    
    @isTest
    public static void testGetProdutosAleloByGrupoRelId(){
        Opportunity oppt = TestData.getOpportunity();
        
        Account acct = [SELECT Id, GrupoRelacionamentoId__c FROM Account WHERE Id = :oppt.AccountId LIMIT 1];
        acct.GrupoRelacionamentoId__c = '10';
        update acct;
        
        Produtos_Alelo__c prod = TestData.getProdutoAlelo(oppt.Id, 'Produto Teste');
        Produtos_Alelo__c prod2 = TestData.getProdutoAlelo(oppt.Id, 'Produto Teste 2');

        List<Produtos_Alelo__c> listProd = TabuladorAleloController.getProdutosAleloByGrupoRelId('10');
        System.assertEquals(2, listProd.size(), 'O método "getProdutosAleloByGrupoRelId" não retornou os registros Produtos_Alelo__c esperados.');
    }
    
    @isTest
    public static void testConsolidar(){
        List<Id> ids = new List<Id>();
		Map<String, String> params = new Map<String, String>();
        
        Account acct_test = TestData.getAccount();
        ids.add(acct_test.Id);
        
        params.put('cnpj', '24311653000150');
        params.put('razaoSocial', 'Razao Social');
        params.put('folhaDePagto', 'BANCO DO BRASIL');
        params.put('interlocutor', 'Interlocutor');
        params.put('dataDoUltimoContato', '2021-01-01');
        params.put('dataAgendamentoProxContato', '2022-01-01');
        params.put('risco', 'NÃO');
        params.put('mesDeRetencao', '2020-12-12');
        params.put('prazoDeBlindagem', '12 meses');
        params.put('statusDoGrupo', 'Apresentação Consultor');
        params.put('fatorDeRisco', 'Assédio Concorrência');
        params.put('statusDoRisco', 'PERDIDO');
        params.put('acaoPosPerda', 'Multa');
        params.put('mesDePerda', '2020-12-12');
        params.put('telefone', '1140004000');
        params.put('email', 'email@gmail.com');
        params.put('fornAlimentacao', 'CESTA FISICA');
        params.put('statusAlimentacao', 'Negociação - Aguardando Aprovação Alelo');
        params.put('fornRefeicao', 'ALELO/REFEITORIO');
        params.put('statusRefeicao', 'Recusa - Acordo Sindical');
        params.put('fornTransporte', 'FRETADO');
        params.put('statusTransporte', 'Proposta Enviada - Em Análise');
        params.put('fornCombustivel', 'GOOD CARD');
        params.put('statusCombustivel', 'Não Ofertado');
        params.put('fornNatal', 'DINHEIRO');
        params.put('statusNatal', 'Não Ofertado');
        params.put('fornPremiacao', 'NÃO FORNECE');
        params.put('statusPremiacao', 'Negociação - Aguardando Aprovação Alelo');
        params.put('fornDespesas', 'DINHEIRO');
        params.put('statusDespesas', '100% Alelo');
        params.put('fornPagamentos', 'SODEXO');
        params.put('statusPagamentos', 'Negociação - Aguardando Aprovação Alelo');
        
        TabuladorAleloController.consolidar(ids, params, true);
        
        Account acct = [SELECT Id, Name, Estado__c, CPF_CNPJ__c, Razao_Social__c, Data_Agendamento_prox_Contato__c,
                        FORNECEDOR_ATUAL_NATAL__c, Status_Negocia_o_Despesas__c 
                        FROM Account WHERE Id = :acct_test.Id LIMIT 1];
        
        System.assertEquals(acct_test.Name, acct.Name);
        System.assertEquals(acct_test.Estado__c, acct.Estado__c);
        System.assertEquals('24311653000150', acct.CPF_CNPJ__c);
		System.assertEquals('Razao Social', acct.Razao_Social__c);
        System.assertEquals(Date.valueOf('2022-01-01'), acct.Data_Agendamento_prox_Contato__c);
        System.assertEquals('DINHEIRO', acct.FORNECEDOR_ATUAL_NATAL__c);
        System.assertEquals('100% Alelo', acct.Status_Negocia_o_Despesas__c);
    }
    
    @isTest
    public static void testGetPicklistMethods(){
        Test.startTest();
        List<String> opcoes = TabuladorAleloController.getPickListValuesFolhaDePagto();
        System.assert(opcoes.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Folha_de_Pagto__c".');
        
        List<String> opcoes1 = TabuladorAleloController.getPickListValuesRisco();
        System.assert(opcoes1.size() > 0, 'O método não retornou nenhuma opção existente na picklist "RISCO__C".');   
        
        List<String> opcoes2 = TabuladorAleloController.getPickListValuesPrazodeBlindagem();
        System.assert(opcoes2.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Prazo_de_Blindagem__c".');
        
        List<String> opcoes3 = TabuladorAleloController.getPickListValuesStatusdoGrupo();
        System.assert(opcoes3.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Status_do_Grupo__c".');
        
        List<String> opcoes4 = TabuladorAleloController.getPickListValuesFatordeRisco();
        System.assert(opcoes4.size() > 0, 'O método não retornou nenhuma opção existente na picklist "FATORRISCO__c".');
        
        List<String> opcoes5 = TabuladorAleloController.getPickListValuesStatusdeRisco();
        System.assert(opcoes5.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Status_do_Risco__c".');
        
        List<String> opcoes6 = TabuladorAleloController.getPickListValuesAcaoPosPerda();
        System.assert(opcoes6.size() > 0, 'O método não retornou nenhuma opção existente na picklist "A_o_P_s_Perda__c".');       

        List<String> opcoes7 = TabuladorAleloController.getPickListValuesFornAtualAlimentacao();
        System.assert(opcoes7.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Fornecedor_Atual_Alimenta_o__c".');
     
        List<String> opcoes8 = TabuladorAleloController.getPickListValuesFornAtualRefeicao();
        System.assert(opcoes8.size() > 0, 'O método não retornou nenhuma opção existente na picklist "FORNECEDOR_ATUAL_REFEI_O__c".');
        
        List<String> opcoes9 = TabuladorAleloController.getPickListValuesFornAtualTransporte();
        System.assert(opcoes9.size() > 0, 'O método não retornou nenhuma opção existente na picklist "FORNECEDOR_ATUAL_TRANSPORTE__c".');
        
        List<String> opcoes10 = TabuladorAleloController.getPickListValuesFornAtualCombustivel();
        System.assert(opcoes10.size() > 0, 'O método não retornou nenhuma opção existente na picklist "FORNECEDOR_ATUAL_COMBUSTIVEL__c".');
        
        List<String> opcoes11 = TabuladorAleloController.getPickListValuesStatusAlimentacao();
        System.assert(opcoes11.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Status_Negocia_o_Alimenta_o__c".');
        
        List<String> opcoes12 = TabuladorAleloController.getPickListValuesStatusRefeicao();
        System.assert(opcoes12.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Status_Negocia_o_Refei_o__c".');
        
        List<String> opcoes13 = TabuladorAleloController.getPickListValuesStatusTransporte();
        System.assert(opcoes13.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Status_Negocia_o_Transporte__c".');
        
        List<String> opcoes14 = TabuladorAleloController.getPickListValuesStatusCombustivel();
        System.assert(opcoes14.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Status_Negocia_o_Combust_vel__c".');
        
        List<String> opcoes15 = TabuladorAleloController.getPickListValuesFornAtualNatal();
        System.assert(opcoes15.size() > 0, 'O método não retornou nenhuma opção existente na picklist "FORNECEDOR_ATUAL_NATAL__c".');
        
        List<String> opcoes16 = TabuladorAleloController.getPickListValuesFornAtualPremiacao();
        System.assert(opcoes16.size() > 0, 'O método não retornou nenhuma opção existente na picklist "FORNECEDOR_ATUAL_PR_PAGOS_Premia_o_in__c".');
        
        List<String> opcoes17 = TabuladorAleloController.getPickListValuesFornAtualDespesas();
        System.assert(opcoes17.size() > 0, 'O método não retornou nenhuma opção existente na picklist "PR_PAGOS_Despesas__c".');
        
        List<String> opcoes18 = TabuladorAleloController.getPickListValuesFornAtualPagamentos();
        System.assert(opcoes18.size() > 0, 'O método não retornou nenhuma opção existente na picklist "PR_PAGOS_Pagamentos__c".');
        
        List<String> opcoes19 = TabuladorAleloController.getPickListValuesStatusNatal();
        System.assert(opcoes19.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Status_Negocia_o_Natal__c".');
        
        List<String> opcoes20 = TabuladorAleloController.getPickListValuesStatusPremiacao();
        System.assert(opcoes20.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Status_Negocia_o_PR_PAGOS_Premia_o__c".');
        
        List<String> opcoes21 = TabuladorAleloController.getPickListValuesStatusDespesas();
        System.assert(opcoes21.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Status_Negocia_o_Despesas__c".');
        
        List<String> opcoes22 = TabuladorAleloController.getPickListValuesStatusPagamentos();
        System.assert(opcoes22.size() > 0, 'O método não retornou nenhuma opção existente na picklist "Status_Negocia_o_Pagamentos__c".');
        
        Test.stopTest();
    }
    
}
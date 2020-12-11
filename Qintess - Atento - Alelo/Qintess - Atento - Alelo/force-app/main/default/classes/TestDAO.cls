@isTest
private class TestDAO {

    static testMethod void testLead() {
        Test.startTest();
        String leadsJson = '[{"LastName":"AMBIENTEBRASIL","Company":"AMBIENTE BRASIL ENG TECN E DES SOL LIMP","Phone":"21 35252452","Telefone2__c":"21 35253452","Telefone3__c":"21 974046729","Telefone4__c":"21 32642166","Telefone5__c":"21 995718247","Nome_da_Campanha__c":"Banco do Brasil","CNPJ__c":"07812337000142","Name":"AMBIENTEBRASIL"},{"LastName":"BERTRAND","Company":"GM COMERCIO E IMPORT","Phone":"83 32312532","Telefone2__c":"83 96361415","Telefone4__c":"83 32223878","Telefone5__c":"83 96193339","Nome_da_Campanha__c":"Receptivo","CNPJ__c":"07827111000115","Name":"BERTRAND"},{"LastName":"DANIELLE","Company":"SALCO BRASIL LOGISTICA LTDA","Phone":"85 30313700","Telefone2__c":"85 32685005","Telefone4__c":"85 32412231","Telefone5__c":"85 40080900","Nome_da_Campanha__c":"Receptivo","CNPJ__c":"07836457000180","Name":"DANIELLE"},{"LastName":"FINANCEIRO","Company":"MEKATRONIK IND. E COM. DE AUTOMAÇÃO","Phone":"81 93231570","Telefone2__c":"81 994680000","Telefone4__c":"81 34294007","Telefone5__c":"81 93231158","Nome_da_Campanha__c":"Receptivo","CNPJ__c":"07839744000143","Name":"FINANCEIRO"},{"LastName":"ATENDIMENTO","Company":"VILA DE SINTRA EMPREENDIMENTOS S A","Phone":"81 33348676","Telefone4__c":"81 97215200","Telefone5__c":"81 97215253","Nome_da_Campanha__c":"Receptivo","CNPJ__c":"07852439000191","Name":"ATENDIMENTO"},{"LastName":"DP","Company":"MUNIZ E MUNIZ SERVICOS HOSPITALARES LTDA","Phone":"81 21290440","Telefone2__c":"81 21290445","Telefone3__c":"81 21290465","Telefone4__c":"81 21290402","Telefone5__c":"81 21290403","Nome_da_Campanha__c":"Receptivo","CNPJ__c":"07880207000147","Name":"DP"},{"LastName":"ALESSANDRA","Company":"MENTAL CLEAN PSICOLOGIA CLINICA E ACESSO","Phone":"11 55794918","Telefone4__c":"11 50320887","Telefone5__c":"11 989137456","Nome_da_Campanha__c":"Receptivo","CNPJ__c":"07890818000176","Name":"ALESSANDRA"},{"LastName":"CATIA.FERREIRA","Company":"G4 SOLUCOES EM GESTAO DA INFORMACAO","Phone":"11 30218899","Telefone2__c":"11 36487070","Telefone4__c":"11 25785931","Telefone5__c":"11 30215446","Nome_da_Campanha__c":"Receptivo","CNPJ__c":"07901391000164","Name":"CATIA.FERREIRA"},{"LastName":"MASTER.RH","Company":"UHA MASTER PLAZA ADMINISTRACAO HOTELEIRA","Phone":"11 21026000","Telefone2__c":"16 21026000","Telefone3__c":"16 21026013","Telefone4__c":"16 36230411","Telefone5__c":"16 36352502","Nome_da_Campanha__c":"Receptivo","CNPJ__c":"07970699000161","Name":"MASTER.RH"},{"LastName":"BRUNO_STOMP","Company":"STOMP INDUSTRIA E COMERCIO DE MODAS LTDA","Phone":"84 32346840","Telefone4__c":"84 32185914","Nome_da_Campanha__c":"Receptivo","CNPJ__c":"08106301000106","Name":"BRUNO_STOMP"}]';
      	List<Lead> leads = (List<Lead>)JSON.deserialize(leadsJson, List<Lead>.class);

      	DAOLead.getLead('');
      	insert leads;
      	DAOLead.getLeadByCampanha('Banco do Brasil');
      	DAOLead.salvarlead(leads);
      	DAOLead.getLeads();

      	delete leads;
      	Test.stopTest();
    }

    static testMethod void testUser() {
    	Test.startTest();
    	DAOUser.getUser();
    	Test.stopTest();
    }

    static testMethod void testTarifaCarrinho() {
        Test.startTest();
    	DAOTarifaCarrinho.limparTarifas('');
    	Test.stopTest();
    }

    static testMethod void testAccount() {
    	Test.startTest();
    	String accountsJson = '[{"Name":"SO VEDACOES COMERCIAL LTDA","CPF_CNPJ__c":"73728297000180","Razao_Social__c":"SO VEDACOES COMERCIAL LTDA"},{"Name":"ESQUADRIAS METALICAS SANTA CRUZ LTD","CPF_CNPJ__c":"13576092000102","Ramo_de_Atividade__c":"Comercial-Outros","Inscricao_Municipal__c":"Isento","Complemento__c":"Predio 5","Nome_Fantasia__c":"Metal Esquadra","Inscricao_Estadual__c":"Isento","Razao_Social__c":"ESQUADRIAS METALICAS","Quantidade_de_Funcionarios__c":25,"Tipo_de_Empresa__c":"Empresa Privada (001)"},{"Name":"uniao nordeste","CPF_CNPJ__c":"01104932000902","Ramo_de_Atividade__c":"Comercial -Outros","Inscricao_Municipal__c":"15478965","Nome_Fantasia__c":"uniao nordeste","Inscricao_Estadual__c":"012345","Razao_Social__c":"uniao nordeste","Quantidade_de_Funcionarios__c":50,"Tipo_de_Empresa__c":"Empresa Privada (001)"},{"Name":"FERA COMERCIO DE ALIMENTOS LTDA - E","CPF_CNPJ__c":"16607612000187"},{"Name":"MAIPU SP PARTICIPACOES LTDA","CPF_CNPJ__c":"13940428000166"},{"Name":"FULIARO SUPERMERCADOS LTDA","CPF_CNPJ__c":"13827783000123"},{"Name":"SANTOS FLORA","CPF_CNPJ__c":"51569309000138","Ramo_de_Atividade__c":"Comercial-Outros","Inscricao_Municipal__c":"Isento","Complemento__c":"Bloco C 54","Numero__c":80,"Bairro__c":"Itaquera","Nome_Fantasia__c":"SANTOS FLORA","Inscricao_Estadual__c":"isento","Razao_Social__c":"SANTOS FLORA","BillingStreet":"Rua Neve na Bahia","Quantidade_de_Funcionarios__c":63,"Tipo_de_Empresa__c":"Empresa Privada (001)","BillingPostalCode":"08257060","Bairro_Cobranca__c":"itaquera","Complemento_Cobranca__c":"80","BillingCity":"São Paulo"},{"Name":"TOP GLOBAL ASSESSORIA ADUANEIRA LTDA","CPF_CNPJ__c":"09031864000145","Razao_Social__c":"TOP GLOBAL ASSESSORIA ADUANEIRA LTDA","Tipo_de_Empresa__c":"Empresa Privada (001)"},{"Name":"JAF SERVICOS ELETRICOS E REFORMAS L","CPF_CNPJ__c":"10421339000115"},{"Name":"CONDOMINIO DO EDIFICIO MARIO ALFONZO","CPF_CNPJ__c":"02426822000164","Razao_Social__c":"CONDOMINIO DO EDIFICIO MARIO ALFONZO"}]';
    	List<Account> accounts = (List<Account>) JSON.deserialize(accountsJson, List<Account>.class);
    	DAOAccount.getAccountByCNPJ('adadadadad');
    	insert accounts;
    	DAOAccount.getAccountByCNPJ(accounts[0].CPF_CNPJ__c);
    	DAOAccount.getAccountById(accounts[0].Id);
    	Test.stopTest();
    }

    static testMethod void testProdutosAlelo() {
    	Test.startTest();
    	String opportunitiesJson = '{"E_mail_Enviado__c":false, "Name": "TESTE_11H - DATA CLOUD SISTEMAS DE INFORMATICA LTDA", "StageName": "Apresentação Enviada", "CloseDate": "2016-09-30","Produtos_Alelo__r":{"totalSize":5,"done":true,"records":[{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Não Identificado","Nome_do_Produto__c":"Não Identificado","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"302","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Auto","Nome_do_Produto__c":"Auto","Quantidade_de_Cartoes__c":4,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"301","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false},{"Name":"Flex Car Visa Vale","Nome_do_Produto__c":"Flex Car Visa Vale","Quantidade_de_Cartoes__c":5,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"300","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false}]},"Account":{"Name":"DATA CLOUD SISTEMAS DE INFORMATICA LTDA","CPF_CNPJ__c":"18146085000186"}}';
    	Opportunity oportunidade = (Opportunity) JSON.deserialize(opportunitiesJson, Opportunity.class);
    	insert oportunidade.Account;
		oportunidade.AccountId = oportunidade.Account.Id;
    	insert oportunidade;
    	for(Produtos_Alelo__c produto : oportunidade.Produtos_Alelo__r) {
    		produto.Oportunidade__c = oportunidade.Id;
    	}
    	insert oportunidade.Produtos_Alelo__r;
    	DAOProdutosAlelo.getOpportunityProductId(oportunidade.Produtos_Alelo__r[0].Id);
    	DAOProdutosAlelo.getOpportunityProductByOpportunityId(oportunidade.Id);
    	DAOProdutosAlelo.getOpportunityProductByOpportunityIdNameProduct(oportunidade.Id, 'Cultura');
    	DAOProdutosAlelo.getProductByContract('teste');
    	DAOProdutosAlelo.getProductMetasVendas(1,2018);
    	DAOProdutosAlelo.getProductMetasImplantado(1,2018);
    	DAOProdutosAlelo.getProductOportunity(new Set<Id>{oportunidade.Id});
    	Test.stopTest();
    }

    static testMethod void testOpportunity() {
    	Test.startTest();
    	String opportunitiesJson = '{"E_mail_Enviado__c":false, "Name": "TESTE_11H - DATA CLOUD SISTEMAS DE INFORMATICA LTDA", "StageName": "Apresentação Enviada", "CloseDate": "2016-09-30","Produtos_Alelo__r":{"totalSize":5,"done":true,"records":[{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Não Identificado","Nome_do_Produto__c":"Não Identificado","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"302","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Auto","Nome_do_Produto__c":"Auto","Quantidade_de_Cartoes__c":4,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"301","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false},{"Name":"Flex Car Visa Vale","Nome_do_Produto__c":"Flex Car Visa Vale","Quantidade_de_Cartoes__c":5,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"300","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false}]},"Account":{"Name":"DATA CLOUD SISTEMAS DE INFORMATICA LTDA","CPF_CNPJ__c":"18146085000186"}}';
    	Opportunity oportunidade = (Opportunity) JSON.deserialize(opportunitiesJson, Opportunity.class);
    	insert oportunidade.Account;
		oportunidade.AccountId = oportunidade.Account.Id;
    	insert oportunidade;
    	for(Produtos_Alelo__c produto : oportunidade.Produtos_Alelo__r) {
    		produto.Oportunidade__c = oportunidade.Id;
    	}
    	insert oportunidade.Produtos_Alelo__r;
    	DAOOpportunity.getOpportunityById(oportunidade.Id);
    	Test.stopTest();
    }

    static testMethod void testMailingDistribution() {
    	Test.startTest();
    	String mailingDistributionsJson = '[{"Name":"a00P0000003Uxqb","Id_Campanha__c":"2016-09-09"},{"Name":"teste 2909","Id_Campanha__c":"SF_teste 29091° teste2016-09-28"},{"Name":"Setembro Alelo","Id_Campanha__c":"SF_Setembro Alelo2016-09-21"},{"Name":"TESTE_11H","Fila__c":"Fila Treinamento","Id_Campanha__c":"SF_TESTE_11H2016-09-23"},{"Name":"teste 2016 0901","Id_Campanha__c":"SF_teste 2016 09012016-09-26"},{"Name":"27/09","Id_Campanha__c":"SF_27/0927/092016-09-27"},{"Name":"Santander","Fila__c":"Ilha Teste","Id_Campanha__c":"Santander2016-09-07"},{"Name":"Banco do Brasil","Fila__c":"Ilha Bancos - Banco do Brasil","Id_Campanha__c":"Banco do Brasil2016-09-07"},{"Name":"a00P0000003UqfC","Id_Campanha__c":"2016-09-07"},{"Name":"bb","Id_Campanha__c":"SF_bb2016-09-22"}]';
    	List<Mailing_Distribution__c> mailingDistributionList = (List<Mailing_Distribution__c>) JSON.deserialize(mailingDistributionsJson, List<Mailing_Distribution__c>.class);
    	DAOMailingDistribution.getMailingDistribution();
    	insert mailingDistributionList;
    	DAOMailingDistribution.getMailingDistribution();
    	Test.stopTest();
    }

    static testMethod void testGroup() {
    	Test.startTest();
    	String groupsJson = '[{"Name":"Descartados","Type":"Queue"},{"Name":"Fila Treinamento","Type":"Queue"},{"Name":"Ilha Bancos - Banco do Brasil","Type":"Queue"},{"Name":"Ilha Bancos - Bradesco","Type":"Queue"},{"Name":"Ilha Bancos - Santander","Type":"Queue"},{"Name":"Ilha Porto Sguro","Type":"Queue"},{"Name":"Ilha Premium","Type":"Queue"},{"Name":"Ilha Prepax","Type":"Queue"},{"Name":"Ilha Teste","Type":"Queue"},{"Name":"Ilha Welcome","Type":"Queue"},{"Name":"Sem Interesse","Type":"Queue"},{"Name":"Teste","Type":"Queue"}]';
    	List<Group> groups = (List<Group>) JSON.deserialize(groupsJson, List<Group>.class);
    	DAOGroup.getGroup();
    	insert groups;
    	DAOGroup.getGroup();

    	Test.stopTest();
    }

	@isTest(SeeAllData=true)
    static void testEmailTemplate() {
    	Test.startTest();
    	DAOEmailTemplate.obterTemplatePorNome('');
    	DAOEmailTemplate.obterTemplatePorNome('Aprovacao');
    	Test.stopTest();
    }

    static testMethod void testDeParaTabulacao() {
    	Test.startTest();
    	DAODeParaTabulacao.getTabulacao();
    	Test.stopTest();
    }

    static testMethod void testContact() {
    	Test.startTest();
    	String accountsJson = '[{"Name":"SO VEDACOES COMERCIAL LTDA","CPF_CNPJ__c":"73728297000180","Razao_Social__c":"SO VEDACOES COMERCIAL LTDA"},{"Name":"ESQUADRIAS METALICAS SANTA CRUZ LTD","CPF_CNPJ__c":"13576092000102","Ramo_de_Atividade__c":"Comercial-Outros","Inscricao_Municipal__c":"Isento","Complemento__c":"Predio 5","Nome_Fantasia__c":"Metal Esquadra","Inscricao_Estadual__c":"Isento","Razao_Social__c":"ESQUADRIAS METALICAS","Quantidade_de_Funcionarios__c":25,"Tipo_de_Empresa__c":"Empresa Privada (001)"},{"Name":"uniao nordeste","CPF_CNPJ__c":"01104932000902","Ramo_de_Atividade__c":"Comercial -Outros","Inscricao_Municipal__c":"15478965","Nome_Fantasia__c":"uniao nordeste","Inscricao_Estadual__c":"012345","Razao_Social__c":"uniao nordeste","Quantidade_de_Funcionarios__c":50,"Tipo_de_Empresa__c":"Empresa Privada (001)"},{"Name":"FERA COMERCIO DE ALIMENTOS LTDA - E","CPF_CNPJ__c":"16607612000187"},{"Name":"MAIPU SP PARTICIPACOES LTDA","CPF_CNPJ__c":"13940428000166"},{"Name":"FULIARO SUPERMERCADOS LTDA","CPF_CNPJ__c":"13827783000123"},{"Name":"SANTOS FLORA","CPF_CNPJ__c":"51569309000138","Ramo_de_Atividade__c":"Comercial-Outros","Inscricao_Municipal__c":"Isento","Complemento__c":"Bloco C 54","Numero__c":80,"Bairro__c":"Itaquera","Nome_Fantasia__c":"SANTOS FLORA","Inscricao_Estadual__c":"isento","Razao_Social__c":"SANTOS FLORA","BillingStreet":"Rua Neve na Bahia","Quantidade_de_Funcionarios__c":63,"Tipo_de_Empresa__c":"Empresa Privada (001)","BillingPostalCode":"08257060","Bairro_Cobranca__c":"itaquera","Complemento_Cobranca__c":"80","BillingCity":"São Paulo"},{"Name":"TOP GLOBAL ASSESSORIA ADUANEIRA LTDA","CPF_CNPJ__c":"09031864000145","Razao_Social__c":"TOP GLOBAL ASSESSORIA ADUANEIRA LTDA","Tipo_de_Empresa__c":"Empresa Privada (001)"},{"Name":"JAF SERVICOS ELETRICOS E REFORMAS L","CPF_CNPJ__c":"10421339000115"},{"Name":"CONDOMINIO DO EDIFICIO MARIO ALFONZO","CPF_CNPJ__c":"02426822000164","Razao_Social__c":"CONDOMINIO DO EDIFICIO MARIO ALFONZO"}]';
    	List<Account> accounts = (List<Account>) JSON.deserialize(accountsJson, List<Account>.class);
    	DAOAccount.getAccountByCNPJ('adadadadad');
    	insert accounts;
    	DAOContact.getContactByAccountId(accounts[0].Id);
    	Test.stopTest();
    }

    static testMethod void testAttachment() {
    	Test.startTest();
    	String opportunitiesJson = '{"E_mail_Enviado__c":false, "Name": "TESTE_11H - DATA CLOUD SISTEMAS DE INFORMATICA LTDA", "StageName": "Apresentação Enviada", "CloseDate": "2016-09-30","Produtos_Alelo__r":{"totalSize":5,"done":true,"records":[{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Não Identificado","Nome_do_Produto__c":"Não Identificado","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"302","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Cultura","Nome_do_Produto__c":"Cultura","Quantidade_de_Cartoes__c":10,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":50,"Codigo_de_Produtos__c":"400","Valor_Unitario__c":50,"Faturamento_Centralizado__c":false},{"Name":"Auto","Nome_do_Produto__c":"Auto","Quantidade_de_Cartoes__c":4,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"301","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false},{"Name":"Flex Car Visa Vale","Nome_do_Produto__c":"Flex Car Visa Vale","Quantidade_de_Cartoes__c":5,"Entrega_Centralizada__c":false,"Disponibilizacao_mensal__c":1500,"Codigo_de_Produtos__c":"300","Valor_Unitario__c":1500,"Faturamento_Centralizado__c":false}]},"Account":{"Name":"DATA CLOUD SISTEMAS DE INFORMATICA LTDA","CPF_CNPJ__c":"18146085000186"}}';
    	Opportunity oportunidade = (Opportunity) JSON.deserialize(opportunitiesJson, Opportunity.class);
    	insert oportunidade.Account;
		oportunidade.AccountId = oportunidade.Account.Id;
    	insert oportunidade;
    	DAOAttachment.getAttachmentById(new List<Id>());
    	DAOAttachment.getAttachmentByParentId(oportunidade.Id);
    	Test.stopTest();
    }

    static testMethod void testTabelaDominio() {
    	Test.startTest();
    	String tabelaDominioJson = '[{"Codigo_Identificador__c":14,"Descricao__c":"Recisão Contratual","Identificador__c":"FeeCode","PK_Atento__c":5},{"Codigo_Identificador__c":20,"Descricao__c":"Disponibilização Antecipada","Identificador__c":"FeeCode","PK_Atento__c":21},{"Codigo_Identificador__c":202,"Descricao__c":"Alelo Natal Alimentação","Identificador__c":"ProductCode"},{"Codigo_Identificador__c":18,"Descricao__c":"Tarifa de Renovação","Identificador__c":"FeeCode"},{"Codigo_Identificador__c":9,"Descricao__c":"Reemissão de Senha","Identificador__c":"FeeCode","PK_Atento__c":14},{"Codigo_Identificador__c":19,"Descricao__c":"Bonificação","Identificador__c":"FeeCode","PK_Atento__c":20},{"Codigo_Identificador__c":8,"Descricao__c":"Reemissão Emergencial de Cartão","Identificador__c":"FeeCode","PK_Atento__c":13},{"Codigo_Identificador__c":2,"Descricao__c":"Cortesia","Identificador__c":"ContractType","Identificador_Dominio__c":"COURTESY"},{"Codigo_Identificador__c":16,"Descricao__c":"Tarifa Personalizada","Identificador__c":"FeeCode","PK_Atento__c":19},{"Codigo_Identificador__c":23,"Descricao__c":"Tarifa Volume Mensal sobre RNF (%)","Identificador__c":"FeeCode","PK_Atento__c":24},{"Codigo_Identificador__c":13,"Descricao__c":"Cobrança Bancária","Identificador__c":"FeeCode","PK_Atento__c":16},{"Codigo_Identificador__c":22,"Descricao__c":"Tarifa Fixa Mensal sobre RNF","Identificador__c":"FeeCode","PK_Atento__c":23},{"Codigo_Identificador__c":3,"Descricao__c":"(%) Comissão de Administração","Identificador__c":"FeeCode","PK_Atento__c":3},{"Descricao__c":"Tarifa de Gerenciamento cartão eletrônico","Identificador__c":"FeeCode","PK_Atento__c":9},{"Descricao__c":"Tarifa de atendimento por unidade","Identificador__c":"FeeCode","PK_Atento__c":10},{"Codigo_Identificador__c":302,"Descricao__c":"Não Identificado","Identificador__c":"ProductCode"},{"Descricao__c":"Cartão Departamento","Identificador__c":"FeeCode","PK_Atento__c":6},{"Codigo_Identificador__c":400,"Descricao__c":"Cultura","Identificador__c":"ProductCode"},{"Descricao__c":"Taxa de Serviço","Identificador__c":"FeeCode","PK_Atento__c":8},{"Codigo_Identificador__c":10,"Descricao__c":"Emissão de Extrato","Identificador__c":"FeeCode","PK_Atento__c":15},{"Codigo_Identificador__c":15,"Descricao__c":"Tarifa de Inatividade","Identificador__c":"FeeCode","PK_Atento__c":17},{"Codigo_Identificador__c":1,"Descricao__c":"Boas Vindas","Identificador__c":"ContractType","Identificador_Dominio__c":"WELCOMES"},{"Codigo_Identificador__c":300,"Descricao__c":"FLEX CAR","Identificador__c":"ProductCode"},{"Codigo_Identificador__c":2,"Descricao__c":"Manutenção Mensal","Identificador__c":"FeeCode","PK_Atento__c":2},{"Codigo_Identificador__c":24,"Descricao__c":"Emissão de Cartão Estoque","Identificador__c":"FeeCode","PK_Atento__c":25},{"Codigo_Identificador__c":1,"Descricao__c":"Entrega","Identificador__c":"FeeCode","PK_Atento__c":11},{"Codigo_Identificador__c":6,"Descricao__c":"Emissão emergencial do Cartão","Identificador__c":"FeeCode","PK_Atento__c":12},{"Codigo_Identificador__c":301,"Descricao__c":"AUTO","Identificador__c":"ProductCode"},{"Codigo_Identificador__c":0,"Descricao__c":"Padrão","Identificador__c":"ContractType","Identificador_Dominio__c":"DEFAULT"},{"Codigo_Identificador__c":5,"Descricao__c":"Emissão de Cartão","Identificador__c":"FeeCode","PK_Atento__c":7},{"Codigo_Identificador__c":200,"Descricao__c":"Alelo Alimentação","Identificador__c":"ProductCode"},{"Codigo_Identificador__c":7,"Descricao__c":"Reemissão de Cartão","Identificador__c":"FeeCode","PK_Atento__c":4},{"Codigo_Identificador__c":201,"Descricao__c":"Alelo Cesta Alimentação","Identificador__c":"ProductCode"},{"Codigo_Identificador__c":4,"Descricao__c":"Disponibilização do Benefício","Identificador__c":"FeeCode","PK_Atento__c":1},{"Codigo_Identificador__c":21,"Descricao__c":"Entrega Emergencial","Identificador__c":"FeeCode","PK_Atento__c":22},{"Codigo_Identificador__c":17,"Descricao__c":"Tarifa Mensal","Identificador__c":"FeeCode","PK_Atento__c":18},{"Codigo_Identificador__c":100,"Descricao__c":"Alelo Refeição","Identificador__c":"ProductCode"}]';
    	List<Dominio__c> dominioList = (List<Dominio__c>) JSON.deserialize(tabelaDominioJson, List<Dominio__c>.class);
    	insert dominioList;
    	DAOTabelaDominio.getMapFeeCode();
    	DAOTabelaDominio.getMapProductCode();
    	DAOTabelaDominio.getListProductCode('FeeCode');
    	Test.stopTest();
    }

    static testMethod void testTarifa() {
		List<Tarifas_Alelo__c> listTarifasAlelo = new List<Tarifas_Alelo__c>();

		Tarifas_Alelo__c novaTarifaAlelo1 = new Tarifas_Alelo__c(Codigo_da_Tarifa__c = 7.0, Nome_da_Tarifa__c = 'Reemissão de cartão', Valor_Medio_do_Beneficio__c = 100.0, Valor_Maximo__c = 200.0, Valor_Minimo__c = 1.0, Qtd_Min__c = 151.0 , Qtd_Max_Beneficios__c = 600.0, Codigo_de_Produtos__c = '302', Nome_do_Produto__c = 'Alelo Mobilidade', Valor_Unitario__c = 12.0, Nome_da_Forma_de_Pagamento__c = 'CARTAO CREDITO');
		Tarifas_Alelo__c novaTarifaAlelo2 = new Tarifas_Alelo__c(Codigo_da_Tarifa__c = 7.0, Nome_da_Tarifa__c = 'Reemissão de cartão', Valor_Medio_do_Beneficio__c = 100.0, Valor_Maximo__c = 200.0, Valor_Minimo__c = 1.0, Qtd_Min__c = 151.0 , Qtd_Max_Beneficios__c = 600.0, Codigo_de_Produtos__c = '100', Nome_do_Produto__c = 'Alelo Refeição', Valor_Unitario__c = 12.0, Nome_da_Forma_de_Pagamento__c = 'BOLETO');
		Tarifas_Alelo__c novaTarifaAlelo3 = new Tarifas_Alelo__c(Codigo_da_Tarifa__c = 2.0, Nome_da_Tarifa__c = 'Tarifa de manutenção', Valor_Medio_do_Beneficio__c = 100.0, Valor_Maximo__c = 200.0, Valor_Minimo__c = 1.0, Qtd_Min__c = 151.0 , Qtd_Max_Beneficios__c = 600.0, Codigo_de_Produtos__c = '100', Nome_do_Produto__c = 'Alelo Refeição', Valor_Unitario__c = 12.0, Nome_da_Forma_de_Pagamento__c = 'BOLETO');

		listTarifasAlelo.add(novaTarifaAlelo1);
		listTarifasAlelo.add(novaTarifaAlelo2);
		listTarifasAlelo.add(novaTarifaAlelo3);

		insert listTarifasAlelo;

		Test.startTest();
    	List<Tarifas_Alelo__c> obterTarifas = DAOTarifa.obterTarifas(100, 300, '302');
		System.assertEquals( 1, obterTarifas.size());

		List<Tarifas_Alelo__c> obterTarifasPagamento = DAOTarifa.obterTarifas(100, 450, '302', 'CARTAO CREDITO');
		System.assertEquals(2, obterTarifasPagamento.size());

		List<Tarifas_Alelo__c> obterTarifasPagamentoBoleto = DAOTarifa.obterTarifas(100, 450, '100', 'BOLETO');
		System.assertEquals(1, obterTarifasPagamentoBoleto.size());

		List<Tarifas_Alelo__c> listarTarifaAlelo = DAOTarifa.listarTarifaAlelo('Alelo Mobilidade', 'Reemissão de cartão');
		System.assertEquals(novaTarifaAlelo1.Id, listarTarifaAlelo.get(0).Id);

		List<String> listarDescricaoProduto = DAOTarifa.listarDescricaoProduto();
		System.assertEquals(listarDescricaoProduto.get(0), novaTarifaAlelo1.Nome_do_Produto__c);

		List<String> listarDescricaoTarifaPorProdutos = DAOTarifa.listarDescricaoTarifaPorProduto('Alelo Mobilidade');
		System.assertEquals(novaTarifaAlelo1.Nome_da_Tarifa__c, listarDescricaoTarifaPorProdutos.get(0));

		DAOTarifa.limparTarifas();
		List<Tarifas_Alelo__c> limparTarifas = [SELECT Id FROM Tarifas_Alelo__c];
		System.assertEquals(0, limparTarifas.size());

		Test.stopTest();
    }
}
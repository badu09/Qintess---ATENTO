public with sharing class BOImplantacao {

	public static void convertImplantacao(Map<Id, Implantacao__c> mapImplantacao)
    {
        Set<Id> setIdsImplantacao = new Set<Id>(mapImplantacao.keySet());

		BOImplantacao.inserir(setIdsImplantacao);
//        BOImplantacao.inserirContas(setIdsImplantacao);
//		BOImplantacao.inserirContatosOportunidadeProdutosAlelo(setIdsImplantacao);
	}

	@future
	static void inserir(Set<Id> setIdsImplantacao){
		BOImplantacao.inserirContas(setIdsImplantacao);
		BOImplantacao.inserirContatosOportunidadeProdutosAlelo(setIdsImplantacao);
	}

//    @future
    static void inserirContas(Set<Id> setIdsImplantacao)
    {
        List<Implantacao__c> lstImplantacao = [SELECT Id, Bairro__c, BillingCity__c, Estado_Provincia_de_entrega__c, CPF_CNPJ__c, Numero__c, Phone__c, Razao_Social__c, Rua_de_entrega__c,
                                               Telefone_2__c, Operacao__c
                                              FROM Implantacao__c
                                              WHERE Id IN : setIdsImplantacao];

        Set<String> setCNPJ = new Set<String>();
        List<Account> lstContas = new List<Account>();

		for(Implantacao__c item : lstImplantacao)
        {
			if(!setCNPJ.contains(item.CPF_CNPJ__c))
            {

                setCNPJ.add(item.CPF_CNPJ__c);
				Account conta = convertImplantacaoToAccount(item);
				lstContas.add(conta);
			}

        }

        upsert lstContas;
//		for (Account conta : lstContas) {
//			try {
//				upsert conta;
//				System.debug('Conta inserida');
//			} catch (Exception erro){
//				System.debug('Erro ao inserir a conta' + erro.getMessage());
//				System.debug('Erro na linha: ' + erro.getLineNumber());
//			}
//		}

    }

//    @future
    static void inserirContatosOportunidadeProdutosAlelo(Set<Id> setIdsImplantacao)
    {
         List<Implantacao__c> lstImplantacao = [SELECT Id, Bairro__c, BillingCity__c, Estado_Provincia_de_entrega__c, CPF_CNPJ__c, Numero__c, Phone__c, Razao_Social__c, Rua_de_entrega__c,
                                               Telefone_2__c, LastName__c, DDDCelular__c, dddfax__c, DDD__c, DDDRedidencial__c, Email__c, Fax__c, Ramal__c, Telefone__c, Tipo__c, Telefone_Residencial__c,
                                               Interlocutor_Operacao__c, Celular_Operacional__c, DDDCelular_Operacional__c, dddfax_Operacional__c, DDD_Operacional__c, Email_Operacional__c,
                                               Fax_Operacional__c, Ramal_Operacional__c, Telefone_Operacional__c, Telefone_Residencial_Operacional__c, Canal_de_Venda__c, Cobranca__c,
                                               Data_do_Cadastramento__c, Data_do_Mailing__c, DDDVendedor__c, Entrega__c, Nome_do_Vendedor__c, Sistema_de_Pedidos__c, Status__c, Telefone_Vendedor__c,
                                               Usuarios__c, VendedorRamal__c, IdCampanha__c, Operacao__c, Agencia_Debito_em_Conta__c, Agencia_Digito__c, Banco__c, Banco_Debito_em_Conta__c, Faturamento__c,
                                               Faturamento_Previsto_Implantacao__c, Forma_de_Pagamento__c, Nome_de_Produto_Alelo__c, Numero_do_Contrato__c
                                              FROM Implantacao__c
                                              WHERE Id IN : setIdsImplantacao];

        List<Contact> lstContatos = new List<Contact>();
		List<Contact> lstContatosOperacional = new List<Contact>();
        List<Opportunity> lstOportunidades = new List<Opportunity>();
		List<Produtos_Alelo__c> lstProdutosAlelo = new List<Produtos_Alelo__c>();

        for(Implantacao__c item : lstImplantacao)
        {
            lstContatos.add(convertImplantacaoToContact(item));

			if(item.Interlocutor_Operacao__c != null)
            {
                lstContatosOperacional.add(convertImplantacaoToContactOperacional(item));
            }
        }

        insert lstContatos;
//		for (Contact contato : lstContatos) {
//			try{
//				insert contato;
//				System.debug('Contato inserido');
//			} catch (Exception erro){
//				System.debug('Errro ao inserir contato: ' + erro.getMessage());
//				System.debug('Erro na linha: ' + erro.getLineNumber());
//			}
//		}
        insert lstContatosOperacional;
//		for (Contact contatoOperacional : lstContatosOperacional) {
//			try {
//				insert contatoOperacional;
//				System.debug('Contato operacional inserido');
//			} catch (Exception erro){
//				System.debug('Erro ao inserir contato operacional: ' + erro.getMessage());
//				System.debug('Erro na linha: ' + erro.getLineNumber());
//			}
//		}

        integer index = 0;

        for(Implantacao__c item : lstImplantacao)
        {
         	lstOportunidades.add(convertImplantacaoToOpportunity(item, lstContatos.get(index), lstContatosOperacional.get(index)));
            index++;
        }

        insert lstOportunidades;
//		for (Opportunity oportunidade : lstOportunidades) {
//			try{
//				insert oportunidade;
//				System.debug('Oportunidade inserida');
//			}
//			catch (Exception erro){
//				System.debug('Erro ao inserir oportunidade: ' + erro.getMessage());
//				System.debug('Erro na linha: ' + erro.getLineNumber());
//			}
//		}

        index = 0;

        for(Implantacao__c item : lstImplantacao)
        {
            lstProdutosAlelo.add(convertImplantacaoToProdutoAlelo(item, lstOportunidades.get(index)));
            index++;
        }

        insert lstProdutosAlelo;
//			for (Produtos_Alelo__c produtoAlelo : lstProdutosAlelo) {
//				try{
//					insert produtoAlelo;
//					System.debug('Produto Alelo inserido com sucesso');
//				} catch (Exception erro){
//					System.debug('Erro ao inserir Produto Alelo: ' + erro.getMessage());
//					System.debug('Erro na linha: ' + erro.getLineNumber());
//				}
//			}

    }

	public static Account convertImplantacaoToAccount(Implantacao__c implatacao)
    {
		Account objAccount = new Account();
		objAccount.Bairro__c = implatacao.Bairro__c;
		objAccount.BillingCity = implatacao.BillingCity__c;
		objAccount.BillingPostalCode = implatacao.Estado_Provincia_de_entrega__c;
		objAccount.CPF_CNPJ__c = implatacao.CPF_CNPJ__c;
		objAccount.Numero__c = implatacao.Numero__c;
		objAccount.Phone = implatacao.Phone__c;
		objAccount.Name = implatacao.Razao_Social__c;
		objAccount.BillingStreet = implatacao.Rua_de_entrega__c;
		objAccount.Telefone2__c = implatacao.Telefone_2__c;

		return objAccount;
	}

	public static Contact convertImplantacaoToContact(Implantacao__c implatacao)
    {
		Contact objContact = new Contact();

        objContact.Account = new Account(CPF_CNPJ__c = implatacao.CPF_CNPJ__c);
		objContact.LastName = implatacao.LastName__c;
		objContact.DDDCelular__c = implatacao.DDDCelular__c;
		objContact.dddfax__c = implatacao.dddfax__c;
		objContact.DDD__c = implatacao.DDD__c;
		objContact.DDDResidencial__c = implatacao.DDDRedidencial__c;
		objContact.Email = implatacao.Email__c;
		objContact.Fax = implatacao.Fax__c;
		objContact.Ramal__c = implatacao.Ramal__c;
		objContact.Telefone__c = implatacao.Telefone__c;
		objContact.Tipo__c = implatacao.Tipo__c;
		objContact.Telefone_Residencial__c = implatacao.Telefone_Residencial__c;

		return objContact;
	}

	public static Contact convertImplantacaoToContactOperacional(Implantacao__c implatacao)
    {
		Contact objContact = new Contact();

        objContact.Account = new Account(CPF_CNPJ__c = implatacao.CPF_CNPJ__c);

		objContact.LastName = implatacao.Interlocutor_Operacao__c;
		objContact.Celular__c = implatacao.Celular_Operacional__c;
		objContact.DDDCelular__c = implatacao.DDDCelular_Operacional__c;
		objContact.dddfax__c = implatacao.dddfax_Operacional__c;
		objContact.DDD__c = implatacao.DDD_Operacional__c;
		objContact.DDDResidencial__c = implatacao.DDDRedidencial__c;
		objContact.Email = implatacao.Email_Operacional__c;
		objContact.Fax = implatacao.Fax_Operacional__c;
		objContact.Ramal__c = implatacao.Ramal_Operacional__c;
		objContact.Tipo__c = 'Operacional';
		objContact.Telefone__c = implatacao.Telefone_Operacional__c;
		objContact.Telefone_Residencial__c = implatacao.Telefone_Residencial_Operacional__c;

		return objContact;
	}

	public static Opportunity convertImplantacaoToOpportunity(Implantacao__c implatacao, Contact contato, Contact contatoOperacional)
    {
		Opportunity objOpportunity = new Opportunity();
		objOpportunity.Canal_de_Venda__c = implatacao.Canal_de_Venda__c;
		objOpportunity.Cobranca__c = implatacao.Cobranca__c;
		objOpportunity.Data_do_Cadastamento__c = implatacao.Data_do_Cadastramento__c;
		objOpportunity.Data_da_Auditoria__c = Datetime.newInstance(implatacao.Data_do_Cadastramento__c, Time.newInstance(9, 0, 0, 0));
		objOpportunity.Data_do_Mailing__c = implatacao.Data_do_Mailing__c;
		objOpportunity.DDDVendedor__c = implatacao.DDDVendedor__c;
		objOpportunity.Entrega__c = implatacao.Entrega__c;
		objOpportunity.Nome_do_Vendedor__c = implatacao.Nome_do_Vendedor__c;
		objOpportunity.Operacao__c = implatacao.Operacao__c;
		objOpportunity.Sistema_de_Pedidos__c = implatacao.Sistema_de_Pedidos__c;
		objOpportunity.Status__c = implatacao.Status__c;
		objOpportunity.TelefoneVendedor__c = implatacao.Telefone_Vendedor__c;
		objOpportunity.Usuarios__c = implatacao.Usuarios__c;
		objOpportunity.Ramal__c = implatacao.VendedorRamal__c;
		objOpportunity.CloseDate = implatacao.Data_do_Cadastramento__c;
		objOpportunity.StageName = 'Auditoria Finalizada/ Transf Implantação';
		objOpportunity.Campanha__c  = 'Mailing Implantação';
		objOpportunity.Id_da_Campanha__c = implatacao.IdCampanha__c;
		objOpportunity.Telefone_Decisor__c = implatacao.DDD__c + implatacao.Phone__c;
		objOpportunity.Telefone_Operacional__c = implatacao.DDD_Operacional__c + implatacao.Telefone_Operacional__c;

        objOpportunity.Account = new Account(CPF_CNPJ__c = implatacao.CPF_CNPJ__c);
        objOpportunity.Name = Date.Today() + ' - ' + implatacao.Razao_Social__c;
        objOpportunity.Contato_da_oportunidade__c = contato.Id;

        if(implatacao.Interlocutor_Operacao__c != null)
        {
            objOpportunity.Contato_da_oportunidade_2__c = contatoOperacional.Id;
        }

		return objOpportunity;
	}

	public static Produtos_Alelo__c convertImplantacaoToProdutoAlelo(Implantacao__c implatacao, Opportunity oportunidade)
    {
		Produtos_Alelo__c objProdutosAlelo =  new Produtos_Alelo__c();

        objProdutosAlelo.Oportunidade__c = oportunidade.Id;
		objProdutosAlelo.Agencia_Debito_em_Conta__c = implatacao.Agencia_Debito_em_Conta__c;
		objProdutosAlelo.Agencia_Digito__c = Util.StringValueOf(implatacao.Agencia_Digito__c);
		objProdutosAlelo.Banco__c = getnameBank(implatacao.Banco__c);
		objProdutosAlelo.Banco_Debito_em_Conta__c = implatacao.Banco_Debito_em_Conta__c;
		objProdutosAlelo.Data_Hora_Auditoria__c = Datetime.newInstance(implatacao.Data_do_Cadastramento__c, Time.newInstance(9, 0, 0, 0));
		objProdutosAlelo.Faturamento__c = implatacao.Faturamento__c;
		objProdutosAlelo.Faturamento_Previsto_Implantacao__c = implatacao.Faturamento_Previsto_Implantacao__c;
		objProdutosAlelo.Forma_de_Pagamento__c = implatacao.Forma_de_Pagamento__c;
		objProdutosAlelo.Name = implatacao.Nome_de_Produto_Alelo__c;
		objProdutosAlelo.Numero_do_Contrato__c = implatacao.Numero_do_Contrato__c;

        objProdutosAlelo.Valor_Total__c = implatacao.Faturamento__c;


		return objProdutosAlelo;
	}

	public static String getnameBank(String numberBank)
    {
		if(numberBank == '1')
			return 'Banco do Brasil';
		else if(numberBank == '33')
			return 'Santander';
		else if(numberBank == '237')
			return 'Bradesco';
		else if(numberBank == '724')
			return 'Porto Seguro';
		else
			return '';
	}
}
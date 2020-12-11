public with sharing class BOPrepax {
    public static Boolean convertPrepax(List<Prepax__c> listPrepax){
		List<Account> listAccount = new List<Account>();
		List<Contact> listContact = new List<Contact>();
		List<Opportunity> listOpportunity = new List<Opportunity>();
		Map<String, Account> mapAccount = new Map<String, Account>();
		Integer index = 0;
		
		Set<String> setCNPJ = new Set<String>();
		
		for(Prepax__c item : listPrepax){ 
			
			if(!setCNPJ.contains(item.CNPJ__c)) {
				setCNPJ.add(item.CNPJ__c);
				Account account = convertPrepaxToAccount(item);
				listAccount.add(account);
			}
			
			listContact.add(convertPrepaxToContact(item));
				
			listOpportunity.add(convertPrepaxToOpportunity(item));
		}
		
		upsert listAccount CPF_CNPJ__c; 
		
		//Vincular as Contas aos Contatos
		index = 0;
		for(Integer i = 0; i < listPrepax.size(); i++){
			listContact[i].Account = new Account(CPF_CNPJ__c = listPrepax[i].CNPJ__c);
		}
		
		insert listContact;
		
		//Vincular as Contas e os Contatos as Oportunidade
		index = 0;
		for(Integer i = 0; i < listPrepax.size(); i++){
			listOpportunity[i].Account = new Account(CPF_CNPJ__c = listPrepax[i].CNPJ__c);
			listOpportunity[i].Contato_da_oportunidade__c = listContact[i].Id;
			listOpportunity[i].Name = 'Prepax - ' + listPrepax[i].Razao_Social__c;
		}
		
		insert listOpportunity;
		
		return true;
	}
	
	public static Account convertPrepaxToAccount(Prepax__c prepax){
		Account objAccount = new Account();
		
		objAccount.CPF_CNPJ__c = prepax.CNPJ__c;
		objAccount.Name = prepax.Razao_Social__c;
		
		return objAccount;
	}
	
	public static Contact convertPrepaxToContact(Prepax__c prepax){
		Contact objContact = new Contact();
		
		objContact.LastName = prepax.Nome_Completo__c;
		objContact.Email = prepax.Email__c;
		objContact.DDD__c = prepax.DDD1__c;
		objContact.DDDCelular__c = prepax.DDD2__c;
		objContact.Telefone_Comercial__c = prepax.Telefone_1__c;
		objContact.Telefone_Celular__c = prepax.Telefone_2__c;
		
		return objContact;
	}
	
	public static Opportunity convertPrepaxToOpportunity(Prepax__c prepax){
		Opportunity objOpportunity = new Opportunity();
		RecordType objRecordType = DAORecordType.obterPorDeveloperName('Vendas_PREPAX');
		//objOpportunity.Canal_de_Venda__c = prepax.Canal_de_Venda__c;
		//objOpportunity.Cobranca__c = prepax.Cobranca__c;
		if(objRecordType != null)
			objOpportunity.RecordTypeId = objRecordType.Id;
			
		objOpportunity.Data_Recebimento__c = prepax.Data_Recebimento__c;
		objOpportunity.Produto__c = prepax.Produto__c;
		objOpportunity.Quantidade_de_Cartoes__c = prepax.Quantidade_de_Cartoes__c;
		//objOpportunity.Entrega__c = prepax.Entrega__c; 
		objOpportunity.Deseja_Receber_Informacoes__c = prepax.Deseja_Receber_Informacoes__c;
		//objOpportunity.Operacao__c = prepax.Operacao__c;
		//objOpportunity.Sistema_de_Pedidos__c = prepax.Sistema_de_Pedidos__c;
		//objOpportunity.Status__c = prepax.Status__c;
		//objOpportunity.TelefoneVendedor__c = prepax.Telefone_Vendedor__c;
		//objOpportunity.Usuarios__c = prepax.Usuarios__c;
		//objOpportunity.Ramal__c = prepax.VendedorRamal__c;
		objOpportunity.CloseDate = Date.today();
		objOpportunity.StageName = 'Apresentação Enviada';
		objOpportunity.Campanha__c  = 'Prepax';
		if(prepax.DDD1__c != null && prepax.Telefone_1__c != null)
			objOpportunity.Telefone_Decisor__c = prepax.DDD1__c + prepax.Telefone_1__c;
		if(prepax.DDD2__c != null && prepax.Telefone_2__c != null)
			objOpportunity.Telefone_Operacional__c = prepax.DDD2__c + prepax.Telefone_2__c;
		
		return objOpportunity;
	}
}
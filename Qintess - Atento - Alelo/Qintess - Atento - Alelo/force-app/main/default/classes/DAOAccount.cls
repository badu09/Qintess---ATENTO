public with sharing class DAOAccount {
	public static Account getAccountByCNPJ(String CNPJ) {
		Account retorno;
		try {
			retorno = [SELECT Id FROM Account WHERE CPF_CNPJ__c = :CNPJ LIMIT 1];
		}
		catch(Exception e) {
			System.debug(e + '\n' + e.getStackTraceString());
		}
		return retorno;
	}

	public static Account getAccountById(String Id) {
		return [SELECT
				Id,
				Name,
				CPF_CNPJ__c,
				Ramo_de_Atividade__c,
				Codigo_CNAE__c,
				Inscricao_Municipal__c,
				Cidade__c,
				Complemento__c,
				Numero__c,
				Bairro__c,
				CEP__c,
				Estado__c,
				Endereco__c,
				Nome_Fantasia__c,
				Inscricao_Estadual__c,
				Razao_Social__c,
				NumberOfEmployees,
				Faturamento__c,
				BillingStreet,
				Quantidade_de_Funcionarios__c,
				Tipo_de_Empresa__c,
				BillingPostalCode,
				Bairro_Cobranca__c,
				Complemento_Cobranca__c,
				BillingCity,
				OwnerId,
				Owner.CPF__c,
				Secao_Ramo_de_Atividade__c,
				Divisao_Ramo_de_Atividade__c,
				Email__c,
				E_mail_Para_Envio_de_NFE__c,
				Phone,
				Telefone2__c,
				ShippingStreet,
				ShippingPostalCode,
				Forma_de_Constituicao__c ,
				Data_da_Constituicao__c,
				ShippingCity
		//City
				FROM Account
				WHERE
				Id = :Id];
	}

}
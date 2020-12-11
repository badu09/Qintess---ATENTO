public with sharing class DAOLead {
	public static List<Lead> getLeadByCampanha(String idCampanha) {
		List<Lead> retorno;
		retorno = [SELECT Id, Agendamento_Retorno__c, Nome_da_Campanha__c FROM Lead WHERE Id_da_Campanha__c = :idCampanha];
		return retorno;
	}

	public static void salvarlead(List<Lead> listaLead){
		upsert listaLead;
	}

	public static List<Lead> getLeads() {
		return [SELECT
							Id,
							Phone,
							Agendamento_Retorno__c,
							Telefone2__c,
							Telefone3__c,
							Telefone4__c,
							Telefone5__c,
							Nome_da_Campanha__c,
							Sub_Campanha__c,
							CNPJ__c,
							Name
						FROM
							Lead];
	}

	public static List<Lead> getLeadBySetId(Set<String> setId) {
		return [SELECT
							Id,
							Phone,
							Agendamento_Retorno__c,
							Telefone2__c,
							Telefone3__c,
							Telefone4__c,
							Telefone5__c,
							Nome_da_Campanha__c,
							Sub_Campanha__c,
							CNPJ__c,
							Name
						FROM
							Lead
						WHERE
							Id IN :setId];
	}

	public static Lead getLead(String idLead) {
		try {
			return [SELECT
							Id,
							Phone,
							Telefone2__c,
							Telefone3__c,
							Telefone4__c,
							Agendamento_Retorno__c,
							Telefone5__c,
							Nome_da_Campanha__c,
							Sub_Campanha__c,
							CNPJ__c,
							ConvertedOpportunityId,
							IsConverted,
							Name,
							LastName,
							Company,
							Email
						FROM
							Lead
							WHERE
								Id = :idLead];
		}
		catch(Exception e) {
			System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
			return null;
		}
	}
	
	public static List<Lead> getLeadIndicacaoBanco(String codigoBanco) {
		return [SELECT
					Id,
					Nome_da_Campanha__c,
					CNPJ__c,
					Name,
					Codigo_Banco__c,
					Codigo_Banco_Retorno_Bancos__c,
					Agendamento_Retorno__c,
					//Motivo_Retorno_Banco__c,
					//Status_Retorno_Banco__c,
					Chave_Banco__c,
					Retorno_Servico_Bancos__c
				FROM
					Lead
				WHERE
					Chave_Banco__c != null
				AND
					Data_Hora_Atualizacao_Bancos__c = TODAY
				AND
					Isconverted = false
				AND
					Codigo_Banco__c =: codigoBanco LIMIT 50];
	}
	
	public static String getQueryIndicacaoBanco(Integer codigoBanco) {
		String query = null;
    	
    	query = 'SELECT Id, Nome_da_Campanha__c, CNPJ__c, Agendamento_Retorno__c, Name, Codigo_Banco__c, Codigo_Banco_Retorno_Bancos__c, ';
    	query += 'Motivo_Retorno_Banco__c, Status_Retorno_Banco__c, Chave_Banco__c, Retorno_Servico_Bancos__c ';
		query += 'FROM Lead WHERE (RecordType.DeveloperName = \'Banco\' AND Chave_Banco__c != null ';
		query += 'AND Isconverted = false AND Codigo_Banco__c = \'' + codigoBanco + '\' AND Atualizacao_Bancos__c = false ';
		query += 'AND STATUS != \'NOVO (006)\' ';
		// query += 'AND Data_Hora_Atualizacao_Bancos__c = TODAY ';
		// query += 'AND Qtd_Tentativas_a_Realizar__c = 5)';
		query += ')';
		
		system.debug('query: ' + query);
		
		return query;
	}
    
    public static String getQueryIndicacaoBancos(Integer codigoBanco, Integer codigoBanco2, Integer codigoBanco3) {
		String query = null;
    	
    	query = 'SELECT Id, Nome_da_Campanha__c, CNPJ__c, Agendamento_Retorno__c, Name, Codigo_Banco__c, Codigo_Banco_Retorno_Bancos__c, ';
    	query += 'Motivo_Retorno_Banco__c, Status_Retorno_Banco__c, Chave_Banco__c, Retorno_Servico_Bancos__c ';
		query += 'FROM Lead WHERE (RecordType.DeveloperName = \'Banco\' AND Chave_Banco__c != null ';
		query += 'AND Isconverted = false AND (Codigo_Banco__c = \'' + codigoBanco + '\' OR Codigo_Banco__c = \'' + codigoBanco2 + '\' OR Codigo_Banco__c = \'' + codigoBanco3 + '\')  AND Atualizacao_Bancos__c = false ';
		query += 'AND STATUS != \'NOVO (006)\' ';
		// query += 'AND Data_Hora_Atualizacao_Bancos__c = TODAY ';
		// query += 'AND Qtd_Tentativas_a_Realizar__c = 5)';
		query += ')';
		
		system.debug('query: ' + query);
		
		return query;
	}
    
}
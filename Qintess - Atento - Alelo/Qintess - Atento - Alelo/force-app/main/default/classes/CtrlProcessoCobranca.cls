global without sharing class CtrlProcessoCobranca {

	public CtrlProcessoCobranca(ApexPages.StandardController controller){

	}

	@RemoteAction
	global static RetornoModel implantar(Id idListCobranca, Id idOportunidade) {
		System.debug('idListCobranca: ' + idListCobranca);
		System.debug('idOportunidade: ' + idOportunidade);
		RetornoModel model = new RetornoModel();
		Profile perfil = DAOProfile.getProfileById(UserInfo.getProfileId());

		model.idOportunidade = idOportunidade;

		try {
			if (!perfil.Name.equalsIgnoreCase('Administrador do sistema')) {
				Opportunity oportunidadePrincipal = DAOOpportunity.getOpportunityById(idOportunidade);
				system.debug('oportunidadePrincipal: ' + oportunidadePrincipal);

				model.sucesso = true;

				List<Cobranca__c> lProcessoCobranca = new List<Cobranca__c>();

				for (Cobranca__c item : DAOCobranca.getCobrancaByAccountId(oportunidadePrincipal.Account.Id)) {

					system.debug('item Cobrança: '+item);
					Cobranca__c novaCobranca = new Cobranca__c();

					novaCobranca.Id = item.Id;

					if (item.OwnerId != UserInfo.getUserId()) {
						novaCobranca.OwnerId = UserInfo.getUserId();
					}

					novaCobranca.Status__c = 'Cobranca';

					lProcessoCobranca.add(novaCobranca);


					if (!lProcessoCobranca.isEmpty()) {
						system.debug('lProcessoCobranca: ' + json.serialize(lProcessoCobranca));
						update lProcessoCobranca;
					}
				}
			}

		} catch (DmlException ex) {
			system.debug('DmlException: ' + ex.getLineNumber());
			system.debug('DmlException: ' + ex.getStackTraceString());
			system.debug('DmlException: ' + ex.getTypeName());
			system.debug('DmlException: ' + ex.getCause());
			system.debug('DmlException: ' + ex.getMessage());

			model.sucesso = false;
			model.mensagemErro = ex.getDmlMessage(0);
		} catch (Exception ex) {
			system.debug('Exception: ' + ex.getLineNumber());
			system.debug('Exception: ' + ex.getStackTraceString());
			system.debug('Exception: ' + ex.getTypeName());
			system.debug('Exception: ' + ex.getCause());
			system.debug('Exception: ' + ex.getMessage());

			model.sucesso = false;
			model.mensagemErro = ex.getMessage();
		}

		return model;
	}

	global class RetornoModel {
		global Id idOportunidade {get; set;}
		global Boolean sucesso {get; set;}
		global String mensagemErro {get; set;}

		global RetornoModel() {

		}
	}
}
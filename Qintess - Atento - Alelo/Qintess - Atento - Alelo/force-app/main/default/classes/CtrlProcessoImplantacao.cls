global without sharing class CtrlProcessoImplantacao {
        
    public CtrlProcessoImplantacao(ApexPages.StandardController controller){
   			
    }
    
    @RemoteAction
	global static RetornoModel implantar(Id idProcessoImplantacao, Id idOportunidade) {
		Profile perfil = DAOProfile.getProfileById(UserInfo.getProfileId());
		
		RetornoModel model = new RetornoModel();
		
		model.idOportunidade = idOportunidade;
		
		try {
			if(!perfil.Name.equalsIgnoreCase('Administrador do sistema')) {
				Opportunity oportunidadePrincipal = DAOOpportunity.getOpportunityById(idOportunidade);

				if (oportunidadePrincipal.Implantador_Atribuido__c != null &&
								oportunidadePrincipal.Implantador_Atribuido__c != Userinfo.getUserId()) {

					String nomeImplantador = oportunidadePrincipal.Implantador_Atribuido__r.Name;

					model.sucesso = false;

					if (oportunidadePrincipal.Total_Fidelizado__c > 0) {
						model.mensagemErro =
								'Favor contatar o seu coordenador. Esta oportunidade está fidelizada ao implantador ' +
								nomeImplantador;
					} else {
						model.mensagemErro =
								'Favor contatar o seu coordenador. Esta oportunidade está em atendimento pelo implantador ' +
								nomeImplantador;
					}
				} else {

					Set<String> setFase = new Set<String>();

					setFase.add('Auditoria Finalizada/ Transf Implantação');
					setFase.add('Devolvido Para Implantar');
					setFase.add('Em Implantação');

					RecordType tipoRegistro = DAORecordType.obterPorDeveloperName('Implatacao', 'Order');

					List<Opportunity> lOportunidade = new List<Opportunity>();
					List<Order> lProcessoImplantacao = new List<Order>();

					for (Order item : DAOOrder.getOrderByAccountId(oportunidadePrincipal.Account.Id)) {
						if (setFase.contains(item.Opportunity.StageName)) {

							Opportunity oportunidade = new Opportunity();

							oportunidade.Id = item.Opportunity.Id;
							oportunidade.Implantador_Atribuido__c = Userinfo.getUserId();
							oportunidade.StageName = 'Em Implantação';
							oportunidade.Processo_Implantacao__c = item.Id;

							lOportunidade.add(oportunidade);

							Order processoImplantacao = new Order();

							processoImplantacao.Id = item.Id;

							if (item.OwnerId != UserInfo.getUserId()) {
								processoImplantacao.OwnerId = UserInfo.getUserId();
							}

							processoImplantacao.Status = 'Implantacao';
							processoImplantacao.RecordTypeId = tipoRegistro.Id;

							lProcessoImplantacao.add(processoImplantacao);
						}
					}

					if (!lOportunidade.isEmpty()) {
						system.debug('lOportunidade: ' + json.serialize(lOportunidade));
						update lOportunidade;
					}

					if (!lProcessoImplantacao.isEmpty()) {
						system.debug('lProcessoImplantacao: ' + json.serialize(lProcessoImplantacao));
						update lProcessoImplantacao;
					}

					model.sucesso = true;
				}
			}
		}
    	catch(DmlException ex) {
    		system.debug('DmlException: ' + ex.getLineNumber());
            system.debug('DmlException: ' + ex.getStackTraceString());
            system.debug('DmlException: ' + ex.getTypeName());
            system.debug('DmlException: ' + ex.getCause());
            system.debug('DmlException: ' + ex.getMessage());
            
            model.sucesso = false;
            model.mensagemErro = ex.getDmlMessage(0);
		}
    	catch(Exception ex) {
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
	}
}
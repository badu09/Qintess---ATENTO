public class BOOlos {
	private static Map<Id, Lead> mLead;
	private static Map<Id, Order> mOrder;
	public static void getCallData(Datetime dataIni, Datetime dataFim) {
		List<String> IdDataProcessedList= new List<String>();
		Map<String, TabulacoesNovo__c> mTabulacao = TabulacoesNovo__c.getAll();
		WSMailingCommand.WSMailingCommandSoap servico = new WSMailingCommand.WSMailingCommandSoap();
		servico.timeout_x = 120000;
		WSMailingCommand.ArrayOfCallDataSummary getCallData = servico.GetCallData('bsi', true, String.valueOf(dataIni), String.valueOf(dataFim));
		
		system.debug('getCallData: ' + JSON.serialize(getCallData));
		
		if(getCallData != null) {
			List<WSMailingCommand.CallDataSummary> dados = getCallData.CallDataSummary;
			Map<Id, Lead> mLeadToUpdate = new Map<Id, Lead>();
			Map<Id, Opportunity> mOpportunityToUpdate = new Map<Id, Opportunity>();

			Map<Integer, TabulacoesNovo__c> tabulacaoMap = preencherTabulacao(mTabulacao);
			System.debug('dados: ' + dados);
			if(dados != null) {
				popularDadosObject(dados);

				for(WSMailingCommand.CallDataSummary item : dados) {
					try {
						TabulacoesNovo__c tab = tabulacaoMap.get(item.DispositionId);
						Id objectId = item.CustomerId;
						if (String.valueOf(objectId.getSObjectType()).equalsIgnoreCase('lead')) {
							Lead lead;
							if(mLeadToUpdate.containsKey(objectId)) {
								lead = mLeadToUpdate.get(objectId);
							}
							else {
								lead = mLead.get(objectId);
							}

							if (item.PhoneNumber.equalsIgnoreCase(lead.phone)) {
								lead.CallID1__c = item.CallId;
								lead.Status1__c = tab.Status_1__c;
								lead.Tabulacao1__c = tab.Tabulacao_1__c;

								mLeadToUpdate.put(lead.Id, lead);
							} else if (item.phoneNumber.equalsIgnoreCase(lead.Telefone2__c)) {
								lead.CallID2__c = item.CallId;
								lead.Status2__c = tab.Status_1__c;
								lead.Tabulacao2__c = tab.Tabulacao_1__c;

								mLeadToUpdate.put(lead.Id, lead);
							} else if (item.phoneNumber.equalsIgnoreCase(lead.Telefone3__c)) {
								lead.CallID3__c = item.CallId;
								lead.Status3__c = tab.Status_1__c;
								lead.Tabulacao3__c = tab.Tabulacao_1__c;

								mLeadToUpdate.put(lead.Id, lead);
							} else if (item.phoneNumber.equalsIgnoreCase(lead.Telefone4__c)) {
								lead.CallID4__c = item.CallId;
								lead.Status4__c = tab.Status_1__c;
								lead.Tabulacao4__c = tab.Tabulacao_1__c;

								mLeadToUpdate.put(lead.Id, lead);
							} else if (item.phoneNumber.equalsIgnoreCase(lead.Telefone5__c)) {
								lead.CallID5__c = item.CallId;
								lead.Status5__c = tab.Status_1__c;
								lead.Tabulacao5__c = tab.Tabulacao_1__c;

								mLeadToUpdate.put(lead.Id, lead);
							}
						} else if (String.valueOf(objectId.getSObjectType()).equalsIgnoreCase('order')) {
							Order ordem = mOrder.get(objectId);
							Opportunity opp;
							if(ordem.OpportunityId != null) {
								opp = ordem.Opportunity;
							}

							if (tab.FaseOportunidade__c != null && tab.FaseOportunidade__c != '')
								opp.StageName = tab.FaseOportunidade__c;
							opp.Motivo_Detalhado__c = tab.Motivo_Detalhado__c;
							if (item.PhoneNumber.equalsIgnoreCase(ordem.Opportunity.Telefone_Decisor__c)) {
								opp.Status1__c = tab.Status_1__c;
								opp.Tabulacao1__c = tab.Tabulacao_1__c;
							} else if (item.phoneNumber.equalsIgnoreCase(ordem.Opportunity.Telefone_Operacional__c)) {
								opp.Status2__c = tab.Status_1__c;
								opp.Tabulacao2__c = tab.Tabulacao_1__c;
							}
							mOpportunityToUpdate.put(opp.Id, opp);
						}
						IdDataProcessedList.add(String.valueOf(item.CallId));
					}
					catch(StringException e) {
						System.debug('Exception Tratada: Customer Id Invalido');
					}
					catch(Exception e) {
						System.debug('Exception Tratada: ' +e + '\n' + e.getStackTraceString());
					}
				}
			}
			Database.update(((List<Lead>)mLeadToUpdate.values()), false);
			Database.update(((List<Opportunity>)mOpportunityToUpdate.values()), false);

			setCallDataProcessed(IdDataProcessedList);
		}
	}

	public static void popularDadosObject(List<WSMailingCommand.CallDataSummary> dados) {
		Set<String> sLead = new Set<String>();
		Set<String> sOrder = new Set<String>();
		for(WSMailingCommand.CallDataSummary item : dados) {
			try {
				Id objectId = item.CustomerId;
				if (String.valueOf(objectId.getSObjectType()).equalsIgnoreCase('lead'))
					sLead.add(objectId);
				else if (String.valueOf(objectId.getSObjectType()).equalsIgnoreCase('order'))
					sOrder.add(objectId);
			}
			catch (StringException e) {
				System.debug('Exception Tratada: Customer ID Inválido');
			}
		}
		mLead = new Map<Id, Lead>(DAOLead.getLeadBySetId(sLead));
		mOrder = new Map<Id, Order>(DAOOrder.getOrderBySetId(sOrder));
	}

	public static void setCallDataProcessed(List<String> callIdList) {
		WSMailingCommand.WSMailingCommandSoap servico = new WSMailingCommand.WSMailingCommandSoap();
		WSMailingCommand.ArrayOfString arrayString = new WSMailingCommand.ArrayOfString();
		arrayString.string_x = callIdList;
		Boolean retorno = servico.setCallDataProcessedList(arrayString);
		JSON.serialize('setCallDataProcessed: ' + retorno);
	}
	
	public static Boolean setCallDataProcessed(Integer callId) {
		WSMailingCommand.WSMailingCommandSoap servico = new WSMailingCommand.WSMailingCommandSoap();
		Boolean retorno = servico.setCallDataProcessed(callId);
		JSON.serialize('setCallDataProcessed: ' + retorno);
		return retorno;
	}

	public static Map<Integer, TabulacoesNovo__c> preencherTabulacao(Map<String, TabulacoesNovo__c> mTabulacao) {
		Map<Integer, TabulacoesNovo__c> retorno = new Map<Integer, TabulacoesNovo__c>();
		for(String item : mTabulacao.keySet()) {
			retorno.put(Integer.valueOf(mTabulacao.get(item).DispositionID__c), mTabulacao.get(item));
		}
		return retorno;

	}

	public class LeadProcessado {
		public Lead lead { get; set; }
		public Boolean processado { get; set; }

		public LeadProcessado(Lead lead, Boolean processado) {
			this.lead = lead;
			this.processado = processado;
		}
	}


}
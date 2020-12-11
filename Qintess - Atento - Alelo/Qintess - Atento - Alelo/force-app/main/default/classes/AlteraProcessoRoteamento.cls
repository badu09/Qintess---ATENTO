public class AlteraProcessoRoteamento {

	public static void atualizaRoteamentoTabulacaoAlelo(List<Produtos_Alelo__c> produtosAleloList){
		Map<String,Id> mapFilas = new Map<String, Id>();
		List<QueueSobject> filasM = DAOQueueSobject.obterTodasFilasConceitoM();
		for (QueueSobject fila : filasM) {
			mapFilas.put(fila.Queue.DeveloperName,fila.QueueId);
		}
		List<Order> roteamentoAtt = new List<Order>();
		List<Order> roteamentoDel = new List<Order>();
		for (Produtos_Alelo__c produto : produtosAleloList){
			if (TriggerUtils.isChanged(produto, Produtos_Alelo__c.Tabulacao_Pai_Implantacao__c)){

				System.debug(produto.Oportunidade__c);
				List<Order> roteamentos = [SELECT Id, OwnerId, Name, Opportunity.Implantador_Atribuido__c, Conceito__c FROM Order WHERE OpportunityId = :produto.Oportunidade__c];
				if (roteamentos.size() > 0) {
					Order roteamento = roteamentos.get(0);
					roteamento.Opportunity.Implantador_Atribuido__c = null;
					if (produto.Tabulacao_Pai_Implantacao__c.equalsIgnoreCase('IMPLANTADO')) {
						roteamentoDel.add(roteamento);
					} else {
						String nomeFila =
								retornaNomeFilaCorreta(roteamento.Conceito__c, produto.Tabulacao_Pai_Implantacao__c);
						if (mapFilas.get(nomeFila) != null) {
							roteamento.OwnerId = mapFilas.get(nomeFila);
							roteamentoAtt.add(roteamento);
						}

					}
				}
			}
		}

		update roteamentoAtt;
	}


	public static String retornaNomeFilaCorreta(String filaM, String tabulacao){
		System.debug('Conceito Implantacao: '+filaM);
		String nomeFila = 'ALELO_IMPLANTACAO_';
		if (filaM.equalsIgnoreCase('NOVOS')) filaM = 'M0';


		if (!filaM.equalsIgnoreCase('ACIMA M3')) {
			nomeFila += filaM+'_';
			System.debug('Tabulacao: '+tabulacao);

			if (tabulacao == null){
				nomeFila += 'NOVOS';
			} else if (tabulacao.equalsIgnoreCase('CONTATO AGENDADO') || tabulacao.equalsIgnoreCase('SEM PREVISÃO') ||
					tabulacao.equalsIgnoreCase('RENEGOCIAR') || tabulacao.equalsIgnoreCase('DESEJA CANCELAR')) {
				nomeFila += 'CONTATO_AGENDADO';
			} else if (tabulacao.equalsIgnoreCase('EM IMPLANTAÇÃO')) {
				nomeFila += 'EM_IMPLANTACAO';
			} else if (tabulacao.equalsIgnoreCase('NÃO CONSEGUE CONTATO')){
				nomeFila += 'SEM_CONTATO';
			}
		} else {
			nomeFila += 'MAIOR_M3_TODOS';
		}

		System.debug('Nome fila: '+nomeFila);

		return nomeFila;
	}

}
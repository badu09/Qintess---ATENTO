public without sharing class BatchAlterarFilasConceitoM implements Database.Batchable<Opportunity>, Database.Stateful {
	Map<String,Id> mapFilas;
	Integer qttRegistros = 0;
	Id idFilaImplantado;
	Id pricebookIdPadrao;
	public static String CRON_EXP = '0 {0} {1} ? * *';

	public BatchAlterarFilasConceitoM() {
		mapFilas = new Map<String, Id>();
	}

	public List<Opportunity> start(Database.BatchableContext BC) {

		List<Group> filasM = DAOQueueSobject.obterFilasConceitoM();
		for (Group fila : filasM) {
			mapFilas.put(fila.DeveloperName,fila.Id);
		}

		idFilaImplantado = DAOQueueSobject.getGroupMemberByDeveloperName('ALELO_IMPLANTACAO_IMPLANTADO').QueueId;

		List<Opportunity> retorno = [SELECT Id, Conceito_Implantacao__c, Processo_Implantacao__c FROM Opportunity WHERE RecordType.DeveloperName = 'Implantacao' AND Processo_Implantacao__c != null AND Processo_Implantacao__r.Ultimo_mes_FilaM__c != 0 AND Processo_Implantacao__r.Ultimo_mes_FilaM__c != :Date.today().month() LIMIT 40000];

		qttRegistros = retorno.size();

		System.debug(qttRegistros);

		return retorno;
	}

	public void execute(Database.BatchableContext BC, List<Opportunity> opps) {
		Map<Id,Order> ordersToUpdt = new Map<Id, Order>();

		Set<Id> setIdOpp = new Set<Id>();
		Set<Id> setIdRot = new Set<Id>();
		for (Opportunity opp : opps){
			setIdOpp.add(opp.Id);
			setIdRot.add(opp.Processo_Implantacao__c);
		}

		Map<Id,Order> mapOppOrder = new Map<Id, Order>();
		List<Order> lstRoteamento = [SELECT Id, OwnerId, Status, Pricebook2Id FROM Order WHERE Id in : setIdRot];
		for (Order roteamento : lstRoteamento) {
			mapOppOrder.put(roteamento.Id,roteamento);
		}

		Map<Id,List<Produtos_Alelo__c>> mapLstProdutos = new Map<Id, List<Produtos_Alelo__c>>();
		List<Produtos_Alelo__c> prods = [SELECT Id,Oportunidade__c, Tabulacao_Pai_Implantacao__c, Implantador__c FROM Produtos_Alelo__c WHERE Oportunidade__c in :setIdOpp];
		for (Produtos_Alelo__c prod : prods) {
			if(!mapLstProdutos.containsKey(prod.Oportunidade__c)){
				mapLstProdutos.put(prod.Oportunidade__c,new List<Produtos_Alelo__c>());
			}
			mapLstProdutos.get(prod.Oportunidade__c).add(prod);
		}

		Map<Id,Id> mapPedidoFilaCorreta = new Map<Id, Id>();

		for (Opportunity opp : opps){
			Order roteamento = mapOppOrder.get(opp.Processo_Implantacao__c);

			String conceitoImplantacao = opp.Conceito_Implantacao__c;

			String tabulacao = null;
			if (mapLstProdutos.get(opp.Id)!= null && !mapLstProdutos.get(opp.Id).isEmpty()) {
				tabulacao = mapLstProdutos.get(opp.Id).get(0).Tabulacao_Pai_Implantacao__c;
			}

			if('CONTRATO TESTE'.equalsIgnoreCase(tabulacao) || 'AGUARDANDO RETORNO ALELO'.equalsIgnoreCase(tabulacao)){
				roteamento.Ultimo_mes_FilaM__c = 0;
				ordersToUpdt.put(roteamento.Id,roteamento);
				continue;
			}

			if (tabulacao == null || (!tabulacao.equalsIgnoreCase('IMPLANTADO') && !roteamento.Status.equalsIgnoreCase('Finalizado'))) {
				String nomeNovaFila = AlteraProcessoRoteamento.retornaNomeFilaCorreta(conceitoImplantacao, tabulacao);
				System.debug('nomeNovaFila: ' + nomeNovaFila);
				if(mapFilas.get(nomeNovaFila) != null){
					System.debug('IdRoteamento: ' + roteamento.Id + '> Id nova fila: ' + mapFilas.get(nomeNovaFila));
					roteamento.OwnerId = mapFilas.get(nomeNovaFila);
					roteamento.Ultimo_mes_FilaM__c = Date.today().month();
					ordersToUpdt.put(roteamento.Id,roteamento);
					System.debug('roteamento.OwnerId : ' + roteamento.OwnerId );
					mapPedidoFilaCorreta.put(roteamento.Id,mapFilas.get(nomeNovaFila));
				}
			} else {
				System.debug('IdRoteamento: ' + roteamento.Id + '> Id nova fila: ' + idFilaImplantado);
				roteamento.OwnerId = idFilaImplantado;
				roteamento.Ultimo_mes_FilaM__c = 0;
				ordersToUpdt.put(roteamento.Id,roteamento);
				System.debug('roteamento.OwnerId : ' + roteamento.OwnerId );
				mapPedidoFilaCorreta.put(roteamento.Id,idFilaImplantado);
			}

		}

		System.debug(ordersToUpdt);
		System.debug('Quantidade de registros: ' + ordersToUpdt.size());

		Database.SaveResult[] srList = Database.update(ordersToUpdt.values(), false);

		Integer qtErros = 0;
		for (Database.SaveResult result : srList) {
			if(!result.isSuccess()){
				qtErros ++;
				System.debug(JSON.serialize(result.getErrors()));
				System.debug('Id pedido erro: ' + result.getId());
				System.debug('detalhe erro: ' + result.errors.toString());

			}
		}
		System.debug('Sucesso: ' + (ordersToUpdt.size()-qtErros));
		System.debug('Erro: ' + qtErros);

		List<Order> lstPedidosErro = [SELECT Id FROM Order WHERE Id in : ordersToUpdt.keySet() AND (Ultimo_mes_FilaM__c = NULL OR  Ultimo_mes_FilaM__c != :Date.today().month())];

		List<GerarCsvFilasM.PedidoFila> lstPedidosFila = new List<GerarCsvFilasM.PedidoFila>();

		for (Order pedidoErro : lstPedidosErro) {
			lstPedidosFila.add(new GerarCsvFilasM.PedidoFila(pedidoErro.Id,mapPedidoFilaCorreta.get(pedidoErro.Id)));
		}

		GerarCsvFilasM.enviarCSVEmail(lstPedidosFila);
	}

	public void finish(Database.BatchableContext BC) {

		System.debug(qttRegistros);

		if (qttRegistros == 40000){
			BatchAlterarFilasConceitoM scheduleAtualizarIndicacaoBB = new BatchAlterarFilasConceitoM();

			Database.executeBatch(scheduleAtualizarIndicacaoBB);
		}

	}
}
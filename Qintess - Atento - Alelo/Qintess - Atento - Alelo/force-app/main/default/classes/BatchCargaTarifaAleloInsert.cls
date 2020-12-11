/**
 * Created by re035946 on 12/03/2019.
 */
global class BatchCargaTarifaAleloInsert implements Database.Batchable<sObject>, Database.AllowsCallouts {

	private Carga_Tarifa_Alelo__c cargaTarifaAlelo { get; set;}

	global BatchCargaTarifaAleloInsert(Carga_Tarifa_Alelo__c cargaTarifaAlelo) {
		this.cargaTarifaAlelo = cargaTarifaAlelo;
	}

	global System.Iterable<sObject> start(Database.BatchableContext jobId) {
		String query = 'SELECT Codigo_Produto__c,Codigo_Tarifa__c,Id,Name,Produto__c,Tarifa__c, FormaPagamento__c FROM Configuracao_Carga_Tarifa_Alelo__c';

		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext BC, List<Configuracao_Carga_Tarifa_Alelo__c> scope) {
		List<TOCargaTarifaAlelo> lTOCargaTarifaAlelo = new List<TOCargaTarifaAlelo>();

		for(Configuracao_Carga_Tarifa_Alelo__c item : scope) {

			for(String formaPagamento : item.FormaPagamento__c.split(';')) {

				TOCargaTarifaAlelo toCargaTarifaAlelo = new TOCargaTarifaAlelo();

				Detalhe_Carga_Tarifa_Alelo__c detalheCargaTarifaAlelo = new Detalhe_Carga_Tarifa_Alelo__c();

				detalheCargaTarifaAlelo.Name = 'TARIFA: ' + String.valueOf(item.Codigo_Tarifa__c.setScale(0)) + ' / PRODUTO: ' + String.valueOf(item.Codigo_Produto__c.setScale(0));
				detalheCargaTarifaAlelo.Carga_Tarifa_Alelo__c = this.cargaTarifaAlelo.Id;
				detalheCargaTarifaAlelo.Data_Inicio__c = Datetime.now();
				detalheCargaTarifaAlelo.Codigo_Produto__c = item.Codigo_Produto__c;
				detalheCargaTarifaAlelo.Produto__c = item.Produto__c;
				detalheCargaTarifaAlelo.Codigo_Tarifa__c = item.Codigo_Tarifa__c;
				detalheCargaTarifaAlelo.Tarifa__c = item.Tarifa__c;

				String comunicacaoProduto;

				if(item.Codigo_Produto__c != 301 && item.Codigo_Produto__c != 302) {
					comunicacaoProduto = '1';
				}
				else {
					comunicacaoProduto = '16';
				}

				TOTarifa toTarifa = new TOTarifa(String.valueOf(item.Codigo_Produto__c.setScale(0)),
						item.Produto__c,
						String.valueOf(item.Codigo_Tarifa__c.setScale(0)),
						item.Tarifa__c,
						comunicacaoProduto,
						formaPagamento);

				toCargaTarifaAlelo.toTarifaRetorno = BOTarifa.carregarTarifaRetorno(toTarifa);
				System.debug('toCargaTarifaAlelo.toTarifaRetorno: ' + JSON.serialize(toCargaTarifaAlelo.toTarifaRetorno));

				detalheCargaTarifaAlelo.Data_Fim__c = Datetime.now();

				toCargaTarifaAlelo.detalheCargaTarifaAlelo = detalheCargaTarifaAlelo;

				lTOCargaTarifaAlelo.add(toCargaTarifaAlelo);
			}
		}

		for(TOCargaTarifaAlelo item : lTOCargaTarifaAlelo) {

			TOTarifaRetorno toTarifaRetorno = item.toTarifaRetorno;
			Detalhe_Carga_Tarifa_Alelo__c detalheCargaTarifaAlelo = item.detalheCargaTarifaAlelo;

			detalheCargaTarifaAlelo.Registro_processado__c = 0;
			detalheCargaTarifaAlelo.Registro_com_sucesso__c = 0;
			detalheCargaTarifaAlelo.Registro_com_erro__c = 0;

			if(toTarifaRetorno != null && toTarifaRetorno.sucesso) {
				detalheCargaTarifaAlelo.Registro_processado__c = item.toTarifaRetorno.lTarifaAlelo.size();

				List<Database.SaveResult> lSaveResult = Database.insert(item.toTarifaRetorno.lTarifaAlelo, false);

				for(Database.SaveResult sr : lSaveResult) {
					if(sr.isSuccess()) {
						detalheCargaTarifaAlelo.Registro_com_sucesso__c++;
					}
					else {
						detalheCargaTarifaAlelo.Registro_com_erro__c++;
						detalheCargaTarifaAlelo.Retorno_servico__c = sr.getErrors()[0].getMessage();
					}
				}
			}
			else {
				detalheCargaTarifaAlelo.Registro_processado__c = 1;
				detalheCargaTarifaAlelo.Registro_com_erro__c = 1;

				detalheCargaTarifaAlelo.Retorno_servico__c = toTarifaRetorno.retorno;
			}

			insert detalheCargaTarifaAlelo;
			try {
				List<Attachment> lAttachment = new List<Attachment>();

				lAttachment.add(new Attachment(Name = 'Request.txt',
						Body = Blob.valueOf(toTarifaRetorno.bodyRequest),
						ParentId = detalheCargaTarifaAlelo.Id));

				lAttachment.add(new Attachment(Name = 'Response.txt',
						Body = Blob.valueOf(toTarifaRetorno.bodyResponse),
						ParentId = detalheCargaTarifaAlelo.Id));

				insert lAttachment;
			}
			catch(Exception e) {
				System.debug('Exception: ' + e + '\n' + e.getStackTraceString() + '\n' + 'detalheCargaTarifaAlelo: ' + JSON.serialize(detalheCargaTarifaAlelo));
				// detalheCargaTarifaAlelo.Retorno_servico__c = e + '';
				// update detalheCargaTarifaAlelo;

			}
		}
	}

	global Void finish(Database.BatchableContext jobId) {
		this.cargaTarifaAlelo = DAOCargaTarifaAlelo.obterCargaTarifaAlelo(this.cargaTarifaAlelo.Id);

		if(this.cargaTarifaAlelo.Registro_processado__c == this.cargaTarifaAlelo.Registro_com_sucesso__c) {
			this.cargaTarifaAlelo.Status__c = 'Finalizado com sucesso';
		}
		else {
			this.cargaTarifaAlelo.Status__c = 'Erro no processamento';
		}

		this.cargaTarifaAlelo.Data_Fim__c = Datetime.now();

		update this.cargaTarifaAlelo;
	}
}
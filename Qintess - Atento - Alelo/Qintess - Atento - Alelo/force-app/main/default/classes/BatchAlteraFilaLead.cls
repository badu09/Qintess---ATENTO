public class BatchAlteraFilaLead implements Database.Batchable<SObject>, Database.stateful{

	Integer limite;

	public BatchAlteraFilaLead(Integer limite){
		this.limite = limite;
	}

	public Database.QueryLocator start(Database.BatchableContext param1) {
		Id recTypeId = DAORecordType.obterPorDeveloperName('Banco', 'Lead').Id;
		String query = 'SELECT Id, OwnerId, Codigo_Banco__c, IsConverted, ConvertedAccountId FROM Lead WHERE RecordTypeId = \''+recTypeId+'\' AND Codigo_Banco__c != null AND Status != \'NÃO TEM INTERESSE (005)\'';

		if (limite > 0){
			query+=' LIMIT '+limite;
		}

		return Database.getQueryLocator(query);
	}

	public void execute(Database.BatchableContext param1, List<SObject> param2) {
		List<Lead> leadsToUpdt = new List<Lead>();

		Id ilhaBrad = DAOQueueSobject.getGroupMemberByDeveloperName('Ilha_Bancos_Bradesco').QueueId;
		Id ilhaBB = DAOQueueSobject.getGroupMemberByDeveloperName('Ilha_Bancos_Banco_do_Brasil').QueueId;

		Map<Id, List<Opportunity>> accOppList = new Map<Id, List<Opportunity>>();

		for(SObject so : param2){
			Lead l = (Lead) so;
			System.debug(l);
			if (l.IsConverted){
				accOppList.put(l.ConvertedAccountId, new List<Opportunity>());
			}
		}

		List<Opportunity> oppList = [SELECT Id, AccountId FROM Opportunity WHERE AccountId IN :accOppList.keySet() AND StageName IN ('Venda Confirmada','Auditoria Finalizada/ Transf Implantação','Devolvido Para Implantar','Em Implantação','Implantação Concluída')];

		for (Opportunity opp : oppList){
			accOppList.get(opp.AccountId).add(opp);
		}


		for (SObject so : param2){
			Lead l = (Lead) so;

			if (l.IsConverted){
				if (accOppList.get(l.ConvertedAccountId).size() > 0){
					break;
				}
			}

			if (l.Codigo_Banco__c == '1'){
				l.OwnerId = ilhaBB;
				System.debug('BB');
			} else if (l.Codigo_Banco__c == '237'){
				l.OwnerId = ilhaBrad;
				System.debug('BRAD');
			}

			leadsToUpdt.add(l);
		}

		update leadsToUpdt;

	}

	public void finish(Database.BatchableContext param1) {
	}


}
public class BatchExpurgoTempoOperador implements Database.Batchable<Tempo_Operador__c> {

	public List<Tempo_Operador__c> start(Database.BatchableContext BC) {
		Datetime data = Datetime.now().addYears(-1);

		return [SELECT Id FROM Tempo_Operador__c WHERE CreatedDate < :data];
	}

	public void execute(Database.BatchableContext BC, List<Tempo_Operador__c> lst) {
		Database.delete(lst);
	}

	public void finish(Database.BatchableContext BC) {

	}

}
public class BatchExpurgo implements Database.Batchable<sObject> {

	String objectAPI;

	public BatchExpurgo(String objectAPI) {
		this.objectAPI = objectAPI;
	}

	public List<sObject> start(Database.BatchableContext BC) {
		Try {
			Datetime data = Datetime.now().addYears(-1);

			String query = 'SELECT Id FROM ' + objectAPI + ' WHERE CreatedDate < ' + String.valueOf(data);

			return Database.query(query);
		} catch (Exception ex){
			return new List<sObject>();
		}
	}

	public void execute(Database.BatchableContext BC, List<sObject> lst) {
		Database.delete(lst);
	}

	public void finish(Database.BatchableContext BC) {
		switch on objectAPI{
			when 'EmailMessage' {
				Database.executeBatch(new BatchExpurgo('Tempo_Operador__c'));
			}
			when 'Tempo_Operador__c' {
				Database.executeBatch(new BatchExpurgo('Tarifas_Carrinho__c'));
			}
			when 'Tarifas_Carrinho__c' {}
		}
	}
}
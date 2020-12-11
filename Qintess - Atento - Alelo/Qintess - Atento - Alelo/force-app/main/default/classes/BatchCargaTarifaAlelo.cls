global class BatchCargaTarifaAlelo implements Database.Batchable<sObject>, Database.AllowsCallouts {
	
	private Carga_Tarifa_Alelo__c cargaTarifaAlelo { get; set;}
    
    global BatchCargaTarifaAlelo() {
    	
    	this.cargaTarifaAlelo = new Carga_Tarifa_Alelo__c();
    	
    	this.cargaTarifaAlelo.Data_Inicio__c = Datetime.now();
    	this.cargaTarifaAlelo.Name = 'Carga tarifas Alelo - ' + this.cargaTarifaAlelo.Data_Inicio__c.format('dd/MM/yyyy HH:mm:ss');
    	this.cargaTarifaAlelo.Status__c = 'Em processamento';
    	
    	insert this.cargaTarifaAlelo;
    }  
    
    global List<Tarifas_Alelo__c> start(Database.BatchableContext BC){
    	Set<String> setProdutoId = DAOConfiguracaoCargaTarifaAlelo.listarCodigoProduto();

    	return [SELECT Id FROM Tarifas_Alelo__c WHERE Codigo_de_Produtos__c IN :setProdutoId AND Nome_da_Forma_de_Pagamento__c != 'CARTAO CREDITO'];
    }

	public Void execute(Database.BatchableContext jobId, List<sObject> recordList) {
		delete recordList;
	}
	
	global void finish(Database.BatchableContext BC){
		Database.executeBatch(new BatchCargaTarifaAleloInsert(this.cargaTarifaAlelo),10);
	}
}
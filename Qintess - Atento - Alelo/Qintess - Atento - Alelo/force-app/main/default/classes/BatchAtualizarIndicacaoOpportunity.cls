global class BatchAtualizarIndicacaoOpportunity implements Database.Batchable<sObject>, Database.AllowsCallouts {
	
	private Integer codigoBanco {get;set;}
    private Integer codigoBanco2 {get;set;}
	private Integer codigoBanco3 {get;set;}
	
	global BatchAtualizarIndicacaoOpportunity(Integer banco, Integer banco2, Integer banco3){
    	this.codigoBanco = banco;
        this.codigoBanco2 = banco2;
		this.codigoBanco3 = banco3;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
    	
    	system.debug('Inicío: BatchAtualizarIndicacaoOpportunity');
    	
    	String query = DAOOpportunity.getQueryIndicacaoBancos(this.codigoBanco, this.codigoBanco2, this.codigoBanco3);
    	
    	system.debug('query: ' + query);
    	
    	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> scope) {
    	List<Opportunity> listBanco1 = new List<Opportunity>();
		List<Opportunity> listBanco2 = new List<Opportunity>();
		List<Opportunity> listBanco3 = new List<Opportunity>();

		for(Opportunity oppt : scope){
			if(oppt.Codigo_do_Banco__c == String.valueOf(this.codigoBanco)){
				listBanco1.add(oppt);
			} else if(oppt.Codigo_do_Banco__c == String.valueOf(this.codigoBanco2)){
				listBanco2.add(oppt);
			} else if(oppt.Codigo_do_Banco__c == String.valueOf(this.codigoBanco3)){
				listBanco3.add(oppt);
			}
		}
		if(!Test.IsRunningTest()){
            if(listBanco1 != null){
                AtualizarIndicacaoOpportunity atualizarJob = new AtualizarIndicacaoOpportunity(this.codigoBanco, listBanco1);
                ID jobID = System.enqueueJob(atualizarJob);
            	//BOLead.atualizarIndicacao(this.codigoBanco, null, listBanco1);
            }
            if(listBanco2 != null){
                AtualizarIndicacaoOpportunity atualizarJob = new AtualizarIndicacaoOpportunity(this.codigoBanco2, listBanco2);
                ID jobID = System.enqueueJob(atualizarJob);
            	//BOLead.atualizarIndicacao(this.codigoBanco2, null, listBanco2);
            }
            if(listBanco3 != null){
                AtualizarIndicacaoOpportunity atualizarJob = new AtualizarIndicacaoOpportunity(this.codigoBanco3, listBanco3);
                ID jobID = System.enqueueJob(atualizarJob);
            	//BOLead.atualizarIndicacao(this.codigoBanco3, null, listBanco3);
            }
        }
	}
	
	global void finish(Database.BatchableContext BC){
		
		system.debug('Fim: BatchAtualizarIndicacaoOpportunity');
	}
}
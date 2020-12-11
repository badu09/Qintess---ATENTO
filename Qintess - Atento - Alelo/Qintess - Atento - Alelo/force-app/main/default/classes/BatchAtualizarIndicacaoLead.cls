global class BatchAtualizarIndicacaoLead implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    private Integer codigoBanco {get;set;}
    private Integer codigoBanco2 {get;set;}
    private Integer codigoBanco3 {get;set;}
    
    global BatchAtualizarIndicacaoLead(Integer banco, Integer banco2, Integer banco3) {
        this.codigoBanco = banco;
        this.codigoBanco2 = banco2;
        this.codigoBanco3 = banco3;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        
        system.debug('Inicío: BatchAtualizarIndicacaoLead');
        
        String query = DAOLead.getQueryIndicacaoBancos(this.codigoBanco, this.codigoBanco2, this.codigoBanco3);
        system.debug('query: ' + query);
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Lead> scope) {
        
        List<Lead> listBanco1 = new List<Lead>();
        List<Lead> listBanco2 = new List<Lead>();
        List<Lead> listBanco3 = new List<Lead>();
        
        for(Lead ld : scope){
            if(ld.Codigo_Banco__c == String.valueOf(this.codigoBanco)){
                listBanco1.add(ld);
            } else if(ld.Codigo_Banco__c == String.valueOf(this.codigoBanco2)){
                listBanco2.add(ld);
            } else if(ld.Codigo_Banco__c == String.valueOf(this.codigoBanco3)){
                listBanco3.add(ld);
            }
        }
        
        if(!Test.IsRunningTest()){
            if(listBanco1 != null){
                AtualizarIndicacaoLead atualizarJob = new AtualizarIndicacaoLead(this.codigoBanco, listBanco1);
                ID jobID = System.enqueueJob(atualizarJob);
            	//BOLead.atualizarIndicacao(this.codigoBanco, listBanco1, null);
            }
            if(listBanco2 != null){
                AtualizarIndicacaoLead atualizarJob = new AtualizarIndicacaoLead(this.codigoBanco2, listBanco2);
                ID jobID = System.enqueueJob(atualizarJob);
            	//BOLead.atualizarIndicacao(this.codigoBanco2, listBanco2, null);
            }
            if(listBanco3 != null){
                AtualizarIndicacaoLead atualizarJob = new AtualizarIndicacaoLead(this.codigoBanco3, listBanco3);
                ID jobID = System.enqueueJob(atualizarJob);
            	//BOLead.atualizarIndicacao(this.codigoBanco3, listBanco3, null);
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
        
        system.debug('Fim: BatchAtualizarIndicacaoLead');
    }
}
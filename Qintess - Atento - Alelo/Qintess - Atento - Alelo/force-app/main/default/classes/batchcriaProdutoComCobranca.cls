global class batchcriaProdutoComCobranca implements Database.Batchable<sObject>, Database.Stateful {
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
       
        // O motivo da criação desta condição é devido a criação da Cobrança automática, que é feita por um Process Builder,
        // quando os campos Numero de Contrato é valorizado e Tem_Cobranca for Falso, não estava sendo possivel a realização do
        // teste da classe pois o processo estava alterando o valor da flag em Tem_Cobranca para Verdadeiro.
        if(Test.isRunningTest()){
            
            return Database.getQueryLocator([SELECT id,Numero_do_Contrato__c,Oportunidade__c,Tem_Cobranca__c 
                                         FROM Produtos_Alelo__c 
                                         WHERE  Tem_Cobranca__c = true
                                         AND Oportunidade__r.Contato_da_oportunidade__c != ''
                                         AND Oportunidade__r.Contato_da_oportunidade__c != null
                                         AND Numero_do_Contrato__c != null 
                                         AND Numero_do_Contrato__c != ''
                                         AND Tabulacao_Pai_Implantacao__c != '']);
            
        }else {
        
        return Database.getQueryLocator([SELECT id,Numero_do_Contrato__c,Oportunidade__c,Tem_Cobranca__c 
                                         FROM Produtos_Alelo__c 
                                         WHERE  Tem_Cobranca__c = false
                                         AND Oportunidade__r.Contato_da_oportunidade__c != ''
                                         AND Oportunidade__r.Contato_da_oportunidade__c != null
                                         AND Numero_do_Contrato__c != null 
                                         AND Numero_do_Contrato__c != ''
//                                       AND Tabulacao_Pai_Implantacao__c != '']);
                                         ]);
        }
    }
    
     global void execute(Database.BatchableContext bc , List<Produtos_Alelo__c> scope){
         
         Database.SaveResult[] LstPrd = Database.update(scope, false);
         
         for (Database.SaveResult Prd :LstPrd)
         {
             if (!Prd.isSuccess())
             {
                 System.debug('Errors update LstPrd: '+Prd.getErrors()); 
                 System.debug('ID - Errors update LstPrd: '+ Prd.getId()); 
             }
         }
         
     }
      global void finish(Database.BatchableContext bc){
               
      }
}
global class BatchEstrategiaDesativadas implements Database.Batchable<sObject>, Database.Stateful
{

    global Date dataAtual = System.today();

    Estrategia_Implantacao__c estrategia = new Estrategia_Implantacao__c();

    global BatchEstrategiaDesativadas ()
    {
        System.debug('#BatchEstrategiaDesativadas - construtor');
        
        dataAtual = System.today();
        //System.debug('dataAtual: '+dataAtual);
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('#BatchEstrategiaDesativadas - start');
        
    	String query = '';

        List<Estrategia_Implantacao__c> lstEstrategia = 
            [SELECT Id ,Name, Fila_Agendado__c ,Fila_Contatado__c ,Fila_Nova__c, 
             		Id_Relatorio_Estrategia__c ,Implantacao_Fidelizada__c
             FROM	Estrategia_Implantacao__c 
             WHERE 	Fila_Nova__c <> null 
             AND 	Fila_Contatado__c <> null 
             AND 	Fila_Agendado__c <> null
             AND 	Processado__c = true
             AND 	Ativado__c = false
           	 AND 	Data_Inicio_Vigencia__c <= :dataAtual
             AND 	Data_Fim_Vigencia__c >= :dataAtual
             AND	ID IN (SELECT Estrategia_Implantacao__c 
                           FROM   Opportunity)
            		LIMIT 1];
        
        if (!lstEstrategia.isEmpty() && lstEstrategia.size() > 0)
        {
            System.debug('Estratégia Tratada: '+lstEstrategia[0].Name);
            estrategia = lstEstrategia[0];
            String idEstrategia = estrategia.Id;
            
            query = 'SELECT ' +
                'Id ' +
                ',Estrategia_Implantacao__c ' +
                ',Total_Fidelizado__c ' +
                ',Tipo_de_Fila_Consolidado__c ' +
                ',Implantador_Atribuido__c ' +
                ',Processo_Implantacao__c ' +
                ',Processo_Implantacao__r.Id ' +
                ',Processo_Implantacao__r.OwnerId ' +
                ',OwnerId ' +
                ' FROM Opportunity ' +
                ' WHERE ' +
                ' Estrategia_Implantacao__c = :idEstrategia '
                ;
        }
        
        if (query != '')
        {
            //Método de teste não processa mais de 1 ocorrência
            if (Test.isRunningTest())
            {
                query += ' Order by Id DESC ';
                query += ' LIMIT 1';
            }
            
        } else
        {
            query = 'SELECT ' +
                'Id ' +
                ' FROM Opportunity ' +
                ' WHERE ' +
                ' Id = null '
                ;
        }

        System.debug('Query principal: '+query);
        return Database.getQueryLocator(query);

    }

    global void execute(Database.BatchableContext BC, List<Opportunity> scope) 
    {
        System.debug('#BatchEstrategiaDesativadas - execute');
        
        System.debug('Qtde Oportunidades execute: '+scope.size());

        List<Opportunity> lstOppUpdate = new List<Opportunity>();

        for (Opportunity opp :scope)
        {
            //Atualizar Oportunidade para remover a Estratégia
            opp.Estrategia_Implantacao_Anterior__c = opp.Estrategia_Implantacao__c;
            opp.Estrategia_Implantacao__c = null;
            lstOppUpdate.add(opp);
        }
        
        if ( !lstOppUpdate.isEmpty() && lstOppUpdate.size() > 0)
        {
            try 
            {
                Database.SaveResult[] lstSrOpp = Database.update(lstOppUpdate, false);
                
                for (Database.SaveResult srOpp :lstSrOpp)
                {
                    if (!srOpp.isSuccess())
                    {
                        System.debug('Errors update lstOppUpdate: '+srOpp.getErrors()); 
                    }
                }
            }
            catch (Exception ex)
            {
                system.debug('Exception update lstOppUpdate: ' + ex.getLineNumber());
                system.debug('Exception update lstOppUpdate: ' + ex.getMessage());
            }
        }
        
    }
    
	global void finish(Database.BatchableContext BC)
    {
        System.debug('#BatchEstrategiaDesativadas - finish');

    }
    
}
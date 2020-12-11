global class BatchEstrategiaVencidas implements Database.Batchable<sObject>, Database.Stateful
{

    global Date dataAtual = System.today();
    global Id userProvisorio;

    Estrategia_Implantacao__c estrategia = new Estrategia_Implantacao__c();

    global BatchEstrategiaVencidas ()
    {
        System.debug('#BatchEstrategiaVencidas - construtor');
        
        dataAtual = System.today();
        //System.debug('dataAtual: '+dataAtual);
        
        userProvisorio = UserInfo.getUserId();
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('#BatchEstrategiaVencidas - start');
        
    	String query = '';

        List<Estrategia_Implantacao__c> lstEstrategia = 
            [SELECT Id ,Name, Fila_Agendado__c ,Fila_Contatado__c ,Fila_Nova__c, 
             		Id_Relatorio_Estrategia__c ,Implantacao_Fidelizada__c
             FROM	Estrategia_Implantacao__c 
             WHERE 	Fila_Nova__c <> null 
             AND 	Fila_Contatado__c <> null 
             AND 	Fila_Agendado__c <> null
           	 AND 	Data_Fim_Vigencia__c <= :dataAtual
             AND	ID IN (SELECT Estrategia_Implantacao__c 
                           FROM   Opportunity)
            		LIMIT 1];
        
        if (!lstEstrategia.isEmpty() && lstEstrategia.size() > 0)
        {
            System.debug('Estratégia Tratada: '+lstEstrategia[0].Name);
            estrategia = lstEstrategia[0];
            System.debug('estrategia start: '+estrategia);
            String idEstrategia = estrategia.Id;
            
            query = 'SELECT ' +
                'Id ' +
                ',Total_Fidelizado__c ' +
                ',Tipo_de_Fila_Consolidado__c ' +
                ',Estrategia_Implantacao__c ' +
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
        System.debug('#BatchEstrategiaVencidas - execute');
        
        System.debug('Qtde Oportunidades execute: '+scope.size());
        System.debug('estrategia execute: '+estrategia);

        List<Opportunity> lstOppUpdate = new List<Opportunity>();
        List<Order> lstOrderUpdate = new List<Order>();

        for (Opportunity opp :scope)
        {
            if (opp.Processo_Implantacao__r.OwnerId != null &&
                (opp.Processo_Implantacao__r.OwnerId == estrategia.Fila_Nova__c ||
                 opp.Processo_Implantacao__r.OwnerId == estrategia.Fila_Contatado__c ||
                 opp.Processo_Implantacao__r.OwnerId == estrategia.Fila_Agendado__c)  )
            {
                System.debug('Estratégia com oportunidade + Pedido com proprietário igual à Fila da Estratégia');
                
                //Limpa proprietário do Pedido
                Order pedido = new Order();
                pedido.Id = opp.Processo_Implantacao__c;
                pedido.Status = 'Disponivel';
                pedido.OwnerId = userProvisorio;
                lstOrderUpdate.add(pedido);
            }
            
            //Limpar a Estratégia da Oportunidade
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

        if ( !lstOrderUpdate.isEmpty() && lstOrderUpdate.size() > 0)
        {
            try 
            {
                Database.SaveResult[] lstSrOrder = Database.update(lstOrderUpdate, false);
                for (Database.SaveResult srOrder :lstSrOrder)
                {
                    if (!srOrder.isSuccess())
                    {
                        System.debug('Errors update lstSrOrder: '+srOrder.getErrors()); 
                    }
                }
            }
            catch (Exception ex)
            {
                system.debug('Exception update lstOrderUpdate: ' + ex.getLineNumber());
                system.debug('Exception update lstOrderUpdate: ' + ex.getMessage());
            }
        }

    }
    
	global void finish(Database.BatchableContext BC)
    {
        System.debug('#BatchEstrategiaVencidas - finish');

    }
    
}
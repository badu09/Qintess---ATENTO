global class BatchEstrategiaExcluirFilas implements Database.Batchable<sObject>, Database.Stateful
{

    global Date dataAtual = System.today();

    Estrategia_Implantacao__c estrategia = new Estrategia_Implantacao__c();

    global BatchEstrategiaExcluirFilas ()
    {
        System.debug('#BatchEstrategiaExcluirFilas - construtor');
        
        dataAtual = System.today();
        //System.debug('dataAtual: '+dataAtual);
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('#BatchEstrategiaExcluirFilas - start');
        
    	String query = '';

        query = 'SELECT ' +
            'Id ' +
            ',Name ' +
            ',Fila_Agendado__c ' +
            ',Fila_Contatado__c ' +
            ',Fila_Nova__c ' +
            ',Id_Relatorio_Estrategia__c ' +
            ',Implantacao_Fidelizada__c ' +
            ' FROM Estrategia_Implantacao__c ' +
            ' WHERE ' +
            '     Fila_Nova__c <> null ' +
            ' AND Fila_Contatado__c <> null ' +
            ' AND Fila_Agendado__c <> null ' +
            ' AND Data_Fim_Vigencia_Apos1Mes__c <= :dataAtual ' +
            ' AND ID NOT IN (SELECT Estrategia_Implantacao__c ' +
            '      FROM   Opportunity) '
            ;
        
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

    global void execute(Database.BatchableContext BC, List<Estrategia_Implantacao__c> scope) 
    {
        System.debug('#BatchEstrategiaExcluirFilas - execute');
        
        System.debug('Qtde Estratégias execute: '+scope.size());

        Set<Id> setFilas = new Set<Id>();
        List<Group> lstFilasUpdate = new List<Group>();
        List<Estrategia_Implantacao__c> lstEstratUpdate = new List<Estrategia_Implantacao__c>();

        for (Estrategia_Implantacao__c estrategia :scope)
        {
            //Monta set de Id de filas, para exclusão
            setFilas.add(estrategia.Fila_Nova__c);
            setFilas.add(estrategia.Fila_Contatado__c);
            setFilas.add(estrategia.Fila_Agendado__c);

            estrategia.Fila_Nova__c = null;
            estrategia.Fila_Contatado__c = null;
            estrategia.Fila_Agendado__c = null;
            lstEstratUpdate.add(estrategia);
            
        }
        
        if ( !lstEstratUpdate.isEmpty() && lstEstratUpdate.size() > 0)
        {
            try 
            {
                Database.SaveResult[] lstSrEst = Database.update(lstEstratUpdate, false);
                
                for (Database.SaveResult srEst :lstSrEst)
                {
                    if (!srEst.isSuccess())
                    {
                        System.debug('Errors update lstEstratUpdate: '+srEst.getErrors()); 
                    }
                }
            }
            catch (Exception ex)
            {
                system.debug('Exception update lstEstratUpdate: ' + ex.getLineNumber());
                system.debug('Exception update lstEstratUpdate: ' + ex.getMessage());
            }
        }

        if ( !setFilas.isEmpty() && setFilas.size() > 0)
        {
            System.debug('setFilas: '+setFilas);
            
            List<Order> lstPedidosEncontrados = [Select Id, OwnerId From Order where OwnerId IN :setFilas];
            if (!lstPedidosEncontrados.isEmpty() && lstPedidosEncontrados.size() > 0)
            {
                for (Order pedido : lstPedidosEncontrados)
                {
                    setFilas.remove(pedido.OwnerId);
                }
            }
            
            lstFilasUpdate = DAOGroup.getGroupBySet(setFilas);
        }
        
        if ( !lstFilasUpdate.isEmpty() && lstFilasUpdate.size() > 0)
        {
            try 
            {
                Database.DeleteResult[] lstSrFilas = Database.delete(lstFilasUpdate, false);
                
                for (Database.DeleteResult drFilas :lstSrFilas)
                {
                    if (!drFilas.isSuccess())
                    {
                        System.debug('Errors delete lstSrFilas: '+drFilas.getErrors()); 
                    }
                }
            }
            catch (Exception ex)
            {
                system.debug('Exception delete lstSrFilas: ' + ex.getLineNumber());
                system.debug('Exception delete lstSrFilas: ' + ex.getMessage());
            }
        }
    }
    
	global void finish(Database.BatchableContext BC)
    {
        System.debug('#BatchEstrategiaExcluirFilas - finish');

    }
    
}
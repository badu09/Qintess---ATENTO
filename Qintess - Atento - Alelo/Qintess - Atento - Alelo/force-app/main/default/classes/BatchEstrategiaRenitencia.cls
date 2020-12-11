global class BatchEstrategiaRenitencia implements Database.Batchable<sObject>, Database.Stateful
{
    
    global Date dataAtual = System.today();
        
    Estrategia_Implantacao__c estrategia = new Estrategia_Implantacao__c();

    global BatchEstrategiaRenitencia ()
    {
        System.debug('#BatchEstrategiaRenitencia - construtor');
        
        dataAtual = System.today();
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('#BatchEstrategiaRenitencia - start');
        
    	String query = '';

        List<Estrategia_Implantacao__c> lstEstrategia = 
            [SELECT Id ,Name, Fila_Agendado__c ,Fila_Contatado__c ,Fila_Nova__c, 
             		Id_Relatorio_Estrategia__c ,Implantacao_Fidelizada__c, Renitencia__c,
             		Quantidade_Renitencias__c
             FROM	Estrategia_Implantacao__c 
             WHERE 	Fila_Nova__c <> null 
             AND 	Fila_Contatado__c <> null 
             AND 	Fila_Agendado__c <> null
             AND	Renitencia__c = true
             AND	ID IN (SELECT Estrategia_Implantacao__c 
                           FROM   Opportunity)
            ];
        
        if (!lstEstrategia.isEmpty() && lstEstrategia.size() > 0)
        {
            System.debug('Estratégia Tratada: '+lstEstrategia[0].Name);
            estrategia = lstEstrategia[0];
            String idEstrategia = estrategia.Id;
            
            query = 'SELECT ' +
                'Id ' +
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
        System.debug('#BatchEstrategiaRenitencia - execute');
        
        System.debug('Qtde Oportunidades execute: '+scope.size());
        System.debug('estrategia execute: '+estrategia);

        set<id> setOpp = new set<id>();
                
        for(Opportunity opp :scope){
            setOpp.add(opp.id);   
        }
        
        Map<String, List<Produtos_Alelo__c>> mapProduto = new Map<String, List<Produtos_Alelo__c>>();
        
        List<Produtos_Alelo__c> selectProduto = DAOProdutosAlelo.getProductOportunity(setOpp);
          
        List<Produtos_Alelo__c> lstProduto = new List<Produtos_Alelo__c>();

        if (!selectProduto.isEmpty() && selectProduto.size() > 0)
        {
            id oppAnterior = selectProduto[0].Oportunidade__c; 
            
            for(Produtos_Alelo__c produto: selectProduto)
            {                
                if(produto.Oportunidade__c == oppAnterior)
                {
                    lstProduto.add(produto);
                    
                } else
                {
                    List<Produtos_Alelo__c> lstClone = lstProduto.deepClone(true, true, true);
                    mapProduto.put(oppAnterior, lstClone);
                    lstProduto.clear();
                    lstProduto.add(produto);
                }
                oppAnterior = produto.Oportunidade__c;
            }
            mapProduto.put(oppAnterior, lstProduto);
            
            
            List<Opportunity> lstOppUpdate = new List<Opportunity>();
            List<Produtos_Alelo__c> lstProdutoGetMap = new List<Produtos_Alelo__c>();
            List<Produtos_Alelo__c> lstProdutoUpdate = new List<Produtos_Alelo__c>();
            List<Order> lstOrderUpdate = new List<Order>();
            
            for (Opportunity opp :scope)
            {
                opp.Quantidade_Tentativas_Realizadas__c = 0;
                lstOppUpdate.add(opp);
                
                //Atualizar proprietário do Pedido com a fila da Estratégia
                Order pedido = new Order();
                pedido.Id = opp.Processo_Implantacao__c;
                pedido.OwnerId = estrategia.Fila_Nova__c;
                lstOrderUpdate.add(pedido);
                
                lstProdutoGetMap = mapProduto.get(string.valueOf(opp.Id));
                
                if (lstProdutoGetMap != null && !lstProdutoGetMap.isEmpty() && lstProdutoGetMap.size() > 0)
                {                    
                    for(Produtos_Alelo__c produtosZerar: lstProdutoGetMap)
                    {
                        if(produtosZerar.Oportunidade__c == opp.id)
                        {
                            produtosZerar.Quantidade_Insucesso_Estrategia__c = 0;
                            produtosZerar.Quantidade_Total_Estrategia__c = 0;
                            produtosZerar.Insucesso_TelefoneErrado__c = 0;
                            produtosZerar.Insucesso_TelefoneNaoAtende__c = 0;
                            
                            lstProdutoUpdate.add(produtosZerar);
                        }
                    }
                }                
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
            
            
            if ( !lstProdutoUpdate.isEmpty() && lstProdutoUpdate.size() > 0)
            {
                try 
                {
                    system.debug('## Entrou Try Produto');
                    Database.SaveResult[] lstProd = Database.update(lstProdutoUpdate, false);
                    
                    for (Database.SaveResult srProd :lstProd)
                    {
                        if (!srProd.isSuccess())
                        {
                            System.debug('Errors update lstProdutoUpdate: '+srProd.getErrors()); 
                        }
                    }
                }
                catch (Exception ex)
                {
                    system.debug('Exception update lstProdutoUpdate: ' + ex.getLineNumber());
                    system.debug('Exception update lstProdutoUpdate: ' + ex.getMessage());
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
    }
    global void finish(Database.BatchableContext BC)
    {
        System.debug('#BatchEstrategiaRenitencia - finish');
        
        if(estrategia.Quantidade_Renitencias__c == null)
        {
            estrategia.Quantidade_Renitencias__c = 0;
            estrategia.Quantidade_Renitencias__c = estrategia.Quantidade_Renitencias__c + 1;
            
        }else{
            estrategia.Quantidade_Renitencias__c = estrategia.Quantidade_Renitencias__c + 1;
        }  
        
        if(estrategia.Renitencia__c == true)
        {
            estrategia.Renitencia__c = false;
            update estrategia; 
        }
        
    }
    
}
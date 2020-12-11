global class BatchEstrategiaNaoProcessadas implements Database.Batchable<sObject>, Database.Stateful
{

    global Date dataAtual = System.today();

    global final String nomeReport = 'Implantação - Gestão de Estratégia';

    global Map<String, Report> mapReport;

    Estrategia_Implantacao__c estrategia = new Estrategia_Implantacao__c();

    global BatchEstrategiaNaoProcessadas ()
    {
        System.debug('#BatchEstrategiaNaoProcessadas - construtor');
        
        dataAtual = System.today();
        //System.debug('dataAtual: '+dataAtual);
        
        mapReport = new Map<String, Report>();
        //System.debug('Nome Folder: '+nomeReport);
        for(Report relatorio : DAOReport.getReportByFolder(nomeReport))
        {
            mapReport.put(relatorio.Id,relatorio);
        }
        System.debug('mapReport size: '+mapReport.size());
        //System.debug('mapReport: '+mapReport.values());
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('#BatchEstrategiaNaoProcessadas - start');
        
    	String query = '';

        List<Estrategia_Implantacao__c> lstEstrategia = 
            [SELECT Id ,Name, Fila_Agendado__c ,Fila_Contatado__c ,Fila_Nova__c, 
             		Id_Relatorio_Estrategia__c ,Implantacao_Fidelizada__c
             FROM	Estrategia_Implantacao__c 
             WHERE 	Fila_Nova__c <> null 
             AND 	Fila_Contatado__c <> null 
             AND 	Fila_Agendado__c <> null
             AND 	Processado__c = false
             AND 	Ativado__c = true
           	 AND 	Data_Inicio_Vigencia__c <= :dataAtual
             AND 	Data_Fim_Vigencia__c >= :dataAtual
            		LIMIT 1];
        
        if (!lstEstrategia.isEmpty() && lstEstrategia.size() > 0)
        {
            System.debug('Estratégia Tratada: '+lstEstrategia[0].Name);
            estrategia = lstEstrategia[0];
            
            Report relatorio = mapReport.get(estrategia.Id_Relatorio_Estrategia__c);
            if (relatorio == null)
            {
                System.debug('Relatório não encontrado: '+estrategia.Id_Relatorio_Estrategia__c);
            } 
            else
            {
                System.debug('Relatório encontrado: '+estrategia.Id_Relatorio_Estrategia__c);
                //Obter as Oportunidades resultantes do Relatório
                Set<Id> setOpp = getOppsByReport(estrategia.Id_Relatorio_Estrategia__c);
                if ( !setOpp.isEmpty() && setOpp.size() > 0 )
                {
                    System.debug('Qtde Oportunidades total: '+setOpp.size());
                    
                    query = 'SELECT ' +
                        'Id ' +
                        ',Total_Fidelizado__c ' +
                        ',Tipo_de_Fila_Consolidado__c ' +
                        ',Implantador_Atribuido__c ' +
                        ',Processo_Implantacao__c ' +
                        ',Processo_Implantacao__r.Id ' +
                        ',Processo_Implantacao__r.OwnerId ' +
                        ' FROM Opportunity ' +
                        ' WHERE ' +
                        '     Id IN :setOpp ' +
                        ' AND Estrategia_Implantacao__c = null' +
                        ' AND Processo_Implantacao__c <> null' +
                        ' AND Processo_Implantacao__r.Id <> null'
                        ;
                }
            }        
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
        System.debug('#BatchEstrategiaNaoProcessadas - execute');
        
        System.debug('Qtde Oportunidades execute: '+scope.size());
        
        Map<String, List<Produtos_Alelo__c>> mapProdutos = gerarMapProdutos(scope);

        List<Opportunity> lstOppUpdate = new List<Opportunity>();
        List<Order> lstOrderUpdate = new List<Order>();
        List<Produtos_Alelo__c> lstProdutoUpdate = new List<Produtos_Alelo__c>();

        for (Opportunity opp :scope)
        {
            //Atualizar proprietário do Pedido com a fila da Estratégia
            Order pedido = new Order();
            pedido.Id = opp.Processo_Implantacao__c;
            pedido.OwnerId = estrategia.Fila_Nova__c;
            pedido.OpportunityId = opp.Id;
            lstOrderUpdate.add(pedido);
            
            //Atualizar lista de produtos
            List<Produtos_Alelo__c> lstProdutos = mapProdutos.get(opp.Id);
            if (lstProdutos != null)
            {
                for (Produtos_Alelo__c produto :lstProdutos)
                {
                    produto.Quantidade_Insucesso_Estrategia__c = 0;
                    produto.Quantidade_Total_Estrategia__c = 0;
                    produto.Quantidade_Agendadas_Estrategia__c = 0;
                    produto.Insucesso_TelefoneErrado__c = 0;
                    produto.Insucesso_TelefoneNaoAtende__c = 0;
                    lstProdutoUpdate.add(produto);
                }
            }
            
            //Atualizar Oportunidade com a Estratégia
            opp.Estrategia_Implantacao__c = estrategia.Id;
            //opp.Implantador_Atribuido__c = null;
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
        
        if ( !lstProdutoUpdate.isEmpty() && lstProdutoUpdate.size() > 0)
        {
            try 
            {
                Database.SaveResult[] lstSrProduto = Database.update(lstProdutoUpdate, false);
                for (Database.SaveResult srProduto :lstSrProduto)
                {
                    if (!srProduto.isSuccess())
                    {
                        System.debug('Errors update lstSrProduto: '+srProduto.getErrors()); 
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
    
	global void finish(Database.BatchableContext BC)
    {
        System.debug('#BatchEstrategiaNaoProcessadas - finish');

        //Atualizar Estratégia como processada
        if (estrategia.Id != null)
        {
            estrategia.Processado__c = true;
            update estrategia;
        }
        
    }
    
    public Set<Id> getOppsByReport(Id idReport)
    {
        Set<Id> setOpp = new Set<Id>();
        
        //Executa o relatório
        Reports.reportResults results = Reports.ReportManager.runReport(idReport, true);
        //System.debug('results: '+results);
        //System.debug('getHasDetailRows: '+results.getHasDetailRows());
        
        MAP<String,Reports.ReportFact> factMap = results.getFactMap();
        //System.debug('factMap: '+factMap);
        
        if (results.getHasDetailRows()) 
        {
            for (String strDetalhe : factMap.keySet())
            {
                Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)factMap.get(strDetalhe);
                //System.debug('factDetails: '+factDetails);
                
                for (Reports.ReportDetailRow detailRow : factDetails.getRows())
                {
                    //System.debug('Label: '+detailRow.getDataCells()[0].getLabel());
                    //System.debug('Value: '+detailRow.getDataCells()[0].getValue());
                    try
                    {
                        Id idOpp = String.valueOf(detailRow.getDataCells()[0].getValue());
                        String strObj = String.valueOf(idOpp.getSobjectType());
                        if (strObj.equals('Opportunity'))
                        {
                            //setOpp.add('\'' + idOpp + '\'');
                            setOpp.add(idOpp);
                        }
                    }
                    catch (Exception ex)
                    {
                        System.debug('Primeira coluna não tem Id da Oportunidade');
                    }
                }
                
            }
        }
        
        return setOpp;
    }
    
    public Map<String, List<Produtos_Alelo__c>> gerarMapProdutos (List<Opportunity> lstOpp)
    {
        
        set<id> setOpp = new set<id>();
                
        for(Opportunity opp :lstOpp){
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
            
        }   
        
        return mapProduto;
    }
    
}
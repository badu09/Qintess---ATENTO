trigger ProdutosAlelo_After on Produtos_Alelo__c (after update, after insert) 
{
    
    System.debug('#ProdutosAlelo_After - Início');
    
    Map<String, TentativaPorTabulacao__mdt> mapTentativas = DAOTentativaPorTabulacao.getMapTentativaPorTabulacao('Implantação');
    List<Opportunity> lstOppUpdate = new List<Opportunity>();
    List<Order> lstOrderUpdate = new List<Order>();
    
    Group filaDescarteEstrategia = DAOGroup.getDeveloperNameGroup('Descarte_Insucesso_Estrategia', 'Queue');
    
    for (Produtos_Alelo__c produto : Trigger.New)
    {
        //Se Estratégia, verificar estouro dos contadores
        if (String.isNotBlank(produto.Estrategia_Implantacao__c) && 
            produto.Tabulacao_Pai_Implantacao__c != null && 
            produto.Tabulacao_Filho_Implantacao__c != null &&
            produto.Id_Processo_Implantacao__c != null &&
            produto.Oportunidade__c != null)
        {
            System.debug('max estrat: '+produto.Quantidade_Maxima_Tentativas_Estrategia__c);
            System.debug('qtd insuc: '+produto.Quantidade_Insucesso_Estrategia__c);
            if (produto.Quantidade_Insucesso_Estrategia__c > produto.Quantidade_Maxima_Tentativas_Estrategia__c)
            {
                Order pedido = new Order();
                pedido.Id = produto.Id_Processo_Implantacao__c;
                pedido.Status = 'Disponivel';
                pedido.OwnerId = filaDescarteEstrategia.Id;
                lstOrderUpdate.add(pedido);
                
                Opportunity opp = new Opportunity();
                opp.Id = produto.Oportunidade__c;
                opp.Estrategia_Implantacao_Anterior__c = opp.Estrategia_Implantacao__c;
                opp.Estrategia_Implantacao__c = null;
                lstOppUpdate.add(opp);
            }
            else
            {
                String chaveMap = produto.Tabulacao_Pai_Implantacao__c + produto.Tabulacao_Filho_Implantacao__c;
                TentativaPorTabulacao__mdt paramTabulacao = mapTentativas.get(chaveMap);
                if (paramTabulacao != null && paramTabulacao.Quantidade_Tentativas__c != null)
                {
                    if (produto.Tabulacao_Filho_Implantacao__c == 'TELEFONE OCUPADO OU NÃO ATENDE' ||
                        produto.Tabulacao_Filho_Implantacao__c == 'TELEFONE ERRADO')
                    {
                        if (produto.Insucesso_TelefoneNaoAtende__c > paramTabulacao.Quantidade_Tentativas__c ||
                            produto.Insucesso_TelefoneErrado__c > paramTabulacao.Quantidade_Tentativas__c)
                        {
                            System.debug('Excedeu Tentativas');
                            Order pedido = new Order();
                            pedido.Id = produto.Id_Processo_Implantacao__c;
                            pedido.Status = 'Disponivel';
                            pedido.OwnerId = filaDescarteEstrategia.Id;
                            lstOrderUpdate.add(pedido);
                            
                            Opportunity opp = new Opportunity();
                            opp.Id = produto.Oportunidade__c;
                            opp.Estrategia_Implantacao_Anterior__c = opp.Estrategia_Implantacao__c;
                            opp.Estrategia_Implantacao__c = null;
                            lstOppUpdate.add(opp);
                        }
                    }
                }
            }
        }
    }
    
    if (!lstOppUpdate.isEmpty() && lstOppUpdate.size() > 0)
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
    
    if (!lstOrderUpdate.isEmpty() && lstOrderUpdate.size() > 0)
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
    
    System.debug('#ProdutosAlelo_After - Fim');
    
}
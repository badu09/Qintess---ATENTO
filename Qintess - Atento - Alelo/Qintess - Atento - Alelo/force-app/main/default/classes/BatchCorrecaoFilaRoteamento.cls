global class BatchCorrecaoFilaRoteamento implements Database.Batchable<sObject>, Database.Stateful
{
    global RecordType rtVendas;
    global String finalizado;
    
    global BatchCorrecaoFilaRoteamento ()
    {
        System.debug('#BatchCorrecaoFilaRoteamento - construtor');
        
        rtVendas = DAORecordType.obterPorDeveloperName('Vendas', 'Order');
        finalizado = 'Finalizado';
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        System.debug('#BatchCorrecaoFilaRoteamento - start');
        
        String idRtVendas = rtVendas.Id;
        
        String query = 'SELECT ' +
                       'Id, ' +
                       'OwnerId, ' +
                       'ContractId, ' +
                       'AccountId, ' +
                       'Pricebook2Id, ' +
                       'OriginalOrderId, ' +
                       'OpportunityId, ' +
                       'RecordTypeId, ' +
                       'EffectiveDate, ' +
                       'EndDate, ' +
                       'IsReductionOrder, ' +
                       'Status, ' +
                       'Description, ' +
                       'CustomerAuthorizedById, ' +
                       'CompanyAuthorizedById, ' +
                       'BillingStreet, ' +
                       'BillingCity, ' +
                       'BillingState, ' +
                       'BillingPostalCode, ' +
                       'BillingCountry, ' +
                       'BillingStateCode, ' +
                       'BillingCountryCode, ' +
                       'BillingLatitude, ' +
                       'BillingLongitude, ' +
                       'BillingGeocodeAccuracy, ' +
                       'BillingAddress, ' +
                       'ShippingStreet, ' +
                       'ShippingCity, ' +
                       'ShippingState, ' +
                       'ShippingPostalCode, ' +
                       'ShippingCountry, ' +
                       'ShippingStateCode, ' +
                       'ShippingCountryCode, ' +
                       'ShippingLatitude, ' +
                       'ShippingLongitude, ' +
                       'ShippingGeocodeAccuracy, ' +
                       'ShippingAddress, ' +
                       'ActivatedDate, ' +
                       'ActivatedById, ' +
                       'StatusCode, ' +
                       'OrderNumber, ' +
                       'TotalAmount, ' +
                       'CreatedDate, ' +
                       'CreatedById, ' +
                       'LastModifiedDate, ' +
                       'LastModifiedById, ' +
                       'IsDeleted, ' +
                       'SystemModstamp, ' +
                       'LastViewedDate, ' +
                       'LastReferencedDate, ' +
                       'TESTE__c, ' +
                       'Data_Hora_para_rodar_volta_para_filas__c, ' +
                       'Chave_Busca__c, ' +
                       'Proprietario_Formula__c, ' +
                       'Tipo_de_Fila__c, ' +
                       'Total_Fidelizado__c, ' +
                       'Nome_Proprietario_Oportunidade__c, ' +
                       'Processo_Implantacao_da_Oportunidade__c,  ' +
                       'Total_Contratos_Gerados__c, ' +
                       'Operador__c ' +

            		   ' FROM Order ' +
                       ' WHERE ' +
                       ' OpportunityId != null ' +
                       ' AND Status != :finalizado ' +
                       ' AND RecordTypeId != :idRtVendas ';
        if(!Test.isRunningTest())
        {
            query = query + ' AND Inicio_Proprietario__c = null ' +
                ' Order by OrderNumber ' +
                ' LIMIT 20 '
                ;
        }

        System.debug('Query principal: '+query);
        return Database.getQueryLocator(query);
        
    }

    global void execute(Database.BatchableContext BC, List<Order> scope) 
    {
        System.debug('#BatchCorrecaoFilaRoteamento - execute');
        System.debug('Quantidade de pedidos: '+scope.size());
        
        List<Order> lstPedidosInsert = new List<Order>();
        List<Order> lstPedidosDelete = new List<Order>();
        
        for (Order pedido : scope)
        {
            Order novoPedido = new Order();
            novoPedido = pedido.clone(false, true, true, true);
            novoPedido.OwnerId = Userinfo.getUserId();
            novoPedido.Status = 'Disponivel';
            lstPedidosInsert.add(novoPedido);
            
            lstPedidosDelete.add(pedido);
        }
        
        Integer qtdeInsertOk = 0;
        if ( !lstPedidosInsert.isEmpty() && lstPedidosInsert.size() > 0)
        {
            try 
            {
                Database.SaveResult[] lstSrOrder = Database.insert(lstPedidosInsert, false);
                
                for (Database.SaveResult srOrder :lstSrOrder)
                {
                    if (!srOrder.isSuccess())
                    {
                        System.debug('Errors update lstPedidosInsert: '+srOrder.getErrors()); 
                    } else
                    {
                        qtdeInsertOk++;
                    }
                }
            }
            catch (Exception ex)
            {
                system.debug('Exception update lstPedidosInsert: ' + ex.getLineNumber());
                system.debug('Exception update lstPedidosInsert: ' + ex.getMessage());
            }
        }

        if ( !lstPedidosDelete.isEmpty() && lstPedidosDelete.size() > 0 && lstPedidosDelete.size() == qtdeInsertOk)
        {
            try 
            {
                Database.DeleteResult[] lstSrOrder = Database.delete(lstPedidosDelete, false);
                
                for (Database.DeleteResult srOrder :lstSrOrder)
                {
                    if (!srOrder.isSuccess())
                    {
                        System.debug('Errors update lstPedidosDelete: '+srOrder.getErrors()); 
                    } else
                    {
                        qtdeInsertOk++;
                    }
                }
            }
            catch (Exception ex)
            {
                system.debug('Exception update lstPedidosDelete: ' + ex.getLineNumber());
                system.debug('Exception update lstPedidosDelete: ' + ex.getMessage());
            }
        }
        
    }

	global void finish(Database.BatchableContext BC)
    {
        System.debug('#BatchCorrecaoFilaRoteamento - finish');

    }
    
}
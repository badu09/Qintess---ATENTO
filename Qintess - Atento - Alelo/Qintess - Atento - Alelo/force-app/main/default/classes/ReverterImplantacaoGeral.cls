public with sharing class ReverterImplantacaoGeral 
{

    public static void executar(Set<Id> setId, String tabFilho) 
    {
        Set<Id> setOpp = new Set<Id>();
        List<Opportunity> lstOppUpdate = new List<Opportunity>();
        List<Produtos_Alelo__c> lstProdutoUpdate = new List<Produtos_Alelo__c>();
        DiasUteis diaUteis = new DiasUteis();
        
		try 
        {

			System.debug('setId: ' + JSON.serialize(setId));
            List<Produtos_Alelo__c> lstProdutos = [Select Id, Name, Oportunidade__c, Tabulacao_Pai_Implantacao__c from Produtos_Alelo__c where Id IN:setId];
            SYSTEM.debug('lstProdutos: '+lstProdutos);
            if (!lstProdutos.isEmpty() && lstProdutos.size() > 0)
            {
                for (Produtos_Alelo__c produto : lstProdutos)
                {
                    setOpp.add(produto.Oportunidade__c);
                }
                List<Opportunity> lstOpp = [Select Id, Name from Opportunity where Id IN :setOpp];
                if (!lstOpp.isEmpty() && lstOpp.size() > 0)
                {
                    for (Opportunity opp : lstOpp)
                    {
                        opp.StageName = 'Em Implantação';
                        lstOppUpdate.add(opp);
                    }
                    if ( !lstOppUpdate.isEmpty() && lstOppUpdate.size() > 0)
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
                }
                for (Produtos_Alelo__c produto : lstProdutos)
                {
                    if(tabFilho.equalsIgnoreCase('REALIZOU PEDIDO DE CARTÃO')){
                        produto.Tabulacao_Filho_Implantacao__c = tabFilho;
                    }else{
                        produto.Tabulacao_Filho_Implantacao__c = 'PROCESSO CADASTRAL';
                    }
                    
                    produto.Data_Hora_Implantacao__c = null;
                    produto.Data_Hora_Tabulacao__c = system.now();
                    produto.Valor_Faseado__c = null;
                    produto.Valor_Implantado__c = null;
                    produto.Tabulacao_Pai_Implantacao__c = 'EM IMPLANTAÇÃO';
                    produto.Tabulacao_Neto_Implantacao__c = null;
                    produto.Agendamento_Retorno_Implanta_o__c = DiasUteis.calcularDiasUteis(1, produto.Data_Hora_Tabulacao__c);
                                        
                    lstProdutoUpdate.add(produto);
                }
                if ( !lstProdutoUpdate.isEmpty() && lstProdutoUpdate.size() > 0)
                {
                    Database.SaveResult[] lstProd = Database.update(lstProdutoUpdate, false);
                    
                    for (Database.SaveResult srProd :lstProd)
                    {
                        if (!srProd.isSuccess())
                        {
                            System.debug('Errors update lstProdutoUpdate: '+srProd.getErrors()); 
                        }
                    }
                }
            }
		}
		catch(DmlException ex) 
        {
			system.debug('DmlException: ' + ex.getLineNumber());
			system.debug('DmlException: ' + ex.getStackTraceString());
			system.debug('DmlException: ' + ex.getTypeName());
			system.debug('DmlException: ' + ex.getCause());
			system.debug('DmlException: ' + ex.getMessage());
		}
		catch(Exception ex) 
        {
			system.debug('Exception: ' + ex.getLineNumber());
			system.debug('Exception: ' + ex.getStackTraceString());
			system.debug('Exception: ' + ex.getTypeName());
			system.debug('Exception: ' + ex.getCause());
			system.debug('Exception: ' + ex.getMessage());
		}
        
    }    
    
}
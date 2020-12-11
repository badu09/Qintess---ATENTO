global with sharing class BOProdutosAlelo {
    webservice static String maitainContractIS(Id produtosAleloId) {
    	String retorno = null;
    	Produtos_Alelo__c objProdutosAlelo = null;
    	Opportunity objOportunity = null;
    	Account objAccount = null;
    	
    	try {
    		objProdutosAlelo = DAOProdutosAlelo.getOpportunityProductId(produtosAleloId);
    		objOportunity = DAOOpportunity.getOpportunityById(objProdutosAlelo.Oportunidade__r.Id);
    		objAccount = DAOAccount.getAccountById(objOportunity.Account.Id);
    		
    		HttpAcessoExterno.maitainContractIS(objAccount, objOportunity, objProdutosAlelo);
    		
    		return 'Contrato gerado com sucesso.';
    	} catch(Exception ex)
		{
			system.debug('Exception: ' + ex.getStackTraceString());
			return 'Erro ao gerar o contrato. ' + ex.getMessage();
		}
    }
}
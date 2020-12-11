public with sharing class DAOConfiguracaoCargaTarifaAlelo {
    public static Set<String> listarCodigoProduto() {
    	
    	Set<String> setCodigoProduto = new Set<String>();
    	
    	List<Configuracao_Carga_Tarifa_Alelo__c> lConfiguracaoCargaTarifaAlelo = [SELECT 
																					Id,
																					Codigo_Produto__c
																				FROM 
																					Configuracao_Carga_Tarifa_Alelo__c];
										
		for(Configuracao_Carga_Tarifa_Alelo__c item : lConfiguracaoCargaTarifaAlelo) {
			setCodigoProduto.add(String.valueOf(item.Codigo_Produto__c));
		}
		
		return setCodigoProduto;
	}
}
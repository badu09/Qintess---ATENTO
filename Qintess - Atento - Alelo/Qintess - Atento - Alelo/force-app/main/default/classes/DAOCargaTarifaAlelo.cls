public with sharing class DAOCargaTarifaAlelo {
    
    public static Carga_Tarifa_Alelo__c obterCargaTarifaAlelo(Id id) {
    	return [SELECT 
					Id,
					Name,
					Data_Fim__c,
					Data_Inicio__c,
					Registro_com_erro__c,
					Registro_com_sucesso__c,
					Registro_processado__c,
					Status__c
				FROM 
					Carga_Tarifa_Alelo__c
				WHERE
					Id  =: id];
    }
}
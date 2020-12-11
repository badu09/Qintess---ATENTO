public class DAOTabelaDominio {
  public static Map<Decimal, Dominio__c> getMapFeeCode() {
    Map<Decimal, Dominio__c> mapRetorno = new Map<Decimal,  Dominio__c>();
    List<Dominio__c> retorno = [Select
                                  Id,
                                  Codigo_Identificador__c,
                                  Descricao__c,
                                  Identificador__c,
                                  Identificador_Dominio__c,
                                  PK_Atento__c
                                FROM
                                  Dominio__c
                                WHERE
                                  Identificador__c = 'FeeCode'];
    for(Dominio__c dominio : retorno) {
      mapRetorno.put(dominio.Codigo_Identificador__c, dominio);
    }

    return mapRetorno;
  }

  public static Map<Decimal, Dominio__c> getMapProductCode() {
    Map<Decimal, Dominio__c> mapRetorno = new Map<Decimal,  Dominio__c>();
    List<Dominio__c> retorno = [Select
                                  Id,
                                  Codigo_Identificador__c,
                                  Descricao__c,
                                  Identificador__c,
                                  Identificador_Dominio__c,
                                  PK_Atento__c
                                FROM
                                  Dominio__c
                                WHERE
                                  Identificador__c = 'ProductCode'];
    for(Dominio__c dominio : retorno) {
      mapRetorno.put(dominio.Codigo_Identificador__c, dominio);
    }

    return mapRetorno;
  }

  public static List<Dominio__c> getListProductCode(String identificador) {
    List<Dominio__c> listRetorno = [Select
                  	Id,
                  	Codigo_Identificador__c,
                  	Descricao__c,
                  	Identificador__c,
                  	Identificador_Dominio__c,
                  	PK_Atento__c
                FROM
                  	Dominio__c
                WHERE
                  	Identificador__c =:identificador
              //  AND
                // Codigo_Identificador__c != 302.0
                ORDER BY PK_Atento__c];

    return listRetorno;
  }
  
  	public static Dominio__c getProductCode(Decimal codigoIdentificador) {
		
		List<Dominio__c> retorno = [SELECT
	                                  	Id,
	                                  	Codigo_Identificador__c,
	                                  	Descricao__c,
	                                  	Identificador__c,
	                                  	Identificador_Dominio__c,
	                                  	PK_Atento__c
	                                FROM
	                                  	Dominio__c
	                                WHERE
	                                  	Identificador__c = 'ProductCode' AND
	                                  	Codigo_Identificador__c =: codigoIdentificador];
	                                  	
		return retorno.isEmpty() ? null : retorno[0];
  	
  	}
}
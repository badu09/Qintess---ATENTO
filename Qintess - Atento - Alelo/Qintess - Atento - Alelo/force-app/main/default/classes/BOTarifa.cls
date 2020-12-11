global class BOTarifa {
  /*public static Map<String, TOTarifa> carregarTarifas() {
    DAOTarifa.limparTarifas();
    Map<String, TOTarifa> retornoMap = new Map<String, TOTarifa>();
    List<TOTarifa> retorno = new List<TOTarifa>();
    List<String> productCodes = new List<String>{'100', '200', '202', '300', '301', '302', '400'};
    Map<Decimal, Dominio__c> mFeeCode = DAOTabelaDominio.getMapFeeCode();
    Map<Decimal, Dominio__c> mProductCode = DAOTabelaDominio.getMapProductCode();

    for(String productCodeStr : productCodes) {
      String communicationProduct;
      if(productCodeStr != '301' && productCodeStr != '302') {
        communicationProduct = '1';
      }
      else {
        communicationProduct = '16';
      }
      for(Integer feeCode = 1; feeCode <= 24 ; feeCode++) {
        try {
          Dominio__c productObject = mProductCode.get(Decimal.valueOf(productCodeStr));
          Dominio__c feeObject = mFeeCode.get(Decimal.valueOf(feeCode));
          String productName = productObject.Descricao__c;
          String feeName = feeObject.Descricao__c;
          retorno.add(new TOTarifa(productCodeStr, productName, String.valueOf(feeCode), feeName, communicationProduct));
        }
        catch(Exception e) {
          System.debug('Feecode: ' + feeCode + '\nProductCode: ' + productCodeStr);
          System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
        }
      }
    }

    for(TOTarifa item : retorno) {
      retornoMap.put(item.Id, item);
    }
    return retornoMap;
  }*/

	public static List<Tarifas_Alelo__c> encontrarTarifa(Decimal valorMedio, Integer qtdFuncionarios, String codigoProduto) {
		List<Tarifas_Alelo__c> retorno = DAOTarifa.obterTarifas(valorMedio, qtdFuncionarios, codigoProduto);
		return retorno;
	}

  /*public static void carregarTarifa(TOTarifa tarifa) {
    carregarTarifaRetorno(tarifa);
  }*/

	public static List<Tarifas_Alelo__c> encontrarTarifa(Decimal valorMedio, Integer qtdFuncionarios, String codigoProduto, String formaPagamento) {
		List<Tarifas_Alelo__c> retorno = DAOTarifa.obterTarifas(valorMedio, qtdFuncionarios, codigoProduto, formaPagamento);
		return retorno;
	}

  public static TOTarifaRetorno carregarTarifaRetorno(TOTarifa tarifa) {
  	System.debug('tarifa: ' + json.serialize(tarifa));
  	
    TOTarifaRetorno toTarifaRetorno = HttpAcessoExterno.getPricePolicy(tarifa);
    
    System.debug('TOTarifaRetorno: ' + json.serialize(toTarifaRetorno));
    
    return toTarifaRetorno;
  }
  
  webservice static void carregarTarifaAlelo() {
	Id idBatchCargaTarifaAlelo = Database.executeBatch(new BatchCargaTarifaAlelo());

	system.debug('idBatchCargaTarifaAlelo: ' + idBatchCargaTarifaAlelo);
  }
  
	public static Map<Decimal, List<Tarifas_Alelo__c>> carregarTarifaAlelo(String produto, String tarifa) {
  		Map<Decimal, List<Tarifas_Alelo__c>> mapTarifaAlelo = new Map<Decimal, List<Tarifas_Alelo__c>>();
  	 
  		for(Tarifas_Alelo__c item : DAOTarifa.listarTarifaAlelo(produto, tarifa)) {
  			
  			List<Tarifas_Alelo__c> lTarifaAlelo;  			
  			
  			//String chave = item.Qtd_Min__c + ' - ' + item.Qtd_Max_Beneficios__c;
  			
  			if(mapTarifaAlelo.containsKey(item.Qtd_Min__c)) {
  				lTarifaAlelo = mapTarifaAlelo.get(item.Qtd_Min__c);
  				lTarifaAlelo.add(item);
  			}
  			else {
  				lTarifaAlelo = new List<Tarifas_Alelo__c>();
  				lTarifaAlelo.add(item);
  			}
  			
  			mapTarifaAlelo.put(item.Qtd_Min__c, lTarifaAlelo);
  		}
  		
  		return mapTarifaAlelo;
  	}
}
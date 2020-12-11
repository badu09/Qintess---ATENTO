@isTest
private class TestCtrlTarifaAlelo {
    static testMethod void testCtrlPrecificacao() {
    	
    	Tarifas_Alelo__c tarifaAlelo = new Tarifas_Alelo__c();
    	
    	tarifaAlelo.Canal__c = '1';	
    	tarifaAlelo.Codigo_da_Tarifa__c = 1;
    	tarifaAlelo.Codigo_de_Produtos__c = '200';
    	tarifaAlelo.Data_Inicial_de_Validade__c	= Date.today();
    	tarifaAlelo.Nome_da_Forma_de_Pagamento__c = 'PREPAID';
    	tarifaAlelo.Nome_da_Tarifa__c = 'Reemissão de Senha';	
    	tarifaAlelo.Nome_do_Produto__c = 'Alelo Alimentação'; 
    	tarifaAlelo.Qtd_Dias_para_Pagamento__c = 0;
    	tarifaAlelo.Qtd_Max_Beneficios__c = 49;	
    	tarifaAlelo.Qtd_Min__c = 1.0;	
    	tarifaAlelo.Tipo_de_Contrato__c = 'DEFAULT';	
    	tarifaAlelo.Valor_Maximo__c = 10000.0;	
    	tarifaAlelo.Valor_Minimo__c = 50.0;	
    	tarifaAlelo.Valor_Unitario__c = 0.0;	
    	tarifaAlelo.ValueType__c = 'VALUE';
    	
    	insert tarifaAlelo;
    	
        PageReference prTarifaAlelo = Page.TarifaAlelo;
        
        Test.setCurrentPage(prTarifaAlelo);
      	
      	Test.startTest();
      	
      	CtrlTarifaAlelo ctrlTarifaAlelo = new CtrlTarifaAlelo();
      	
      	ctrlTarifaAlelo.carregarTarifa();
      	
      	ctrlTarifaAlelo.pesquisar();
      	
      	ctrlTarifaAlelo.salvar();
      	
      	ctrlTarifaAlelo.cancelar();
      	
      	Test.stopTest();
    }      	
      
}
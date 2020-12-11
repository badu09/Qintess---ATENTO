public with sharing class DAONivelAlcada {
	public static List<Nivel_de_Alcada__c> getByValormedioQtdProduto(Decimal valorMedio, Integer qtd, String codigoProduto) {

		System.debug('valorMedio: ' + valorMedio);
		System.debug('qtd: ' + qtd);
		System.debug('codigoProduto: ' + codigoProduto);

		return [SELECT
				Id,
				Codigo_da_Tarifa__c,
				Valor_Unitario__c,
				Nivel_de_Alcada__c
				FROM
		Nivel_de_Alcada__c
				WHERE
		//Valor_Minimo__c <= :valorMedio AND
				Valor_Maximo__c >= :valorMedio AND
				Qtd_Min__c <= :qtd AND
				Qtd_Max_Beneficios__c >= :qtd AND
				Codigo_de_Produtos__c = :codigoProduto
		ORDER BY Codigo_da_Tarifa__c, Valor_Maximo__c, Valor_Unitario__c, Nivel_de_Alcada__c Desc];
	}

	public static List<Nivel_de_Alcada__c> getByValormedioQtdProduto(Decimal valorMedio, Integer qtd, String codigoProduto, String formaPagamento) {

		System.debug('valorMedio: ' + valorMedio);
		System.debug('qtd: ' + qtd);
		System.debug('codigoProduto: ' + codigoProduto);
		System.debug('formaPagamento: ' + formaPagamento);

		if(formaPagamento != null && formaPagamento.equalsIgnoreCase('CARTAO CREDITO')) {
			List<Nivel_de_Alcada__c> niveis = new List<Nivel_de_Alcada__c>();
			niveis.addAll([SELECT
					Id,
					Codigo_da_Tarifa__c,
					Valor_Unitario__c,
					Nivel_de_Alcada__c
					FROM
			Nivel_de_Alcada__c
					WHERE
			//Valor_Minimo__c <= :valorMedio AND
					Valor_Maximo__c >= :valorMedio AND
					Qtd_Min__c <= :qtd AND
					Qtd_Max_Beneficios__c >= :qtd AND
					Codigo_de_Produtos__c = :codigoProduto AND
					(Codigo_da_Tarifa__c != 2 OR (Nome_da_Forma_de_Pagamento__c = 'CARTAO CREDITO' AND Codigo_da_Tarifa__c = 2))
			ORDER BY Codigo_da_Tarifa__c, Valor_Maximo__c, Valor_Unitario__c, Nivel_de_Alcada__c Desc]);

			System.debug('niveis: ' + JSON.serialize(niveis));
			return niveis;
		}
		else {
			return [SELECT
					Id,
					Codigo_da_Tarifa__c,
					Valor_Unitario__c,
					Nivel_de_Alcada__c
					FROM
			Nivel_de_Alcada__c
					WHERE
			//Valor_Minimo__c <= :valorMedio AND
					Valor_Maximo__c >= :valorMedio AND
					Qtd_Min__c <= :qtd AND
					Qtd_Max_Beneficios__c >= :qtd AND
					Codigo_de_Produtos__c = :codigoProduto AND
					Nome_da_Forma_de_Pagamento__c != 'CARTAO CREDITO'
			ORDER BY Codigo_da_Tarifa__c, Valor_Maximo__c, Valor_Unitario__c, Nivel_de_Alcada__c Desc];
		}
	}

	public static Nivel_de_Alcada__c getByValormedioQtdProduto(Decimal valorTarifa, Decimal valorMedio, Integer qtd, String codigoProduto) {
		List<Nivel_de_Alcada__c> listRetorno;
		Nivel_de_Alcada__c nivelAlcadaRetorno = new Nivel_de_Alcada__c();
		List<AggregateResult> listAggregateResult;

		listRetorno = [SELECT
							Id,
							Codigo_da_Tarifa__c,
							Valor_Unitario__c,
							Nivel_de_Alcada__c
						FROM
							Nivel_de_Alcada__c
						WHERE
							//Valor_Minimo__c <= :valorMedio AND
							//Valor_Unitario__c <= :valorTarifa AND
							Valor_Maximo__c >= :valorMedio AND
							Qtd_Min__c <= :qtd AND
							Qtd_Max_Beneficios__c >= :qtd AND
							Codigo_de_Produtos__c = :codigoProduto
						ORDER BY
							Valor_Unitario__c ASC];

		for(Nivel_de_Alcada__c item : listRetorno) {

			if(item.Valor_Unitario__c <= valorTarifa)
				nivelAlcadaRetorno = item;
		}

		return nivelAlcadaRetorno;
	}
}
public class DAOTarifa {
    public static void limparTarifas() {
        List<String> productCodes = new List<String>{'100', '200', '202', '302', '400'};
        
        delete [Select Id FROM Tarifas_Alelo__c WHERE Codigo_de_Produtos__c IN :productCodes];
    }
    
    public static void excluirTarifaPorCodigoProduto(Set<String> setCodigoProduto) {
        delete [SELECT Id FROM Tarifas_Alelo__c WHERE Codigo_de_Produtos__c IN :setCodigoProduto AND Nome_da_Forma_de_Pagamento__c != 'CARTAO CREDITO'];
    }

    public static List<Tarifas_Alelo__c> obterTarifas(Decimal valorMedio, Integer qtd, String codigoProduto) {
        List<Tarifas_Alelo__c> retorno;
        System.debug('valorMedio: ' + valorMedio);
        System.debug('qtd: ' + qtd);
        System.debug('codigoProduto: ' + codigoProduto);
        retorno = [SELECT
                Id,
                Codigo_da_Tarifa__c,
                Nome_da_Tarifa__c,
                Valor_Medio_do_Beneficio__c,
                Valor_Maximo__c,
                Valor_Minimo__c,
                Qtd_Min__c,
                Qtd_Max_Beneficios__c,
                Codigo_de_Produtos__c,
                Nome_do_Produto__c,
                Quantidade_de_Funcionarios_no_Contrato__c,
                Valor_Unitario__c,
                Percentual__c,
                Valor_Unitario_Prepax__c
                FROM
        Tarifas_Alelo__c
                WHERE
        //Valor_Minimo__c <= :valorMedio AND
                Valor_Maximo__c >= :valorMedio AND
                Qtd_Min__c <= :qtd AND
                Qtd_Max_Beneficios__c >= :qtd AND
                Codigo_de_Produtos__c = :codigoProduto
        ORDER BY Valor_Maximo__c];
        return retorno;
    }

    public static List<Tarifas_Alelo__c> obterTarifas(Decimal valorMedio, Integer qtd, String codigoProduto, String formaPagamento)
    {
        List<Tarifas_Alelo__c> retorno;
        System.debug('valorMedio: ' + valorMedio);
        System.debug('qtd: ' + qtd);
        System.debug('codigoProduto: ' + codigoProduto);
        
        if(formaPagamento != 'CARTAO CREDITO') 
        {	
            retorno = [SELECT
                        Id,
                        Codigo_da_Tarifa__c,
                        Nome_da_Tarifa__c,
                        Valor_Medio_do_Beneficio__c,
                        Valor_Maximo__c,
                        Valor_Minimo__c,
                        Qtd_Min__c,
                        Qtd_Max_Beneficios__c,
                        Codigo_de_Produtos__c,
                        Nome_do_Produto__c,
                        Quantidade_de_Funcionarios_no_Contrato__c,
                        Valor_Unitario__c,
                        Percentual__c,
                        Valor_Unitario_Prepax__c
                        FROM
                        Tarifas_Alelo__c
                        WHERE
                        //Valor_Minimo__c <= :valorMedio AND
                        Valor_Maximo__c >= :valorMedio AND
                        Qtd_Min__c <= :qtd AND
                        Qtd_Max_Beneficios__c >= :qtd AND
                        Codigo_de_Produtos__c = :codigoProduto AND
                        Codigo_da_Tarifa__c != 45 AND
                        Nome_da_Forma_de_Pagamento__c != 'CARTAO CREDITO'
                        ORDER BY Valor_Maximo__c];
        }
        else 
        {	
            retorno = [SELECT
                       Id,
                       Codigo_da_Tarifa__c,
                       Nome_da_Tarifa__c,
                       Valor_Medio_do_Beneficio__c,
                       Valor_Maximo__c,
                       Valor_Minimo__c,
                       Qtd_Min__c,
                       Qtd_Max_Beneficios__c,
                       Codigo_de_Produtos__c,
                       Nome_do_Produto__c,
                       Quantidade_de_Funcionarios_no_Contrato__c,
                       Valor_Unitario__c,
                       Percentual__c,
                       Valor_Unitario_Prepax__c
                       FROM
                       Tarifas_Alelo__c
                       WHERE
                       //Valor_Minimo__c <= :valorMedio AND
                       Valor_Maximo__c >= :valorMedio AND
                       Qtd_Min__c <= :qtd AND
                       Qtd_Max_Beneficios__c >= :qtd AND
                       Codigo_de_Produtos__c = :codigoProduto
                       AND Codigo_da_Tarifa__c != 2
                       AND Codigo_da_Tarifa__c != 4
                       ORDER BY Valor_Maximo__c];		

            retorno.addAll([SELECT
                            Id,
                            Codigo_da_Tarifa__c,
                            Nome_da_Tarifa__c,
                            Valor_Medio_do_Beneficio__c,
                            Valor_Maximo__c,
                            Valor_Minimo__c,
                            Qtd_Min__c,
                            Qtd_Max_Beneficios__c,
                            Codigo_de_Produtos__c,
                            Nome_do_Produto__c,
                            Quantidade_de_Funcionarios_no_Contrato__c,
                            Valor_Unitario__c,
                            Percentual__c,
                            Valor_Unitario_Prepax__c
                            FROM
                            Tarifas_Alelo__c
                            WHERE
                            //Valor_Minimo__c <= :valorMedio AND
                            Valor_Maximo__c >= :valorMedio AND
                            Qtd_Min__c <= :qtd AND
                            Qtd_Max_Beneficios__c >= :qtd AND
                            Codigo_de_Produtos__c = :codigoProduto
                            AND Codigo_da_Tarifa__c != 2
                            AND Codigo_da_Tarifa__c != 4
                            AND Nome_da_Forma_de_Pagamento__c = :formaPagamento
                            ORDER BY Valor_Maximo__c]);
        }
        return retorno;
    }
    
    public static List<Tarifas_Alelo__c> listarTarifaAlelo(String produto, String tarifa) {
        return [SELECT
                    Id,
                    Valor_Maximo__c,
                    Qtd_Min__c,
                    Qtd_Max_Beneficios__c,
                    Valor_Unitario__c
                FROM
                    Tarifas_Alelo__c
                WHERE
                    Nome_do_Produto__c =: produto AND 
                    Nome_da_Tarifa__c =: tarifa
                ORDER BY 
                    Qtd_Min__c,Valor_Maximo__c
                ASC];
            
    }
    
    public static List<String> listarDescricaoProduto() {
        List<AggregateResult> lAr = [SELECT
                                        Nome_do_Produto__c NomeProduto
                                    FROM
                                        Tarifas_Alelo__c
                                    GROUP BY 
                                        Nome_do_Produto__c];
                                        
        List<String> lRetorno = new List<String>();
        
        for(AggregateResult ar : lAr) {
            lRetorno.add((String)ar.get('NomeProduto'));
        }
        
        return lRetorno;
    }
    
    public static List<String> listarDescricaoTarifaPorProduto(String nomeProduto) {
        List<AggregateResult> lAr = [SELECT
                                        Nome_da_Tarifa__c NomeTarifa
                                    FROM
                                        Tarifas_Alelo__c
                                    WHERE
                                        Nome_do_Produto__c =: nomeProduto
                                    GROUP BY 
                                        Nome_da_Tarifa__c];
                                        
        List<String> lRetorno = new List<String>();
        
        for(AggregateResult ar : lAr) {
            lRetorno.add((String)ar.get('NomeTarifa'));
        }
        
        return lRetorno;
    }
}
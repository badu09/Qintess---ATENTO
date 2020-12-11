public class DAOProdutosAlelo {
    public static Produtos_Alelo__c getOpportunityProductId(Id id) {

        return [SELECT
                        Id,
                        Name,
                        Nome_do_Produto__c,
                        Quantidade_de_Cartoes__c,
                        Banco__c,
                        Valor_Mensal_Por_Cartao__c,
                        Tarifa_de_emissao_de_cartao__c,
                        Tarifa_de_reemissao__c,
                        Entrega_Centralizada__c,
                        Tarifa_de_entrega__c,
                        Tarifa_disponibili_mensal_por_cartao__c,
                        Tarifa_de_manutencao_mensal_por_cartao__c,
                        Quantidade_de_usuarios_VT_papel__c,
                        Quantidade_de_usuarios_VT_cartao__c,
                        Valor_medio_mensal_de_compra__c,
                        Quantidade_de_pontos_de_entrega__c,
                        Taxa_de_servico__c,
                        Tarifa_de_atendimento_por_unidade__c,
                        Tarifa_de_comissao_de_administracao__c,
                        Tarifa_de_Rescisao_de_Contrato__c,
                        Disponibilizacao_mensal__c,
                        Oportunidade__r.Id,
                        Codigo_de_Produtos__c,
                        Nome_Empresa_Gravacao_Cartao__c,
                        Valor_Unitario__c,
                        Agencia_Digito__c,
                        Digito__c,
                        Faturamento_Centralizado__c,
                        F_Valor_Total__c,
                        Tarifa_de_atendimento__c,
                        Tarifa_de_Gerenciamento__c,
                        Permitir_Reemissao_Usuario__c,
                        Permitir_Colaboradores_realizem_saque__c,
                        Numero_de_Filiais__c,
                        Quantidade_de_Recarga_Prevista__c,
                        Quantidade_de_Franquia_de_Saque__c,
                        Nivel__c,
                        VT__c,
                        Valor_Total__c ,
                		Agendamento_Retorno_Implanta_o__c,
                        Tabulacao_Pai_Implantacao__c,
                        Tabulacao_Filho_Implantacao__c,
                		FormaPagamento__c,
						Recarga_Certa__c,
                        (
                            SELECT
                                Id,
                                Name,
                                Nome_da_Tarifa__c,
                                Codigo_da_Tarifa__c,
                                Valor_Unitario__c,
                                Valor_Tarifa_Padrao__c,
                                Percentual__c,
                                Valor_Unitario_Prepax__c,
                                CreatedDate
                            FROM
                                Tarifas_Carrinhos__r
                        )
                FROM 
                    Produtos_Alelo__c
                WHERE
                    Id =: id];
    }
    
    
    public static List<Produtos_Alelo__c> getOpportunityProductByOpportunityId(Id opportunityId) 
    {
        List<Produtos_Alelo__c> listProdutosAlelo = new List<Produtos_Alelo__c>();
        
        listProdutosAlelo = [SELECT
                                    Id,
                                    Name,
                                    Nome_do_Produto__c,
                                    Quantidade_de_Cartoes__c,
                                    Valor_Mensal_Por_Cartao__c,
                                    Tarifa_de_emissao_de_cartao__c,
                                    Tarifa_de_reemissao__c,
                                    Tarifa_de_entrega__c,
                                    Tarifa_disponibili_mensal_por_cartao__c,
                                    Tarifa_de_manutencao_mensal_por_cartao__c,
                                    Quantidade_de_usuarios_VT_papel__c,
                                    Quantidade_de_usuarios_VT_cartao__c,
                                    Valor_medio_mensal_de_compra__c,
                                    Quantidade_de_pontos_de_entrega__c,
                                    Taxa_de_servico__c,
                                    Tarifa_de_atendimento_por_unidade__c,
                                    Tarifa_de_comissao_de_administracao__c,
                                    Tarifa_de_Rescisao_de_Contrato__c,
                                    Disponibilizacao_mensal__c,
                                    Valor_Unitario__c,
                                    Entrega_Centralizada__c,
                                    Faturamento_Centralizado__c,
                                    F_Valor_Total__c,
                                    Tarifa_de_atendimento__c,
                                    Digito__c,
                                    Tarifa_de_Gerenciamento__c,
                                    Permitir_Reemissao_Usuario__c,
                                    Permitir_Colaboradores_realizem_saque__c,
                                    Numero_de_Filiais__c,
                                    Quantidade_de_Recarga_Prevista__c,
                                    Quantidade_de_Franquia_de_Saque__c,
                                    Nivel__c,
                                    Numero_do_Contrato__c ,
                                    Retorno_RW__c,
                                    Codigo_CAB__c,
                                    Nome_Empresa_Gravacao_Cartao__c,
                                    Data_Hora_Auditoria__c,
                                    VT__c,	
                                    Codigo_de_Produtos__c, 
                                    Valor_Total__c ,
                                    Agendamento_Retorno_Implanta_o__c,
                                    Tabulacao_Pai_Implantacao__c,
                                    Tabulacao_Filho_Implantacao__c,
									FormaPagamento__c,
									Recarga_Certa__c,
									Valor_Medio_do_Beneficio__c,
                                    (
                                        SELECT
                                            Id,
                                            Name,
                                            Nome_da_Tarifa__c,
                                            Codigo_da_Tarifa__c,
                                            Valor_Unitario__c,
                                			Valor_Tarifa_Padrao__c,
											Percentual__c,
											Valor_Unitario_Prepax__c,
											CreatedDate
                                        FROM
                                            Tarifas_Carrinhos__r
                                    )
                            FROM 
                                Produtos_Alelo__c
                            WHERE
                                Oportunidade__c =: opportunityId];
                                
        return listProdutosAlelo;
    }
    
    public static Produtos_Alelo__c getOpportunityProductByOpportunityIdNameProduct(Id opportunityId, String nomeProduto) {
        Produtos_Alelo__c produtosAlelo = new Produtos_Alelo__c();
        
        produtosAlelo = [SELECT
                                Id,
                                Name,
                                Nome_do_Produto__c,
                                Quantidade_de_Cartoes__c,
                                Valor_Mensal_Por_Cartao__c,
                                Tarifa_de_emissao_de_cartao__c,
                                Tarifa_de_reemissao__c,
                                Tarifa_de_entrega__c,
                                Tarifa_disponibili_mensal_por_cartao__c,
                                Tarifa_de_manutencao_mensal_por_cartao__c,
                                Quantidade_de_usuarios_VT_papel__c,
                                Quantidade_de_usuarios_VT_cartao__c,
                                Valor_medio_mensal_de_compra__c,
                                Quantidade_de_pontos_de_entrega__c,
                                Taxa_de_servico__c,
                                Tarifa_de_atendimento_por_unidade__c,
                                Tarifa_de_comissao_de_administracao__c,
                                Tarifa_de_Rescisao_de_Contrato__c,
                                Disponibilizacao_mensal__c,
                                Entrega_Centralizada__c,
                                Faturamento_Centralizado__c,
                                F_Valor_Total__c,
                                Tarifa_de_atendimento__c,
                                Digito__c,
                                Tarifa_de_Gerenciamento__c,
                                Permitir_Reemissao_Usuario__c,
                                Permitir_Colaboradores_realizem_saque__c,
                                Numero_de_Filiais__c,
                                Quantidade_de_Recarga_Prevista__c,
                                Valor_Unitario__c,
                                Quantidade_de_Franquia_de_Saque__c,
                                Nivel__c
                            FROM 
                                Produtos_Alelo__c
                            WHERE
                                Oportunidade__c =: opportunityId
                            AND
                                Nome_do_Produto__c =: nomeProduto
                            LIMIT 1];
                                
        return produtosAlelo;
    }

	public static List<Produtos_Alelo__c> getProductByContract(String numeroContrato) {
		return [SELECT
				Id,
				Name,
				Nome_do_Produto__c,
				Quantidade_de_Cartoes__c,
				Valor_Mensal_Por_Cartao__c,
				Valor_Unitario__c,
				Disponibilizacao_mensal__c,
				Numero_do_Contrato__c,
				Oportunidade__c
				FROM
		Produtos_Alelo__c
				WHERE
				Numero_do_Contrato__c = :numeroContrato];
	}

	public static List<Produtos_Alelo__c> getProductMetasVendas(Integer mes, Integer ano) {
		Date inicio = Date.newInstance(ano, mes, 1);
		Date fim = Date.newInstance(ano, mes + 1, 1).addDays(-1);
		return [SELECT
					Id,
					Name,
					Oportunidade__r.DataVendaConfirmada__c,
					Oportunidade__r.Vendedor_Atribuido__c,
					Oportunidade__r.Implantador_Atribuido__c,
					Valor_Total__c,
					Oportunidade__c
				FROM
					Produtos_Alelo__c
				WHERE
				Oportunidade__r.DataVendaConfirmada__c >= :inicio
					AND Oportunidade__r.DataVendaConfirmada__c <= :fim];
	}

	public static List<Produtos_Alelo__c> getProductMetasImplantado(Integer mes, Integer ano) {
		Date inicio = Date.newInstance(ano, mes, 1);
		Date fim = Date.newInstance(ano, mes + 1, 1).addDays(-1);
		return [SELECT Id, Oportunidade__r.StageName, Oportunidade__r.Implantador_Atribuido__c, Valor_Total__c, Oportunidade__c  FROM Produtos_Alelo__c WHERE Oportunidade__r.StageName = 'Implantação Concluída' AND Oportunidade__r.Data_da_Implantacao__c >= :inicio AND Oportunidade__r.Data_da_Implantacao__c <= :fim];
	}
    
    public static List<Produtos_Alelo__c> getProductOportunity(set<id> setOpp) {
        List<Produtos_Alelo__c> lstProduto = new List<Produtos_Alelo__c>();
        lstProduto = [Select id,
                      Name,
                      Quantidade_Total_Estrategia__c,
                      Oportunidade__c,
                      Quantidade_Insucesso_Estrategia__c,
                      Agendamento_Retorno_Implanta_o__c,
                      Tabulacao_Pai_Implantacao__c
                      From Produtos_Alelo__c
                      Where Oportunidade__c IN :setOpp Order by Oportunidade__c, Id];
        
        return lstProduto;    
    }
}
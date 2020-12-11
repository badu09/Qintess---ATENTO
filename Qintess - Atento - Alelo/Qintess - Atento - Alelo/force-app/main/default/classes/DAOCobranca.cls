public class DAOCobranca {

    public static List<Cobranca__c> getCarregaCobranca(Set<id> IdOportunidade) {
        return[SELECT
                Id,
                Name,
                Status__c,
               Valor_Pago__c,
               Valor_Previsto__c,
               Data_Vencimento_Boleto__c,
               Tabulacao_Cobranca_Pai__c,
               Tabulacao_Cobranca_Filho__c,
               Valor_Percentual_Pago_Previsto__c,
               Observacao_Cobranca__c,
               Produtos_Alelo__c,
               Oportunidade__c,
               Data_Hora_tabulacao__c,
               Produtos_Alelo__r.Name,
               Produtos_Alelo__r.Numero_do_Contrato__c,
               Produtos_Alelo__r.Valor_Unitario__c,
               Produtos_Alelo__r.Numero_de_Filiais__c,
               Produtos_Alelo__r.F_Valor_Total__c,
               Produtos_Alelo__r.Quantidade_de_Recarga_Prevista__c,
               Produtos_Alelo__r.Nome_Empresa_Gravacao_Cartao__c,
               Produtos_Alelo__r.Quantidade_de_Cartoes__c,
               Produtos_Alelo__r.Qtd_Dias_para_Pagamento__c,
               Produtos_Alelo__r.Banco__c,
               Produtos_Alelo__r.Faturamento__c,
               Produtos_Alelo__r.Agencia_Digito__c,
               Produtos_Alelo__r.Data_Faturamento__c
               FROM
               Cobranca__c
               WHERE
               Oportunidade__c in :IdOportunidade];
    }
    
    public static List<Cobranca__c> getCobrancaByAccountId(Id idConta) {
        return [SELECT
                Id,
                Status__c,
                OwnerId,
                Oportunidade__r.RecordTypeId,
                Oportunidade__r.Id,
                Oportunidade__r.Implantador_Atribuido__c,
                Oportunidade__r.StageName,
                Oportunidade__r.Processo_Implantacao__c
                FROM
        Cobranca__c
                WHERE
                Oportunidade__r.Account.Id =: idConta];

    }
	/**************************************************************************************
	 * Alterado por: Celso Junior - FTI 				Data: 15/02/2018
	 * **********************************************************************************/
    public static Cobranca__c getVerificaStatusCobranca(Id CobrancaID) {
        return[SELECT
               Id,
               Name,
               Status__c,
               Valor_Pago__c,
               Valor_Previsto__c,
               Data_Vencimento_Boleto__c,
               Tabulacao_Cobranca_Pai__c,
               Tabulacao_Cobranca_Filho__c,
               Valor_Percentual_Pago_Previsto__c,
               Observacao_Cobranca__c,
               Produtos_Alelo__c,
               Oportunidade__c,
               Contato_Agendado__c,
               Data_Hora_tabulacao__c,
               Oportunidade__r.Id,
               Oportunidade__r.Implantador_Atribuido__c,
               Oportunidade__r.StageName,
               Oportunidade__r.Processo_Implantacao__c,
               Oportunidade__r.Telefone_Decisor__c,
               Oportunidade__r.Id_da_Campanha__c,
               Oportunidade__r.Name
               
               FROM
               Cobranca__c
               WHERE
               Id = :CobrancaID];
    }
    

}
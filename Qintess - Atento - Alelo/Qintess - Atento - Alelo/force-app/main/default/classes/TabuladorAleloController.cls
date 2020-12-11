public class TabuladorAleloController { //10/12/2020 - 14:11
    
    @AuraEnabled
    public static List<Account> getAccounts(String grupoRelId){
        System.debug('grupoRelId'+grupoRelId);
        if(grupoRelId != ''){
        	return [SELECT Id, Name FROM Account WHERE GrupoRelacionamentoId__c = :grupoRelId];
        } else{
            return new List<Account>();
        }
    }
    
    //  "Obs. Consultor Atento" ?
    @AuraEnabled
    public static Account getAccountInfo(String acctId){
    	return [SELECT Id, Name, GrupoRelacionamentoId__c, CPF_CNPJ__c, Razao_Social__c, Folha_de_Pagto__c, Interlocutor__c, 
                Data_do_ultimo_Contato__c, Data_Agendamento_prox_Contato__c, Risco__c, M_s_de_Reten_o__c, Prazo_de_Blindagem__c,
                Status_do_Grupo__c, Fator_de_Risco__c, Status_do_Risco__c, A_o_P_s_Perda__c, Mes_de_Perda__c, TelefoneAtual__c,
                Email__c, FORNECEDOR_ATUAL_ALIMENTACAO__c, Status_Negociacao_Alimentacao__c, FORNECEDOR_ATUAL_REFEICAO__c,
                Status_Negociacao_Refeicao__c, FORNECEDOR_ATUAL_TRANSPORTE__c, Status_Negociacao_Transporte__c, 
                FORNECEDOR_ATUAL_COMBUSTIVEL__c, Status_Negociacao_Combustivel__c, FORNECEDOR_ATUAL_NATAL__c,
                Status_Negociacao_Natal__c, FORNECEDOR_ATUAL_PR_PAGOS_Premia_o_in__c, Status_Negocia_o_PR_PAGOS_Premia_o__c,
                PR_PAGOS_Despesas__c, Status_Negocia_o_Despesas__c, Fornecedor_Atual_de_Pagamentos__c, 
                Status_Negocia_o_Pagamentos__c FROM Account WHERE Id = :acctId LIMIT 1];
    }
    
    @AuraEnabled
    public static List<Produtos_Alelo__c> getProdutosAleloByAccountId(String accountId){
        List<Opportunity> listOpp = [SELECT Id FROM Opportunity WHERE AccountId = :accountId];
        Map<Id, Opportunity> mapOpp = new Map<Id, Opportunity>(listOpp);
        Set<Id> setIdsOpp = mapOpp.keySet();
        List<Produtos_Alelo__c> produtos = [SELECT Id, Name, Numero_do_Contrato__c, Banco__c FROM Produtos_Alelo__c WHERE Oportunidade__c IN :setIdsOpp];
        return produtos;
    }
    
    @AuraEnabled
    public static List<Produtos_Alelo__c> getProdutosAleloByGrupoRelId(String grupoRelId){
        List<Account> listAcct = [SELECT Id FROM Account WHERE GrupoRelacionamentoId__c = :grupoRelId];
        Map<Id, Account> mapAcct = new Map<Id, Account>(listAcct);
        Set<Id> setIdsAcct = mapAcct.keySet();
        
        List<Opportunity> listOpp = [SELECT Id FROM Opportunity WHERE AccountId IN :setIdsAcct];
        Map<Id, Opportunity> mapOpp = new Map<Id, Opportunity>(listOpp);
        Set<Id> setIdsOpp = mapOpp.keySet();
        
        List<Produtos_Alelo__c> produtos = [SELECT Id, Name, Numero_do_Contrato__c, Banco__c FROM Produtos_Alelo__c WHERE Oportunidade__c IN :setIdsOpp];
        return produtos;
    }

    //Ações 
    
    @AuraEnabled
    public static void consolidar(List<Id> ids, Map<String, String> params){
    	//Update em todas as contas que pertencem ao Grupo de Relacionamento
    }
    
    // ----- Retornar valores dos campos Picklist ----- //
    
    @AuraEnabled //Folha de Pagamento
    public static List<String> getPickListValuesFolhaDePagto(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Folha_de_Pagto__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Risco
    public static List<String> getPickListValuesRisco(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Risco__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Prazo de Blindagem
    public static List<String> getPickListValuesPrazodeBlindagem(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Prazo_de_Blindagem__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Status do Grupo
    public static List<String> getPickListValuesStatusdoGrupo(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Status_do_Grupo__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Fator de Risco 
    public static List<String> getPickListValuesFatordeRisco(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Fator_de_Risco__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Status de Risco
    public static List<String> getPickListValuesStatusdeRisco(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Status_do_Risco__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Ação Pós Perda
    public static List<String> getPickListValuesAcaoPosPerda(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.A_o_P_s_Perda__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Forn. Atual de alimentação
    public static List<String> getPickListValuesFornAtualAlimentacao(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.FORNECEDOR_ATUAL_ALIMENTACAO__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Forn. Atual de Refeição
    public static List<String> getPickListValuesFornAtualRefeicao(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.FORNECEDOR_ATUAL_REFEICAO__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Forn. Atual de Transporte
    public static List<String> getPickListValuesFornAtualTransporte(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.FORNECEDOR_ATUAL_TRANSPORTE__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Forn. Atual de Combustível
    public static List<String> getPickListValuesFornAtualCombustivel(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.FORNECEDOR_ATUAL_COMBUSTIVEL__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Status de Negociação (Alimentação)
    public static List<String> getPickListValuesStatusAlimentacao(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Status_Negociacao_Alimentacao__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Status de Negociação (Refeição)
    public static List<String> getPickListValuesStatusRefeicao(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Status_Negociacao_Refeicao__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Status de Negociação (Transporte)
    public static List<String> getPickListValuesStatusTransporte(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Status_Negociacao_Transporte__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Status de Negociação (Combustível)
    public static List<String> getPickListValuesStatusCombustivel(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Status_Negociacao_Combustivel__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Forn. Atual de Natal
    public static List<String> getPickListValuesFornAtualNatal(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.FORNECEDOR_ATUAL_NATAL__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Forn. Atual de Premiação
    public static List<String> getPickListValuesFornAtualPremiacao(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.FORNECEDOR_ATUAL_PR_PAGOS_Premia_o_in__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Forn. Atual de Despesas
    public static List<String> getPickListValuesFornAtualDespesas(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.PR_PAGOS_Despesas__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Forn. Atual de Pagamentos
    public static List<String> getPickListValuesFornAtualPagamentos(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Fornecedor_Atual_de_Pagamentos__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
 
    @AuraEnabled //Status de Negociação (Natal)
    public static List<String> getPickListValuesStatusNatal(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Status_Negociacao_Natal__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Status de Negociação (Premiação)
    public static List<String> getPickListValuesStatusPremiacao(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Status_Negocia_o_PR_PAGOS_Premia_o__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Status de Negociação (Despesas)
    public static List<String> getPickListValuesStatusDespesas(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Status_Negocia_o_Despesas__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
    @AuraEnabled //Status de Negociação (Pagamentos)
    public static List<String> getPickListValuesStatusPagamentos(){
        List<String> values = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Status_Negocia_o_Pagamentos__c.getDescribe();
        List<Schema.PicklistEntry> entries = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry entry : entries){
            values.add(entry.getLabel());
        }
        return values;
    }
    
}
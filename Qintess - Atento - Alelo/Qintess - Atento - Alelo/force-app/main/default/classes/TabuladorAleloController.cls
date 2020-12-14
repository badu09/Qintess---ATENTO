public class TabuladorAleloController {
    
    @AuraEnabled
    public static List<Account> getAccounts(String grupoRelId){
        System.debug('grupoRelId'+grupoRelId);
        if(grupoRelId != ''){
        	return [SELECT Id, Name FROM Account WHERE GrupoRelacionamentoId__c = :grupoRelId];
        } else{
            return new List<Account>();
        }
    }
    
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
    public static String getNameUser(){
        String UserId = UserInfo.getUserId();
        User myUser = [SELECT Id, Name FROM User WHERE Id = :UserId LIMIT 1];
        return myUser.Name;
    }
    
    @AuraEnabled
    public static List<Produtos_Alelo__c> getProdutosAleloByAccountId(String accountId){
        List<Opportunity> listOpp = [SELECT Id FROM Opportunity WHERE AccountId = :accountId];
        Map<Id, Opportunity> mapOpp = new Map<Id, Opportunity>(listOpp);
        Set<Id> setIdsOpp = mapOpp.keySet();
        List<Produtos_Alelo__c> produtos = [SELECT Id, Name, Numero_do_Contrato__c, Banco__c, Faturamento__c FROM Produtos_Alelo__c WHERE Oportunidade__c IN :setIdsOpp];
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
        
        List<Produtos_Alelo__c> produtos = [SELECT Id, Name, Numero_do_Contrato__c, Banco__c, Faturamento__c FROM Produtos_Alelo__c WHERE Oportunidade__c IN :setIdsOpp];
        return produtos;
    }

    //Ações 
    
    @AuraEnabled
    public static void consolidar(List<Id> ids, Map<String, String> params, Boolean isCnpj){
        System.debug('consolidar'+ids);
        System.debug('isCnpj'+isCnpj);
        System.debug('params'+params);
        System.debug('params date '+params.get('risco'));
        Map<Id, Account> mapAcct = new Map<Id, Account>([SELECT Id, CPF_CNPJ__c FROM Account WHERE Id IN :ids]);
        List<Account> listAcctToUpdate = new List<Account>();
        
        for(Id idAcct : ids){
            Account acct = mapAcct.get(idAcct);
            if (params.get('cnpj') != null && isCnpj == true){
                System.debug('cnpj animal');
                acct.CPF_CNPJ__c = params.get('cnpj');
            } else {
                acct.CPF_CNPJ__c = acct.CPF_CNPJ__c; 
            }
                
            if (params.get('razaoSocial') != null && isCnpj == true) 
                acct.Razao_Social__c = params.get('razaoSocial');
            if (params.get('folhaDePagto') != null) 
                acct.Folha_de_Pagto__c = params.get('folhaDePagto');
            if (params.get('interlocutor') != null) 
                acct.Interlocutor__c = params.get('interlocutor');
            if (params.get('dataDoUltimoContato') != null) 
                acct.Data_do_ultimo_Contato__c = Date.valueOf(params.get('dataDoUltimoContato'));
            if (params.get('dataAgendamentoProxContato') != null) 
                acct.Data_Agendamento_prox_Contato__c = Date.valueOf(params.get('dataAgendamentoProxContato'));
            if (params.get('risco') != null) 
                System.debug('o risco esta aqui');
                acct.Risco__c = params.get('risco');
            if (params.get('mesDeRetencao') != null) 
                acct.M_s_de_Reten_o__c = Date.valueOf(params.get('mesDeRetencao'));
            if (params.get('prazoDeBlindagem') != null) 
                acct.Prazo_de_Blindagem__c = params.get('prazoDeBlindagem');
            if (params.get('statusDoGrupo') != null) 
                acct.Status_do_Grupo__c = params.get('statusDoGrupo');
            if (params.get('fatorDeRisco') != null) 
                acct.Fator_de_Risco__c = params.get('fatorDeRisco');
            if (params.get('statusDoRisco') != null) 
                acct.Status_do_Risco__c = params.get('statusDoRisco');
            if (params.get('acaoPosPerda') != null) 
                acct.A_o_P_s_Perda__c = params.get('acaoPosPerda');
            if (params.get('mesDePerda') != null) 
                acct.Mes_de_Perda__c = Date.valueOf(params.get('mesDePerda'));
            if (params.get('telefone') != null && isCnpj == true) 
                acct.TelefoneAtual__c = params.get('telefone');
            if (params.get('email') != null && isCnpj == true) 
                acct.Email__c = params.get('email');
            if (params.get('fornAlimentacao') != null) 
                acct.FORNECEDOR_ATUAL_ALIMENTACAO__c = params.get('fornAlimentacao');
            if (params.get('statusAlimentacao') != null) 
                acct.Status_Negociacao_Alimentacao__c = params.get('statusAlimentacao');
            if (params.get('fornRefeicao') != null) 
                acct.FORNECEDOR_ATUAL_REFEICAO__c = params.get('fornRefeicao');
            if (params.get('statusRefeicao') != null) 
                acct.Status_Negociacao_Refeicao__c = params.get('statusRefeicao');
            if (params.get('fornTransporte') != null) 
                acct.FORNECEDOR_ATUAL_TRANSPORTE__c = params.get('fornTransporte');
            if (params.get('statusTransporte') != null) 
                acct.Status_Negociacao_Transporte__c = params.get('statusTransporte');
            if (params.get('fornCombustivel') != null) 
                acct.FORNECEDOR_ATUAL_COMBUSTIVEL__c = params.get('fornCombustivel');
            if (params.get('statusCombustivel') != null) 
                acct.Status_Negociacao_Combustivel__c = params.get('statusCombustivel');
            if (params.get('fornNatal') != null) 
                acct.FORNECEDOR_ATUAL_NATAL__c = params.get('fornNatal');
            if (params.get('statusNatal') != null) 
                acct.Status_Negociacao_Natal__c = params.get('statusNatal');
            if (params.get('fornPremiacao') != null) 
                acct.FORNECEDOR_ATUAL_PR_PAGOS_Premia_o_in__c = params.get('fornPremiacao');
            if (params.get('statusPremiacao') != null) 
                acct.Status_Negocia_o_PR_PAGOS_Premia_o__c = params.get('statusPremiacao');
            if (params.get('fornDespesas') != null) 
                acct.PR_PAGOS_Despesas__c = params.get('fornDespesas');
            if (params.get('statusDespesas') != null) 
                acct.Status_Negocia_o_Despesas__c = params.get('statusDespesas');
            if (params.get('fornPagamentos') != null) 
                acct.Fornecedor_Atual_de_Pagamentos__c = params.get('fornPagamentos');
            if (params.get('statusPagamentos') != null) 
                acct.Status_Negocia_o_Pagamentos__c = params.get('statusPagamentos');
            listAcctToUpdate.add(acct);
        }
        if(!listAcctToUpdate.isEmpty()) update listAcctToUpdate;
        
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
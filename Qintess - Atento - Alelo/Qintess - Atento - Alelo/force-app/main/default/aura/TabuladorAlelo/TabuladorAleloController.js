({
	myAction : function(component, event, helper) {
		//helper.getAccount(component, event);
        helper.getList(component, "c.getPickListValuesFolhaDePagto", "v.valuesFolhaDePagto");//Folha de Pagamento
        helper.getList(component, "c.getPickListValuesRisco", "v.valuesRisco");//Risco
        //helper.getList(component, "c.getPickListValuesMesdeRetencao", "v.valuesMesdeRetencao");//Mês de Retenção
        helper.getList(component, "c.getPickListValuesPrazodeBlindagem", "v.valuesPrazodeBlindagem"); //Prazo de Blindagem
        helper.getList(component, "c.getPickListValuesStatusdoGrupo", "v.valuesStatusdoGrupo");//Status do Grupo
        helper.getList(component, "c.getPickListValuesFatordeRisco", "v.valuesFatordeRisco");//Fator de Risco 
        helper.getList(component, "c.getPickListValuesStatusdeRisco", "v.valuesStatusdeRisco");//Status de Risco
        helper.getList(component, "c.getPickListValuesAcaoPosPerda", "v.valuesAcaoPosPerda");//Mês Pós Perda
        //helper.getList(component, "c.getPickListValuesMesPosPerda", "v.valuesMesPosPerda");//Mês Pós Perda
        helper.getList(component, "c.getPickListValuesFornAtualAlimentacao", "v.valuesFornAtualAlimentacao");//Forn. Atual de alimentação
        helper.getList(component, "c.getPickListValuesFornAtualRefeicao", "v.valuesFornAtualRefeicao");//Forn. Atual de Refeição
        helper.getList(component, "c.getPickListValuesFornAtualTransporte", "v.valuesFornAtualTransporte");//Forn. Atual de Transporte
        helper.getList(component, "c.getPickListValuesFornAtualCombustivel", "v.valuesFornAtualCombustivel");//Forn. Atual de Combustivel
        
        helper.getList(component, "c.getPickListValuesStatusAlimentacao", "v.statusValuesFornAtualAlimentacao");//Status Forn. Atual de alimentação
        helper.getList(component, "c.getPickListValuesStatusRefeicao", "v.statusValuesFornAtualRefeicao");//Status Forn. Atual de Refeição
        helper.getList(component, "c.getPickListValuesStatusTransporte", "v.statusValuesFornAtualTransporte");//Status Forn. Atual de Transporte
        helper.getList(component, "c.getPickListValuesStatusCombustivel", "v.statusValuesFornAtualCombustivel");//Status Forn. Atual de Combustivel
        
        helper.getList(component, "c.getPickListValuesFornAtualNatal", "v.valuesFornAtualNatal");//Forn. Atual de Natal
        helper.getList(component, "c.getPickListValuesFornAtualPremiacao", "v.valuesFornAtualPremiacao");//Forn. Atual de Premiação
        helper.getList(component, "c.getPickListValuesFornAtualDespesas", "v.valuesFornAtualDespesas");//Forn. Atual de Despesas
        helper.getList(component, "c.getPickListValuesFornAtualPagamentos", "v.valuesFornAtualPagamentos");//Forn. Atual de Pagamentos
        
        helper.getList(component, "c.getPickListValuesStatusNatal", "v.statusValuesFornAtualNatal");//Status Forn. Atual de alimentação
        helper.getList(component, "c.getPickListValuesStatusPremiacao", "v.statusValuesFornAtualPremiacao");//Status Forn. Atual de Refeição
        helper.getList(component, "c.getPickListValuesStatusDespesas", "v.statusValuesFornAtualDespesas");//Status Forn. Atual de Transporte
        helper.getList(component, "c.getPickListValuesStatusPagamentos", "v.statusValuesFornAtualPagamentos");//Status Forn. Atual de Combustivel
        
        component.set('v.tableColumns', [
            {label: 'Contrato', fieldName: 'Numero_do_Contrato__c', type: 'text'},//Nome_do_Contrato__c
            {label: 'Banco', fieldName: 'Banco__c', type: 'text'},//Id_da_Conta__c
            {label: 'Produto', fieldName: 'Name', type: 'text'},//Name
            {label: 'Fat Médio', fieldName: 'Id', type: 'currency', typeAttributes: { currencyCode: 'BR', maximumSignificantDigits: 5}},
        ]);

    },
    getGroupId: function(component, event, helper){
        var groupId = event.getSource().get("v.value");
        console.log(groupId);
        helper.getAccount(component, event, groupId);
    },
    getAccountId : function(component, event, helper) {
        var accountId = event.getSource().get("v.value");
        helper.getAccountData(component, event, accountId);
        helper.getProdutoAlelo(component, accountId);
    },
    consolidarId: function(component, event, helper){
            
    }
})
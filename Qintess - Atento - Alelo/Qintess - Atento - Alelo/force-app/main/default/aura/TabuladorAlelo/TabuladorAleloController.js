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
            {label: 'Fat Médio', fieldName: 'Faturamento__c', type: 'text'},
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
    consolidarId: function(cmp, event, helper){
        console.log('Aqui Aqui');
        var theMap = cmp.get("v.theMap");
            
        var idList = [cmp.find("grupoRel").get("v.value")];
                      
        if(idList != ''){
            theMap["cnpj"] = cmp.find("textAccountCNPJ").get("v.value");
            theMap["razaoSocial"] = cmp.find("textAccountRazaoSocial").get("v.value");
            theMap["folhaDePagto"] = cmp.find("folhaPgto").get("v.value");
            theMap["interlocutor"] = cmp.find("interlocutor").get("v.value");
            if(cmp.find("dataUltimoContato").get("v.value") != ''){
                theMap["dataDoUltimoContato"] = cmp.find("dataUltimoContato").get("v.value");
            } else {
                theMap["dataDoUltimoContato"] = null;
            }
            if(cmp.find("dataAgendProxContato").get("v.value") != ''){
                theMap["dataAgendamentoProxContato"] = cmp.find("dataAgendProxContato").get("v.value");
            } else {
                theMap["dataAgendamentoProxContato"] = null;
            }
            theMap["risco"] = cmp.find("risco").get("v.value");
            if(cmp.find("mesRetencao").get("v.value") != ''){
                theMap["mesDeRetencao"] = cmp.find("mesRetencao").get("v.value");
            } else {
                theMap["mesDeRetencao"] = null;
            }
            theMap["prazoDeBlindagem"] = cmp.find("prazodeBlindagem").get("v.value");
            theMap["statusDoGrupo"] = cmp.find("statusdoGrupo").get("v.value");
            theMap["fatorDeRisco"] = cmp.find("fator_deRisco").get("v.value");
            theMap["statusDoRisco"] = cmp.find("statusdeRisco").get("v.value");
            theMap["acaoPosPerda"] = cmp.find("acaoPosPerda").get("v.value");
            if(cmp.find("mesPosPerda").get("v.value") != ''){
                theMap["mesDePerda"] = cmp.find("mesPosPerda").get("v.value");
            } else {
                theMap["mesDePerda"] = null;
            }
            theMap["telefone"] = cmp.find("textTelefone").get("v.value");
            theMap["email"] = cmp.find("textEmail").get("v.value");
            theMap["fornAlimentacao"] = cmp.find("fornAtualAlimentacao").get("v.value");
            theMap["statusAlimentacao"] = cmp.find("statusFornAtualAlimentacao").get("v.value");
            theMap["fornRefeicao"] = cmp.find("fornAtualRefeicao").get("v.value");
            theMap["statusRefeicao"] = cmp.find("statusFornAtualRefeicao").get("v.value");
            theMap["fornTransporte"] = cmp.find("fornAtualTransporte").get("v.value");
            theMap["statusTransporte"] = cmp.find("statusFornAtualTransporte").get("v.value");
            theMap["fornCombustivel"] = cmp.find("fornAtualCombustivel").get("v.value");
            theMap["statusCombustivel"] = cmp.find("statusFornAtualCombustivel").get("v.value");
            theMap["fornNatal"] = cmp.find("fornAtualNatal").get("v.value");
            theMap["statusNatal"] = cmp.find("statusFornAtualNatal").get("v.value");
            theMap["fornPremiacao"] = cmp.find("fornAtualPremiacao").get("v.value");
            theMap["statusPremiacao"] = cmp.find("statusFornAtualPremiacao").get("v.value");
            theMap["fornDespesas"] = cmp.find("fornAtualDespesas").get("v.value");
            theMap["statusDespesas"] = cmp.find("statusFornAtualDespesas").get("v.value");
            theMap["fornPagamentos"] = cmp.find("fornAtualPagamentos").get("v.value");
            theMap["statusPagamentos"] = cmp.find("statusFornAtualPagamentos").get("v.value");
            
            
            //console.log('never', params);
            console.log('idList', idList);
            console.log('map', theMap);
            helper.consolidar(cmp, event, idList, theMap, true);    
        } else {
            helper.showToastMessage(cmp, event, 'Erro', 'Grupo_Rel não pode ficar vazio', 'Error');
        }
        
        
    }, 
    consolidarCNPJ: function(cmp, event, helper){
        
        var idList = cmp.get("v.idLists");
        
        if(idList != ''){
            var theMap = cmp.get("v.theMap");
            
            theMap["cnpj"] = cmp.find("textAccountCNPJ").get("v.value");
            theMap["razaoSocial"] = cmp.find("textAccountRazaoSocial").get("v.value");
            theMap["folhaDePagto"] = cmp.find("folhaPgto").get("v.value");
            theMap["interlocutor"] = cmp.find("interlocutor").get("v.value");
            if(cmp.find("dataUltimoContato").get("v.value") != ''){
                theMap["dataDoUltimoContato"] = cmp.find("dataUltimoContato").get("v.value");
            } else {
                theMap["dataDoUltimoContato"] = null;
            }
            if(cmp.find("dataAgendProxContato").get("v.value") != ''){
                theMap["dataAgendamentoProxContato"] = cmp.find("dataAgendProxContato").get("v.value");
            } else {
                theMap["dataAgendamentoProxContato"] = null;
            }
            theMap["risco"] = cmp.find("risco").get("v.value");
            if(cmp.find("mesRetencao").get("v.value") != ''){
                theMap["mesDeRetencao"] = cmp.find("mesRetencao").get("v.value");
            } else {
                theMap["mesDeRetencao"] = null;
            }
            theMap["prazoDeBlindagem"] = cmp.find("prazodeBlindagem").get("v.value");
            theMap["statusDoGrupo"] = cmp.find("statusdoGrupo").get("v.value");
            theMap["fatorDeRisco"] = cmp.find("fator_deRisco").get("v.value");
            theMap["statusDoRisco"] = cmp.find("statusdeRisco").get("v.value");
            theMap["acaoPosPerda"] = cmp.find("acaoPosPerda").get("v.value");
            if(cmp.find("mesPosPerda").get("v.value") != ''){
                theMap["mesDePerda"] = cmp.find("mesPosPerda").get("v.value");
            } else {
                theMap["mesDePerda"] = null;
            }
            theMap["telefone"] = cmp.find("textTelefone").get("v.value");
            theMap["email"] = cmp.find("textEmail").get("v.value");
            theMap["fornAlimentacao"] = cmp.find("fornAtualAlimentacao").get("v.value");
            theMap["statusAlimentacao"] = cmp.find("statusFornAtualAlimentacao").get("v.value");
            theMap["fornRefeicao"] = cmp.find("fornAtualRefeicao").get("v.value");
            theMap["statusRefeicao"] = cmp.find("statusFornAtualRefeicao").get("v.value");
            theMap["fornTransporte"] = cmp.find("fornAtualTransporte").get("v.value");
            theMap["statusTransporte"] = cmp.find("statusFornAtualTransporte").get("v.value");
            theMap["fornCombustivel"] = cmp.find("fornAtualCombustivel").get("v.value");
            theMap["statusCombustivel"] = cmp.find("statusFornAtualCombustivel").get("v.value");
            theMap["fornNatal"] = cmp.find("fornAtualNatal").get("v.value");
            theMap["statusNatal"] = cmp.find("statusFornAtualNatal").get("v.value");
            theMap["fornPremiacao"] = cmp.find("fornAtualPremiacao").get("v.value");
            theMap["statusPremiacao"] = cmp.find("statusFornAtualPremiacao").get("v.value");
            theMap["fornDespesas"] = cmp.find("fornAtualDespesas").get("v.value");
            theMap["statusDespesas"] = cmp.find("statusFornAtualDespesas").get("v.value");
            theMap["fornPagamentos"] = cmp.find("fornAtualPagamentos").get("v.value");
            theMap["statusPagamentos"] = cmp.find("statusFornAtualPagamentos").get("v.value");
            
            //console.log('never', params);
            console.log('listId', idList);
            console.log('map', theMap);
            helper.consolidar(cmp, event, idList, theMap, false);
        } else {
            helper.showToastMessage(cmp, event, 'Erro', 'Grupo_Rel não pode ficar vazio, digite um Id para procurar um grupo valido', 'Error');
        }
            
    },
    reset: function(cmp, event, helper){
        helper.resetFields(cmp, event);
    }
})
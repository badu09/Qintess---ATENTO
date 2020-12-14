({
	helperMethod : function() {
		
	},
    
    //Função para retornar lista de contas
    getAccount: function(cmp, event, groupId){
        var action = cmp.get("c.getAccounts");//função pra retornar lista de Contas
        action.setParams({
        	grupoRelId: groupId
        });
        var accountList = [];
        var idList = [];
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = response.getReturnValue();
            console.log('data',data);
            if(state === "SUCCESS"){
                if(data.length > 0){
                    for (var dt in data){
                        accountList.push({label: data[dt].Name, value: data[dt].Id});
                        idList.push(data[dt].Id);
                    }
                } else {
					accountList.push({label: "Lista de Contas vazia", value: ""});                    
                }
                cmp.set("v.accountList", accountList);
                cmp.set("v.idLists", idList);
            } else {
                var errors = data.getError();
                if (errors[0] && errors[0].message) {
                	console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    //Função para popular listas
    getList: function(cmp, list, frontCmp){
    	var action = cmp.get(list);
        
        var returnList = [];
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = response.getReturnValue();
            if(state === "SUCCESS"){
                if(data.length > 0){
                    for (var dt in data){
                        returnList.push({label: data[dt], value: data[dt]});
                    }
                } else {
					returnList.push({label: "Lista vazia", value: ""});                    
                }
                cmp.set(frontCmp, returnList);
            } else {
                var errors = data.getError();
                if (errors[0] && errors[0].message) {
                	console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
	},
    
    getAccountData : function(cmp, event, accountId){
    	var action = cmp.get("c.getAccountInfo");
        action.setParams({
        	acctId: accountId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = response.getReturnValue();
            console.log('accountData'+data.Email__c);
            if(state === "SUCCESS"){
                cmp.find("textAccountCNPJ").set("v.value", data.CPF_CNPJ__c);
                cmp.find("textAccountRazaoSocial").set("v.value", data.Razao_Social__c);
                cmp.find("textTelefone").set("v.value", data.TelefoneAtual__c);
                cmp.find("textEmail").set("v.value", data.Email__c);
                
                cmp.find("textAccountRazaoSocial").set("v.value", data.Razao_Social__c);
                cmp.find("folhaPgto").set("v.value", data.Folha_de_Pagto__c);
                cmp.find("interlocutor").set("v.value", data.Interlocutor__c);
                cmp.find("dataUltimoContato").set("v.value", data.Data_do_ultimo_Contato__c);
                cmp.find("dataAgendProxContato").set("v.value", data.Data_Agendamento_prox_Contato__c);
                cmp.find("risco").set("v.value", data.Risco__c);
                cmp.find("mesRetencao").set("v.value", data.M_s_de_Reten_o__c);
                cmp.find("prazodeBlindagem").set("v.value", data.Prazo_de_Blindagem__c);
                cmp.find("statusdoGrupo").set("v.value", data.Status_do_Grupo__c);
                cmp.find("fator_deRisco").set("v.value", data.Fator_de_Risco__c);
                cmp.find("statusdeRisco").set("v.value", data.Status_do_Risco__c);
                cmp.find("acaoPosPerda").set("v.value", data.A_o_P_s_Perda__c);
                cmp.find("mesPosPerda").set("v.value", data.Mes_de_Perda__c);
                cmp.find("fornAtualAlimentacao").set("v.value", data.FORNECEDOR_ATUAL_ALIMENTACAO__c);
                cmp.find("fornAtualRefeicao").set("v.value", data.FORNECEDOR_ATUAL_REFEICAO__c);
                cmp.find("fornAtualTransporte").set("v.value", data.FORNECEDOR_ATUAL_TRANSPORTE__c);
                cmp.find("fornAtualCombustivel").set("v.value", data.FORNECEDOR_ATUAL_COMBUSTIVEL__c);
                cmp.find("statusFornAtualAlimentacao").set("v.value", data.Status_Negociacao_Alimentacao__c);
                cmp.find("statusFornAtualRefeicao").set("v.value", data.Status_Negociacao_Refeicao__c);
                cmp.find("statusFornAtualTransporte").set("v.value", data.Status_Negociacao_Transporte__c);
                cmp.find("statusFornAtualCombustivel").set("v.value", data.Status_Negociacao_Combustivel__c);
                cmp.find("fornAtualNatal").set("v.value", data.FORNECEDOR_ATUAL_NATAL__c);
                cmp.find("fornAtualPremiacao").set("v.value", data.FORNECEDOR_ATUAL_PR_PAGOS_Premia_o_in__c);
                cmp.find("fornAtualDespesas").set("v.value", data.PR_PAGOS_Despesas__c);
                cmp.find("fornAtualPagamentos").set("v.value", data.Fornecedor_Atual_de_Pagamentos__c);
                cmp.find("statusFornAtualNatal").set("v.value", data.Status_Negociacao_Natal__c);
                cmp.find("statusFornAtualPremiacao").set("v.value", data.Status_Negocia_o_PR_PAGOS_Premia_o__c);
                cmp.find("statusFornAtualDespesas").set("v.value", data.Status_Negocia_o_Despesas__c);
                cmp.find("statusFornAtualPagamentos").set("v.value", data.Status_Negocia_o_Pagamentos__c);
                if(data.Grupo_de_Relacionamento__c != null){
                    this.getGrupoRelacionamento(cmp, data.Grupo_de_Relacionamento__c);
                }
            } else {
                var errors = data.getError();
                if (errors[0] && errors[0].message) {
                	console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
	},
    getGrupoRelacionamento: function (cmp, grupoRelacionamentoId){
        var action = cmp.get("c.getGrupoDeRelacionamento");
        action.setParams({
        	grupoRelId: grupoRelacionamentoId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = response.getReturnValue();
            if(state === "SUCCESS"){
                cmp.find("dataAgendProxContato").set("v.value", data.Data_Agendamento_prox_Contato__c);
                cmp.find("dataUltimoContato").set("v.value", data.Data_do_ltimo_Contato__c);
            } else {
                var errors = data.getError();
                if (errors[0] && errors[0].message) {
                	console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    getProdutoAlelo: function (cmp, accountId){
        var action = cmp.get("c.getProdutosAleloByAccountId");
        action.setParams({
        	accountId: accountId
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = response.getReturnValue();
            if(state === "SUCCESS"){
                cmp.set('v.dataTable', data);
            } else {
                var errors = data.getError();
                if (errors[0] && errors[0].message) {
                    this.showToastMessage(cmp, event, 'Erro', errors[0].message, 'Error');
                	console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },
    consolidar: function (cmp, event, idList, mapParams, isCnpj){
        cmp.set("v.loading", true);
        var action = cmp.get("c.consolidar");
        action.setParams({
        	ids: idList,
            params: mapParams,
            isCnpj: isCnpj
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if(state === "SUCCESS"){
                this.showToastMessage(cmp, event, 'Sucesso', 'Informações salvas com sucesso', 'Success');
                console.log("success");
            } else {
                var errors = response.getError();
                if (errors[0] && errors[0].message) {
                    this.showToastMessage(cmp, event, 'Erro', errors[0].message, 'Error');
                	console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
        cmp.set("v.loading", false);
    },
    showToastMessage: function(cmp, event, title, message, type){
    	var toast = $A.get("e.force:showToast");
        if (toast){
            //fire the toast event in Salesforce app and Lightning Experience
            toast.setParams({
                "title": title,
                "message": message,
                "type": type
            });
            toast.fire();
        }
    },
    resetFields: function (cmp, event){
        cmp.find("groupIdText").set("v.value", "");
        cmp.find("textAccountCNPJ").set("v.value", "");
        cmp.find("textAccountRazaoSocial").set("v.value", "");
        cmp.find("textTelefone").set("v.value", "");
        cmp.find("textEmail").set("v.value", "");
        
        cmp.find("textAccountRazaoSocial").set("v.value", "");
        cmp.find("folhaPgto").set("v.value", "");
        cmp.find("interlocutor").set("v.value", "");
        cmp.find("dataUltimoContato").set("v.value", "");
        cmp.find("dataAgendProxContato").set("v.value", "");
        cmp.find("risco").set("v.value", "");
        cmp.find("mesRetencao").set("v.value", "");
        cmp.find("prazodeBlindagem").set("v.value", "");
        cmp.find("statusdoGrupo").set("v.value", "");
        cmp.find("fator_deRisco").set("v.value", "");
        cmp.find("statusdeRisco").set("v.value", "");
        cmp.find("acaoPosPerda").set("v.value", "");
        cmp.find("mesPosPerda").set("v.value", "");
        cmp.find("fornAtualAlimentacao").set("v.value", "");
        cmp.find("fornAtualRefeicao").set("v.value", "");
        cmp.find("fornAtualTransporte").set("v.value", "");
        cmp.find("fornAtualCombustivel").set("v.value", "");
        cmp.find("statusFornAtualAlimentacao").set("v.value", "");
        cmp.find("statusFornAtualRefeicao").set("v.value", "");
        cmp.find("statusFornAtualTransporte").set("v.value", "");
        cmp.find("statusFornAtualCombustivel").set("v.value", "");
        cmp.find("fornAtualNatal").set("v.value", "");
        cmp.find("fornAtualPremiacao").set("v.value", "");
        cmp.find("fornAtualDespesas").set("v.value", "");
        cmp.find("fornAtualPagamentos").set("v.value", "");
        cmp.find("statusFornAtualNatal").set("v.value", "");
        cmp.find("statusFornAtualPremiacao").set("v.value", "");
        cmp.find("statusFornAtualDespesas").set("v.value", "");
        cmp.find("statusFornAtualPagamentos").set("v.value", "");
        cmp.find("textConsultorAtento").set('v.value', "");
        cmp.find("grupoRel").set('v.value', "");
    },
    getConsultor: function(cmp, event){
        var action = cmp.get("c.getNameUser");
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = response.getReturnValue();
            console.log('consultor data', data);
            if(state === "SUCCESS"){
                cmp.find("textConsultorAtento").set('v.value', data);
                console.log("success");
            } else {
                var errors = response.getError();
                if (errors[0] && errors[0].message) {
                    this.showToastMessage(cmp, event, 'Erro', errors[0].message, 'Error');
                	console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    }
    
})
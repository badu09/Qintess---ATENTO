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
        action.setCallback(this, function (response) {
            var state = response.getState();
            var data = response.getReturnValue();
            console.log('data',data);
            if(state === "SUCCESS"){
                if(data.length > 0){
                    for (var dt in data){
                        accountList.push({label: data[dt].Name, value: data[dt].Id});
                    }
                } else {
					accountList.push({label: "Lista de Contas vazia", value: ""});                    
                }
                cmp.set("v.accountList", accountList);
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
    }
    
})
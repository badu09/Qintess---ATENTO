trigger RetornoFilaBancoIndicacaoAtualizada on Lead (after update) {

    if(Trigger.isUpdate){
        List<Lead> leadUpdate = new List<Lead>();
        Map<String, String> mapFilas = new Map<String, Id>();
        List<Group> filas = [SELECT Id, DeveloperName FROM Group];


        for(Group fila : filas){
            mapFilas.put(fila.DeveloperName, fila.Id);
        }

        for(Lead lead : [SELECT Id, RecordType.DeveloperName, Qtd_Tentativas_Realizadas__c,
        Owner.Name, Status, Codigo_Banco__c FROM Lead WHERE Id IN: Trigger.new]) {
        system.Debug(lead);
            if(lead.RecordType.DeveloperName.equals('Banco')
                    && lead.Qtd_Tentativas_Realizadas__c > 10
                    && lead.Owner.Name.equals('Descartados')
                    && lead.Status.equals('INDICAÇÃO ATUALIZADA (007)')){

                if(lead.Codigo_Banco__c.equals('1')){
                    lead.OwnerId =  mapFilas.get('IlhaBancosBancodoBrasilAtualizada');
                    lead.Qtd_Tentativas_Realizadas__c = 0;
                    lead.Motivo_Detalhado__c = '';
                    
                }

                if(lead.Codigo_Banco__c.equals('33')){
                    lead.OwnerId = mapFilas.get('IlhaBancosSantanterAtualizada');
                    lead.Qtd_Tentativas_Realizadas__c = 0;
                    lead.Motivo_Detalhado__c = '';
                }

                if(lead.Codigo_Banco__c.equals('237')){
                    lead.OwnerId = mapFilas.get('IlhaBancosBradescoAtualizada');
                    lead.Qtd_Tentativas_Realizadas__c = 0;
                    lead.Motivo_Detalhado__c = '';
                }

                leadUpdate.add(lead);
            }
        }
        update leadUpdate;
    }
}
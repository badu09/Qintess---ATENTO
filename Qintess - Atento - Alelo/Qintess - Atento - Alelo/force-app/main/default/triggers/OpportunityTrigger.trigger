trigger OpportunityTrigger on Opportunity(before update) {
    IF (Trigger.isBefore && Trigger.isUpdate) {
        List<Opportunity> lstOpp = Trigger.Old;
        Map<Id, Opportunity> mapNewOpp = Trigger.newMap;

        Set<Id> setIdAcc = new Set<Id>();
        Set<Opportunity> setOppIC = new Set<Opportunity>();

        for (Opportunity opp : lstOpp) {
            if (!'Implantação Concluída'.equalsIgnoreCase(opp.StageName) &&
                    'Implantação Concluída'.equalsIgnoreCase(mapNewOpp.get(opp.Id).StageName)) {
                setOppIC.add(opp);
            }
        }

        List<Produtos_Alelo__c> lstProd =
        [Select Id,
                Valor_Implantado__c,
                Oportunidade__r.Id,
                Oportunidade__r.Account.Id
                FROM Produtos_Alelo__c
                WHERE Oportunidade__r.Id in :setOppIC];

        Map<Id,List<Produtos_Alelo__c>> mapAccProd = new Map<Id, List<Produtos_Alelo__c>>();
        for (Produtos_Alelo__c prod : lstProd) {
            if(!mapAccProd.containsKey(prod.Oportunidade__r.Account.Id)){
                mapAccProd.put(prod.Oportunidade__r.Account.Id,new List<Produtos_Alelo__c>());
            }
            mapAccProd.get(prod.Oportunidade__r.Account.Id).add(prod);
        }

        List<Account> lstAccToUpdate = new List<Account>();
        for (Id idAcc : mapAccProd.keySet()) {
            Decimal vlTotal = 0;
            for (Produtos_Alelo__c prod : mapAccProd.get(idAcc)) {
                vlTotal += prod.Valor_Implantado__c;
            }
            Account acc = new Account();
            acc.Id = idAcc;
            acc.Total_Negocios__c = vlTotal;
            lstAccToUpdate.add(acc);
        }

        Database.Update(lstAccToUpdate);
    }
}
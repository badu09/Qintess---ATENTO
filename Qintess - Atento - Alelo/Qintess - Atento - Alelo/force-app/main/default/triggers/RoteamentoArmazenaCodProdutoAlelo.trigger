trigger RoteamentoArmazenaCodProdutoAlelo on Opportunity (before insert, before update) {

//  List<Opportunity> listOportunidade = Trigger.;
    List<Order> listProcessosRoteamento = new List<Order>();
    List<Opportunity> listOportunidadesAtualizar = new List<Opportunity>();

    Set<Id> setIdOpp = new Set<Id>();
    for (Opportunity opp : Trigger.new) {
        setIdOpp.add(opp.Id);
    }

    Map<Id,List<Produtos_Alelo__c>> mapProdutosOpp = new Map<Id, List<Produtos_Alelo__c>>();
    List<Produtos_Alelo__c> lstProdutosAlelo = [SELECT Codigo_de_Produtos__c,
                                                Oportunidade__c
                                                FROM Produtos_Alelo__c
                                                WHERE Oportunidade__r.Id IN :setIdOpp];
    for (Produtos_Alelo__c prodOpp : lstProdutosAlelo) {
        if(!mapProdutosOpp.containsKey(prodOpp.Oportunidade__c)){
            mapProdutosOpp.put(prodOpp.Oportunidade__c, new List<Produtos_Alelo__c>());
        }
        mapProdutosOpp.get(prodOpp.Oportunidade__c).add(prodOpp);
    }

    Map<Id,List<Order>> mapOrderOpp = new Map<Id, List<Order>>();
    List<Order> lstOrder = [SELECT Id,
                            Codigo_do_Produto_1__c,
                            Codigo_do_Produto_2__c,
                            OpportunityId
                            FROM Order
                            WHERE OpportunityId IN :setIdOpp];

    for (Order ord : lstOrder) {
        if(!mapOrderOpp.containsKey(ord.OpportunityId)){
            mapOrderOpp.put(ord.OpportunityId, new List<Order>());
        }
        mapOrderOpp.get(ord.OpportunityId).add(ord);
    }

    for (Opportunity oportunidade : Trigger.new) {
        Opportunity oppAtualizar = oportunidade;
        List<Produtos_Alelo__c> selectProdutosAlelo = mapProdutosOpp.get(oportunidade.Id);

        if (selectProdutosAlelo != null && selectProdutosAlelo.size() > 0){
            for (Produtos_Alelo__c produtoAlelo : selectProdutosAlelo) {

                if (produtoAlelo.Codigo_de_Produtos__c.equals('301') || produtoAlelo.Codigo_de_Produtos__c.equals('302')){

                    List<Order> selectProcessoRoteamento = mapOrderOpp.get(oportunidade.Id);

                    for (Order processoRoteamento : selectProcessoRoteamento) {
                        if ('301'.equals(produtoAlelo.Codigo_de_Produtos__c)){
                            processoRoteamento.Codigo_do_Produto_1__c = Decimal.valueOf(produtoAlelo.Codigo_de_Produtos__c);
                        } else if ('302'.equals(produtoAlelo.Codigo_de_Produtos__c)) {
                            processoRoteamento.Codigo_do_Produto_2__c = Decimal.valueOf(produtoAlelo.Codigo_de_Produtos__c);
                        }
                        listProcessosRoteamento.add(processoRoteamento);

                    }

                    if ('301'.equals(produtoAlelo.Codigo_de_Produtos__c)){
                        oportunidade.Codigo_Alelo_Auto__c = Decimal.valueOf(produtoAlelo.Codigo_de_Produtos__c);
                    } else if('302'.equals(produtoAlelo.Codigo_de_Produtos__c)){
                        oportunidade.Codigo_Alelo_Mobilidade__c = Decimal.valueOf(produtoAlelo.Codigo_de_Produtos__c);
                    }

                    listOportunidadesAtualizar.add(oportunidade);

                }
            }
        }
    }
    Database.update(listProcessosRoteamento);

}
public class BOMetaRealizada {
    public static void verificaRealizadaImplantacao() {
        //VANER
        //Integer mes = Date.today().month() + 1;
        Integer mes = Date.today().month();
        //VANER
        Integer ano = Date.today().year();
        List<MetaRealizada__c> metasRealizada = new List<MetaRealizada__c>();
        List<Meta__c> metas = DAOMeta.getMetasImplantacao(mes, ano);
        Set<Id> operadores = new Set<Id>();
        Set<Id> supervisores = new Set<Id>();
        Map<Id, Meta__c> operadorMetaImplantacao = new Map<Id, Meta__c>();
        for(Meta__c meta : metas) {
            if(meta.Operador__c != null)
                operadores.add(meta.Operador__c);

            if(meta.Supervisor__c != null)
                supervisores.add(meta.Supervisor__c);

            if(meta.ParametroMeta__r.RecordType.DeveloperName.containsIgnoreCase('Implanta')) {
                operadorMetaImplantacao.put(meta.Operador__c, meta);
            }
        }

        List<Produtos_Alelo__c> produtos = DAOProdutosAlelo.getProductMetasImplantado(mes, ano);
        for(Produtos_Alelo__c prod : produtos) {
            if(operadores.contains(prod.Oportunidade__r.Implantador_Atribuido__c)) {
                MetaRealizada__c metaRealizada = new MetaRealizada__c();
                metaRealizada.Meta__c = operadorMetaImplantacao.get(prod.Oportunidade__r.Implantador_Atribuido__c).Id;
                metaRealizada.Valor_Implantado__c = prod.Oportunidade__r.Valor_Total_Implantado__c;
                metaRealizada.Oportunidade__c = prod.Oportunidade__c;
                metaRealizada.Produto_Alelo__c = prod.Id;
                metasRealizada.add(metaRealizada);
            }
        }
		DAOMetaRealizada.limpaMesMetaRealizada(mes, ano);
		insert metasRealizada;
    }

    public static void verificaRealizadaVendas() {
        //VANER
        //Integer mes = Date.today().month() + 1;
        Integer mes = Date.today().month();
        //VANER
        Integer ano = Date.today().year();
        List<MetaRealizada__c> metasRealizada = new List<MetaRealizada__c>();
        List<Meta__c> metas = DAOMeta.getMetasVendas(mes, ano);
        Set<Id> operadores = new Set<Id>();
        Set<Id> supervisores = new Set<Id>();
        Map<Id, Meta__c> operadorMetaVendas = new Map<Id, Meta__c>();
        for(Meta__c meta : metas) {
            if(meta.Operador__c != null)
                operadores.add(meta.Operador__c);

            if(meta.Supervisor__c != null)
                supervisores.add(meta.Supervisor__c);

            if(meta.ParametroMeta__r.RecordType.DeveloperName.containsIgnoreCase('Vend')) {
                operadorMetaVendas.put(meta.Operador__c, meta);
            }
        }

        List<Produtos_Alelo__c> produtos = DAOProdutosAlelo.getProductMetasVendas(mes, ano);
        System.debug('produtos: ' + JSON.serialize(produtos));
        System.debug('operadores: ' + JSON.serialize(operadores));
        for(Produtos_Alelo__c prod : produtos) {
            if(operadores.contains(prod.Oportunidade__r.Vendedor_Atribuido__c)) {
                MetaRealizada__c metaRealizada = new MetaRealizada__c();
                metaRealizada.Meta__c = operadorMetaVendas.get(prod.Oportunidade__r.Vendedor_Atribuido__c).Id;
                metaRealizada.ValorVendido__c = prod.Valor_Total__c;
                metaRealizada.Oportunidade__c = prod.Oportunidade__c;
                metaRealizada.Produto_Alelo__c = prod.Id;
                metasRealizada.add(metaRealizada);
            }
        }
		DAOMetaRealizada.limpaMesMetaRealizada(mes, ano);
		insert metasRealizada;
    }
}
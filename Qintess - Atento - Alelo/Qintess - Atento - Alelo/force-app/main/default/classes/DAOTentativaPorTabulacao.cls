public with sharing class DAOTentativaPorTabulacao 
{
    
    //Retorna Map, sendo a chave = Tabulação Pai + Tabulação Filha
    public static Map<String, TentativaPorTabulacao__mdt> getMapTentativaPorTabulacao (String celula)
    {
        Map<String, TentativaPorTabulacao__mdt> mapTentativas = new Map<String, TentativaPorTabulacao__mdt>();
        
        List<TentativaPorTabulacao__mdt> lstParam = [SELECT Id,
                                                     Quantidade_Tentativas__c,
                                                     Tabulacao_Pai_Implantacao__c,
                                                     Tabulacao_Filho_Implantacao__c,
                                                     DeveloperName 
                                                     FROM TentativaPorTabulacao__mdt
                                                     WHERE Celula__c = :celula];
        
        if (!lstParam.isEmpty() && lstParam.size() > 0)
        {
            for (TentativaPorTabulacao__mdt param : lstParam)
            {
                String tabPaiFilho = param.Tabulacao_Pai_Implantacao__c + param.Tabulacao_Filho_Implantacao__c;
                System.debug('tabPaiFilho: '+tabPaiFilho);
                mapTentativas.put(tabPaiFilho, param);
            }
        }
        
        System.debug('mapTentativas: '+mapTentativas);
        return mapTentativas;
    }

}
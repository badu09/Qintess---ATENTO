/**
* Created by FTI on 15/02/2018.
*/
@isTest(SeeAllData=True)
public class CobrancaAfter_BeforeTest {
    
    
    public static List<TentativaPorTabulacao__mdt> retornaTentativaPorTabulacao(){
        
        List<TentativaPorTabulacao__mdt> lstParam = [SELECT Id,
                                                     Quantidade_Tentativas__c,
                                                     Tabulacao_Pai_Implantacao__c,
                                                     Tabulacao_Filho_Implantacao__c,
                                                     DeveloperName
                                                     FROM TentativaPorTabulacao__mdt
                                                     WHERE Celula__c = 'Cobrança'];
        
        return lstParam;
    }
    
    public static Group retornaGroup(){
        Group grupo = new Group();
        grupo.DoesIncludeBosses = true;
        grupo.DoesSendEmailToMembers = true;
        grupo.Type = 'Queue';
        grupo.Name = 'Cobranca_Descartados_Cobranca';
        insert grupo;
        
        return grupo;
    }
    
    public static Opportunity retornaOpp(){
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName ='Teste';
        opp.CloseDate = date.valueOf(system.now());
        insert opp;
        
        return opp;
    }
    
    public static Produtos_Alelo__c retornaProdutosAlelo(String idOpp){
        Produtos_Alelo__c produto = new Produtos_Alelo__c();
        produto.Oportunidade__c = idOpp;
        insert produto;
        
        return produto;
    }
    
    public static Cobranca__c retornaProducao(String idProduto,String dOpp){
        Cobranca__c cobranca = new Cobranca__c();
        cobranca.Produtos_Alelo__c = idProduto;
        cobranca.Oportunidade__c = dOpp;
        cobranca.Status__c = 'Cobranca';
        cobranca.Data_Hora_Tabulacao__c = date.valueOf(system.now());
        
        return cobranca;
    }
    
    
    
    @isTest
    static void Test_Method_one(){
        
        List<TentativaPorTabulacao__mdt> lstParam = retornaTentativaPorTabulacao();
        Group grupo = retornaGroup();
        Opportunity opp = retornaOpp();
        Produtos_Alelo__c produto = retornaProdutosAlelo(opp.id);
        
        Cobranca__c cobranca  = retornaProducao(produto.id,opp.id);
        cobranca.Tabulacao_Cobranca_Pai__c = 'DESEJA CANCELAR CONTRATO';
        cobranca.Tabulacao_Cobranca_Filho__c = 'ENCERROU AS ATIVIDADES';
        insert cobranca;
        
        Cobranca__c cobrancaAtingiu = retornaProducao(produto.id,opp.id);
        cobrancaAtingiu.Tabulacao_Cobranca_Pai__c = 'NÃO ATINGIU FATURAMENTO';
        cobrancaAtingiu.Tabulacao_Cobranca_Filho__c = 'REALIZADO NOVO PEDIDO - AGUARDANDO FATURAMENTO';
        insert cobrancaAtingiu;
        
        Cobranca__c cobrancaTabPaiVazio = retornaProducao(produto.id,opp.id);
        insert cobrancaTabPaiVazio;
        
        Cobranca__c cobrancaTabPaiNaoAtende = retornaProducao(produto.id,opp.id);
        cobrancaTabPaiNaoAtende.Tabulacao_Cobranca_Pai__c =  'TELEFONE OCUPADO OU NÃO ATENDE';
        insert cobrancaTabPaiNaoAtende;
        
        Cobranca__c cobrancaTabPaiNaoPertEmpresa = retornaProducao(produto.id,opp.id);
        cobrancaTabPaiNaoPertEmpresa.Tabulacao_Cobranca_Pai__c =  'TELEFONE NÃO PERTENCE A EMPRESA';
        cobrancaTabPaiNaoPertEmpresa.Data_Disponibilizacao_Faturamento__c = System.today();
        insert cobrancaTabPaiNaoPertEmpresa;
        
    }
    
}
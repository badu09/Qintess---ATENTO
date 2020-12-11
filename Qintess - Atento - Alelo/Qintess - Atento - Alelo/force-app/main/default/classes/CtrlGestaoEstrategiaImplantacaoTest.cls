@isTest
public class CtrlGestaoEstrategiaImplantacaoTest {
    
    public static Estrategia_implantacao__c getEstrategiaTest(){
          String reportId = DadosEstrategiaTest.getReportId();
        //Estrategia_implantacao__c estrategia = DadosEstrategiaTest.criaEstrategiaAtiva();
        
        Estrategia_implantacao__c estrategia = new Estrategia_implantacao__c();
        estrategia.Ativado__c = true;
        estrategia.Data_Inicio_Vigencia__c = System.today().addDays(+1);
        estrategia.Data_Fim_Vigencia__c = System.today().addDays(+2);
        estrategia.Quantidade_Maxima_Tentativas__c = 10;
        estrategia.Implantacao_Fidelizada__c = 'Vigente Com Fidelização';
        estrategia.Id_Relatorio_Estrategia__c = reportId;
        
        return estrategia;
        
    }
   
    
    @isTest
    public static void test_method_1(){
        
        CtrlGestaoEstrategiaImplantacao ctrlGestao = new CtrlGestaoEstrategiaImplantacao();
        ctrlGestao.getListaUsuarios();
        
    }
    
    @isTest(SeeAllData=true)
    public static void test_method_2(){
        
       List<Report> listaRelatorio = DAOReport.getReportByFolder('Implantação - Gestão de Estratégia');
        
       test.startTest();
       CtrlGestaoEstrategiaImplantacao ctrlGestao = new CtrlGestaoEstrategiaImplantacao();
       ctrlGestao.getListaRelatorios();
       test.stopTest(); 
           
    }
    @isTest(SeeAllData=true)
    public static void test_method_3(){
        
        
        Estrategia_implantacao__c estrategia = getEstrategiaTest();
        
        List<Estrategia_implantacao__c> listEstrategia = new List<Estrategia_implantacao__c>();
        listEstrategia.add(estrategia);
        
        insert listEstrategia;
        estrategia.Data_Inicio_Vigencia__c = System.today().addDays(-1);
        update estrategia;
        
        Test.startTest();
        Test.setCurrentPage(Page.GestaoEstrategiaImplantacao);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listEstrategia);
        stdSetController.setSelected(listEstrategia);
        CtrlGestaoEstrategiaImplantacao ext = new CtrlGestaoEstrategiaImplantacao(stdSetController);
        
        Estrategia_implantacao__c est = ext.estrategia;
        for(Estrategia_implantacao__c estrategi : listEstrategia){
            est.id = estrategi.id;
            est.Data_Fim_Vigencia__c = estrategi.Data_Fim_Vigencia__c;
            est.Data_Inicio_Vigencia__c = estrategi.Data_Inicio_Vigencia__c;
            est.Implantacao_Fidelizada__c = estrategi.Implantacao_Fidelizada__c;
            est.Id_Relatorio_Estrategia__c = estrategi.Id_Relatorio_Estrategia__c;
            est.Quantidade_Maxima_Tentativas__c = estrategi.Quantidade_Maxima_Tentativas__c; 
            ext.relSelecionado = estrategi.Id_Relatorio_Estrategia__c;
            ext.fieldsRequired = estrategi.id;
            
        }
        upsert est;

        ext.save();
        ext.auxiliarModal();
        ext.showModalNova();
        ext.Ativar();
        ext.closeModalNova();
        Test.stopTest();
        
    }
     @isTest(SeeAllData=true)
    public static void test_method_4(){
        
        Estrategia_implantacao__c estrategia = getEstrategiaTest();
        
        List<Estrategia_implantacao__c> listEstrategia = new List<Estrategia_implantacao__c>();
        listEstrategia.add(estrategia);
        
        insert listEstrategia;
        
        
        Test.startTest();
        Test.setCurrentPage(Page.GestaoEstrategiaImplantacao);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listEstrategia);
        stdSetController.setSelected(listEstrategia);
        CtrlGestaoEstrategiaImplantacao ext = new CtrlGestaoEstrategiaImplantacao(stdSetController);
        ext.validacaoCamposVazios();
        Test.stopTest();
        
            
       
    }
    @isTest(SeeAllData=true)
    public static void test_method_5(){
        Estrategia_implantacao__c estrategia = getEstrategiaTest();
        
        List<Estrategia_implantacao__c> listEstrategia = new List<Estrategia_implantacao__c>();
        listEstrategia.add(estrategia);
        
        insert listEstrategia;
        
        Test.startTest();
        Test.setCurrentPage(Page.GestaoEstrategiaImplantacao);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listEstrategia);
        stdSetController.setSelected(listEstrategia);
        CtrlGestaoEstrategiaImplantacao ext = new CtrlGestaoEstrategiaImplantacao(stdSetController);
        
        Estrategia_implantacao__c est = ext.estrategia;
        for(Estrategia_implantacao__c estrategi : listEstrategia){
            ext.idDesativado = estrategi.id;
            est.id = ext.idDesativado;   
            est.Ativado__c = estrategi.Ativado__c;           
        }
        upsert est;
        est.Ativado__c = false;
        update est;
        
        System.debug(est.id);

        ext.Desativar();

        Test.stopTest();
        

    } 

    @isTest(SeeAllData=true)
    public static void test_Resubmeter(){
        Estrategia_implantacao__c estrategia = getEstrategiaTest();
        
        List<Estrategia_implantacao__c> listEstrategia = new List<Estrategia_implantacao__c>();
        listEstrategia.add(estrategia);
        
        insert listEstrategia;
        
        Test.startTest();
        Test.setCurrentPage(Page.GestaoEstrategiaImplantacao);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(listEstrategia);
        stdSetController.setSelected(listEstrategia);
        CtrlGestaoEstrategiaImplantacao ext = new CtrlGestaoEstrategiaImplantacao(stdSetController);
        
        Estrategia_implantacao__c est = ext.estrategia;
        for(Estrategia_implantacao__c estrategi : listEstrategia){
            ext.idDesativado = estrategi.id;
            est.id = ext.idDesativado;   
            est.Ativado__c = estrategi.Ativado__c;           
        }
        upsert est;
        est.Ativado__c = false;
        update est;
        
        ext.Resubmeter();
        
        Test.stopTest();
        
        
    } 

}
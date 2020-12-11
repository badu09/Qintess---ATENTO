@isTest
public class CtrlEstrategiaImplantacaoUsuariosTest {
    
    @isTest(SeeAllData=true)
    public static void test_method_1(){

    	Estrategia_Implantacao__c estrategia = DadosEstrategiaTest.criaEstrategiaAtiva();
    
        String estratJson = JSON.serialize(estrategia);
        AuxiliarUpdateEstrategiaImplantacao.updateEstrategiaImplant(estratJson);

        Test.startTest();
        CtrlEstrategiaImplantacaoUsuarios ctrlEstrategia = new CtrlEstrategiaImplantacaoUsuarios();
        ctrlEstrategia.getNomesSoma();
        Test.stopTest();

    }

    @isTest(SeeAllData=true)
    public static void test_method_2(){

    	CtrlEstrategiaImplantacaoUsuarios ctrlEstrategia = new CtrlEstrategiaImplantacaoUsuarios();
  
        List<Profile> listaPerfis = DAOProfile.getProfileByContainsName('Implantação');
        List<User> userLista = DAOUser.getUserIsActiveByProfile(listaPerfis);

        List<SelectOption> listOptions = new List<SelectOption>();


    	for(User userObj : userLista){
           
    		ctrlEstrategia.selectedUserIds.add(string.ValueOf(userObj.id));
            ctrlEstrategia.removedUserIds.add(string.ValueOf(userObj.id));
            
    	}
           
        Test.startTest();
        
    	ctrlEstrategia.add();
        ctrlEstrategia.getAvailableUsers();
        ctrlEstrategia.getSelectedUsers();
        ctrlEstrategia.filterAvailableOptions();
        ctrlEstrategia.closeModalUser();
        ctrlEstrategia.remove();
        
        Test.stopTest();

    }
    
    @isTest (SeeAllData=true)
    public static void test_method_3(){
        
        String reportId = DadosEstrategiaTest.getReportId();
        
        Estrategia_implantacao__c estrategia = new Estrategia_implantacao__c();
        estrategia.Ativado__c = true;
        estrategia.Data_Inicio_Vigencia__c = System.today().addDays(-1);
        estrategia.Data_Fim_Vigencia__c = System.today().addDays(1);
        estrategia.Quantidade_Maxima_Tentativas__c = 10;
        estrategia.Implantacao_Fidelizada__c = 'Vigente Com Fidelização';
        estrategia.Id_Relatorio_Estrategia__c = reportId;
        
        insert estrategia;
        
        CtrlEstrategiaImplantacaoUsuarios ctrlEstrategia = new CtrlEstrategiaImplantacaoUsuarios();
        
        ctrlEstrategia.idEstrategia = estrategia.id;

        List<Profile> listaPerfis = DAOProfile.getProfileByContainsName('Implantação');
        List<User> userLista = DAOUser.getUserIsActiveByProfile(listaPerfis);

    	for(User userObj : userLista){
            ctrlEstrategia.selectedUsersMap.put(userObj.id,userObj.Name);
    	}
    
        test.startTest();
        ctrlEstrategia.atualizaEstrategiaImplantacao();
        ctrlEstrategia.updateEstrategia();
        test.stopTest();
    }
}
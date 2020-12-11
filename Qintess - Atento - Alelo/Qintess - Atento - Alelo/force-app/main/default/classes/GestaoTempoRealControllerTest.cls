@isTest
public class GestaoTempoRealControllerTest {
	@isTest
    static void testaGestaoTempo(){
        
        User user = [SELECT ID FROM USER LIMIT 1];
        
        List<Tempo_Operador__c> tempoOperador = new List<Tempo_Operador__c>();
        Tempo_Operador__c t1 = new Tempo_Operador__c();
        t1.Operador__c = user.id;
        t1.Tipo_da_Acao__c = 'Atendimento';
        t1.Data_Hora_Inicio__c = Datetime.Now();
        t1.Data_Hora_Fim__c = Datetime.Now() + 1; 
		tempoOperador.add(t1);
        Tempo_Operador__c t2 = new Tempo_Operador__c();
        t2.Operador__c = user.id;
        t2.Tipo_da_Acao__c = 'Pausa';
        t2.Data_Hora_Inicio__c = Datetime.Now();
        t2.Data_Hora_Fim__c = Datetime.Now() + 1;
        t2.Data_Hora_Fim__c = Datetime.Now() + 1;
        t2.Motivo_Pausa__c = 'Teste';
        tempoOperador.add(t2);
        
        insert tempoOperador;
        
        Test.startTest();
        GestaoTempoRealController controller = new GestaoTempoRealController();
        controller.filaSelecionada = 'Todos';
        controller.usuarioSelecionado = 'Todos';
        controller.refreshOperadores();
        controller.filtrarOperadores();
        controller.usuarioSelecionado = user.Id;
        controller.filtrarOperadores();
        Test.stopTest();
        
    }
    
    @testSetup
    static void setupTestData(){
        
        User user = new User();
        user.ProfileID = [SELECT Id, Name FROM Profile WHERE Name = 'Supervisor'].id;
        user.EmailEncodingKey = 'ISO-8859-1';
        user.LanguageLocaleKey = 'en_US';
        user.TimeZoneSidKey = 'America/New_York';
        user.LocaleSidKey = 'en_US';
        user.FirstName = 'first';
        user.LastName = 'last';
        user.Username = 'teste@teste.com.br.atento';
        user.CommunityNickname = 'testUser123';
        user.Alias = 't1';
        user.Email = 'teste@teste.com.br';
        user.IsActive = true;
        user.Equipe__c = 'PORTAL BRADESCO';
        insert user;
        
        Group grupo1 = new Group();
        grupo1.Name = 'Teste';
        grupo1.DeveloperName = 'Teste_1';
        grupo1.Type = 'Regular';
        insert grupo1;
        
        Group grupo2 = new Group();
        grupo2.Name = 'Teste 2';
        grupo2.DeveloperName = 'Teste_2';
        grupo2.Type = 'Regular';
        insert grupo2;
        
        GroupMember membroGrupo1 = new GroupMember();
        membroGrupo1.GroupId = grupo1.Id;
        membroGrupo1.UserOrGroupId = user.Id;
        insert membroGrupo1;
        
        GroupMember membroGrupo2 = new GroupMember();
        membroGrupo2.GroupId = grupo2.Id;
        membroGrupo2.UserOrGroupId = user.Id;
        insert membroGrupo2;
    }
}
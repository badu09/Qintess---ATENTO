public class DAOGrupoDeRelacionamento {
	public static Grupo_de_Relacionamento__c getGrupoDeRelacionamentoById(string grupoRelId){
        return [SELECT Id, ID__c, Data_do_ltimo_Contato__c, Data_Agendamento_prox_Contato__c,
                Status_do_Grupo__c FROM Grupo_de_Relacionamento__c WHERE Id = :grupoRelId LIMIT 1];
    }
}
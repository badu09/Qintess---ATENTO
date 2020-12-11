public class GestaoTempoRealController {
    public List<GestaoTempoTO> listHistorico { get; set; }
	public List<GestaoTempoTO> listHistoricoExibicao { get; set; }
	public List<SelectOption> listFilasFiltro { get; set; }
	public List<SelectOption> listUsersFiltro { get; set; }
	public String filaSelecionada { get; set; }
	public String usuarioSelecionado { get; set; }
    
    public GestaoTempoRealController(){
		listFilasFiltro = new List<SelectOption>();
		listUsersFiltro = new List<SelectOption>();
		carregarFiltros();
		carregaTempoOperador();

	}

	public void carregarFiltros(){

		listFilasFiltro.add(new SelectOption('Todos','Todos'));

		for(Group g : getFilas()){
			if(!String.isEmpty(g.Name))
				listFilasFiltro.add(new SelectOption(g.Name,g.Name));
		}

		listUsersFiltro.add(new SelectOption('Todos','Todos'));
		for(User u : getUsers()){
			listUsersFiltro.add(new SelectOption(u.Id,u.Name));
		}
	}
    
    public void carregaTempoOperador(){
		listHistorico = new List<GestaoTempoTO>();
		listHistoricoExibicao = new List<GestaoTempoTO>();
		Set<Id> idsOperador = new Set<Id>();
		List<Tempo_Operador__c> listHist = getTempoOperador();

		for(Tempo_Operador__c item : listHist){
			idsOperador.add(item.Operador__c);
		}

		List<GroupMember> listFila = getFila(idsOperador);
        System.debug(listFila);

		for(Tempo_Operador__c t : getTempoOperador()){
			GestaoTempoTO to = new GestaoTempoTO();
			to.operadorId = t.Operador__c;
			to.operador = t.Operador__r.Name;
			to.supervisor = t.Operador__r.Supervisor__r.Name;
			to.tempoHoras = String.valueOf(t.Tempo_em_Horas__c);
			to.tempoMinutos = String.valueOf(t.Tempo_em_minutos__c);
			to.tipoAcao = t.Tipo_da_Acao__c;
			to.motivoPausa = t.Motivo_Pausa__c;
			to.filas = new List<String>();
			for(GroupMember f : listFila){
				if(f.UserOrGroupId.equals(t.Operador__c)){
					to.filas.add(f.Group.Name);
				}
			}

			listHistorico.add(to);
		}

		listHistoricoExibicao = listHistorico;
	}

	public void refreshOperadores(){

		Set<Id> operadoresId = new Set<Id>();
		for (GestaoTempoTO to : listHistoricoExibicao) {
			operadoresId.add(to.operadorId);
		}

		listHistorico = new List<GestaoTempoTO>();
		listHistoricoExibicao = new List<GestaoTempoTO>();
		Set<Id> idsOperador = new Set<Id>();
		List<Tempo_Operador__c> listHist = getTempoOperador();

		for(Tempo_Operador__c item : listHist){
			idsOperador.add(item.Operador__c);
		}

		List<GroupMember> listFila = getFila(idsOperador);

		for(Tempo_Operador__c t : getTempoOperador()){
			GestaoTempoTO to = new GestaoTempoTO();
			to.operadorId = t.Operador__c;
			to.operador = t.Operador__r.Name;
			to.supervisor = t.Operador__r.Supervisor__r.Name;
			to.tempoHoras = String.valueOf(t.Tempo_em_Horas__c);
			to.tempoMinutos = String.valueOf(t.Tempo_em_minutos__c);
			to.tipoAcao = t.Tipo_da_Acao__c;
			to.motivoPausa = t.Motivo_Pausa__c;
			to.filas = new List<String>();
			for(GroupMember f : listFila){
				if(f.UserOrGroupId.equals(t.Operador__c)){
					to.filas.add(f.Group.Name);
				}
			}

			listHistorico.add(to);
		}

		if(filaSelecionada.contains('Todos') && usuarioSelecionado.contains('Todos')){
			listHistoricoExibicao = listHistorico;
		} else{
			for(GestaoTempoTO exib : listHistorico){
				for(Id idVerificao : operadoresId){
					if(exib.operadorId.equals(idVerificao)){
						listHistoricoExibicao.add(exib);
					}
				}
			}
		}
	}

	public void filtrarOperadores(){

		List<GestaoTempoTO> listHistoricoAux = listHistorico;
		listHistoricoExibicao = new List<GestaoTempoTO>();

		if(filaSelecionada.contains('Todos') && usuarioSelecionado.contains('Todos')){
			listHistoricoExibicao = listHistorico;
		}
		else if(!filaSelecionada.contains('Todos') && !usuarioSelecionado.contains('Todos')){
			for(GestaoTempoTO to : listHistoricoAux){
				for(String f : to.filas){
					if(filaSelecionada.equals(f) && usuarioSelecionado.equals(to.operadorId)){
						listHistoricoExibicao.add(to);
					}
				}
			}
		}
		else if(!filaSelecionada.contains('Todos')){
			for(GestaoTempoTO to : listHistoricoAux){
				for(String f : to.filas){
					if(filaSelecionada.equals(f)){
						listHistoricoExibicao.add(to);
					}
				}
			}
		}else if(!usuarioSelecionado.contains('Todos')){
			for(GestaoTempoTO to : listHistoricoAux){
				if(usuarioSelecionado.equals(to.operadorId)){
					listHistoricoExibicao.add(to);
				}
			}
		}
	}

	public List<Tempo_Operador__c> getTempoOperador(){
        return [SELECT Operador__c,
        		Operador__r.Name,
                Operador__r.Supervisor__r.Name,  
                Tipo_da_Acao__c, 
                Tempo_em_Horas__c, 
                Tempo_em_minutos__c,
				Motivo_Pausa__c
                FROM Tempo_Operador__c
                WHERE CreatedDate = TODAY];
	}
    
    public List<GroupMember> getFila(Set<Id> ids){
        return [SELECT Group.Name,
					   UserOrGroupId
                    FROM GroupMember
               WHERE UserOrGroupId =: ids
			   AND (NOT Group.Name like 'Fidelizado%')];
    }

	public List<Group> getFilas(){
		return [SELECT Name,
					   DeveloperName
					   FROM Group
					   WHERE (NOT Name like 'Fidelizado%') ORDER BY Name];
	}

	public List<User> getUsers(){
		return [SELECT Id, Name FROM User WHERE IsActive = true ORDER BY Name];
	}

	public class GestaoTempoTO{

		public String operador { get; set; }
		public String operadorId;
		public String supervisor { get; set; }
		public String tipoAcao { get; set; }
		public String tempoHoras { get; set; }
		public String tempoMinutos { get; set; }
		public String motivoPausa { get; set; }
		public List<String> filas { get; set; }

	}
}
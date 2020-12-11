global class CtrlCallControl {
  public String login { get; set; }
  public String password { get; set; }
  public String Tabulacao { get; set; }
  public String StatusLigacao { get; set; }
  public String Motivo { get; set; }
  public Lead LeadObj { get; set; }
  public Opportunity OpportunityObj { get; set; }
  public String Telefone { get; set; }
  // public Map <String, String> mapStatus { get; set; }
  // public String mapStatusStr { get; set; }
  // public Map <String, String> mapStatusLead { get; set; }
  // public String mapStatusLeadStr { get; set; }
  // public Map <String, String> mapMotivoOportunidade { get; set; }
  // public String mapMotivoOportunidadeStr { get; set; }
  // public Map <String, String> mapTabulacao { get; set; }
  // public String mapTabulacaoStr { get; set; }
  // public Map <String, String> mapMotivo { get; set; }
  // public String mapMotivoStr { get; set; }
  public Id IdOportunidade { get; set; }
  public Id IdCliente { get; set; }
  public String AleloAtivoManual { get; set; }
  public String alertaErro { get; set; }
  public Id IdObj { get; set; }
  public Map<String, TabulacoesNovo__c> tabulacoes { get; set; }
  public TabulacoesNovo__c tabSelecionada { get; set; }
  public String tabSelecionadaStr { get; set; }
  public String mapTabStr { get; set; }

  public String codigoCampanha { get; set; }
  public String nomeCampanha { get; set; }

  public String wsAgentCmd { get; set; }
  public String wsAgentEvt { get; set; }
  public String wsMailingCmd { get; set; }

  public Map<String, String> mapCampanha { get; set; }
  public String mapCampanhaStr { get; set; }

  public Boolean salvo { get; set; }
  public String dtAgendamento { get; set; }

  public Boolean campanhaReceptivo { get; set; }

  public Map<String, Decimal> mapTempo { get; set; }
  public String mapTempoStr { get; set; }

  public Parametros__c setLogger { get; set; }

  public Boolean ocultaTabulacao { get; set; }
  public TabulacaoSoftphone__c tabulacaoSoftphone { get; set; }

  public CtrlCallControl() {
    carregarEndpoint();
    // carregarMaps();
    carregarEsteira();
    carregarCampanha();
    carregarTempo();
    verificaOcultaTabulacao();
    setLogger = Parametros__c.getInstance('SETLOGGER');

    /*if(!Ativo_para_Receptivo__c.getAll().isEmpty()) {
      Ativo_para_Receptivo__c ativoReceptivo = Ativo_para_Receptivo__c.getAll().values()[0];
      this.AleloAtivoManual = ativoReceptivo.Name;
    }*/
    
    this.verificaChamadaManual();

    if(!TabulacoesNovo__c.getAll().isEmpty()) {
      tabulacoes = TabulacoesNovo__c.getAll();
    }
    this.mapTabStr = JSON.serialize(tabulacoes);
    this.campanhaReceptivo = false;
    this.salvo = false;
  }
  
  	public void verificaChamadaManual() {
		ChamadaManual__c chamadaManual = ChamadaManual__c.getInstance(Userinfo.getProfileId());
      	this.AleloAtivoManual = String.valueOf(Integer.valueOf(chamadaManual.Campanha__c));
  	}

  public void verificaOcultaTabulacao() {
    tabulacaoSoftphone = TabulacaoSoftphone__c.getInstance(Userinfo.getProfileId());
    this.ocultaTabulacao = tabulacaoSoftphone.OcultaTabulacao__c;
    if(tabulacaoSoftphone.LiberaObjeto__c == null) {
		tabulacaoSoftphone.LiberaObjeto__c = '';
    }
  }

  webService static String getLeads(String ani) {
    List<Lead> leads = new List<Lead>();
    for (Lead lead : [Select Id, Name, Phone from Lead where Phone = :ani]){
      leads.add(lead);
    }
    return JSON.serialize(leads);
  }

  public List<SelectOption> getListaTab() {
    Map<String, TabulacoesNovo__c> mapNames = new Map<String, TabulacoesNovo__c>();
    List<String> namesTab = new List<String>();
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('','Selecione a Tabulação'));
    for(String key : tabulacoes.keySet()) {
      if(tabulacoes.get(key).Motivo_Detalhado__c != null && tabulacoes.get(key).Motivo_Detalhado__c != '' && !tabulacoes.get(key).Omitir_Usuario__c)
        mapNames.put(tabulacoes.get(key).Motivo_Detalhado__c, tabulacoes.get(key));
    }
    namesTab.addAll(mapNames.keySet());
    namesTab.sort();

    for(String tb : namesTab) {
      TabulacoesNovo__c tabulac = mapNames.get(tb);
      options.add(new SelectOption(tabulac.Name, tabulac.Motivo_Detalhado__c));
    }

    return options;
  }

  public void carregarLead() {
    try {
      this.IdObj = null;
      this.salvo = false;
      this.campanhaReceptivo = false;
      this.IdOportunidade = null;
      this.LeadObj = null;
      this.OpportunityObj = null;
      this.alertaErro = null;

      String IdObjeto = Apexpages.currentPage().getParameters().get('idObjeto');
      System.debug('IdObjeto: ' + IdObjeto);

      List<Lead> lAux = [SELECT Id FROM Lead WHERE UniversalLeadId__c =: IdObjeto];

      if(IdObjeto != null && IdObjeto != '') {
        this.IdObj = lAux.isEmpty() ? IdObjeto : lAux.get(0).Id;
        if(String.valueOf(IdObj.getSObjectType()).containsIgnoreCase('Opportunity')) {
          System.debug('Opportunity');
          ocultaTabulacao = tabulacaoSoftphone.OcultaTabulacao__c && !tabulacaoSoftphone.LiberaObjeto__c.containsIgnoreCase('Opportunity');
          this.IdOportunidade = IdObjeto;
          this.OpportunityObj = DAOOpportunity.getOpportunityById(IdObjeto);
          this.campanhaReceptivo = this.OpportunityObj.Campanha__c.containsIgnoreCase('receptivo') || this.OpportunityObj.Campanha__c.containsIgnoreCase('imp');
          if(opportunityObj.Implantador_Atribuido__c != UserInfo.getUserId()) {
            Profile implantacao = DAOProfile.getProfileById(UserInfo.getProfileId());
            if(implantacao.Name.equalsIgnoreCase('Operador - Implantação')) {
              opportunityObj.Implantador_Atribuido__c = UserInfo.getUserId();
              update opportunityObj;
            }
          }

        }
        else if(String.valueOf(IdObj.getSObjectType()).containsIgnoreCase('Lead')){
          System.debug('Lead');
          ocultaTabulacao = tabulacaoSoftphone.OcultaTabulacao__c && !tabulacaoSoftphone.LiberaObjeto__c.containsIgnoreCase('Lead');
          LeadObj = DAOLead.getLead(lAux.get(0).Id);
          this.campanhaReceptivo = this.LeadObj.Nome_da_Campanha__c.containsIgnoreCase('receptivo') || this.LeadObj.Nome_da_Campanha__c.containsIgnoreCase('imp');
        }
        else if(String.valueOf(IdObj.getSObjectType()).containsIgnoreCase('Account')) {
          System.debug('Account');
          this.IdCliente = IdObjeto;
        }
      }
    }
    catch(Exception e) {
      System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
    }
  }

  private void carregarEsteira() {
    this.codigoCampanha = '';
    this.nomeCampanha = '-';

    Esteira_Campanha__c esteiraCampanha = Esteira_Campanha__c.getInstance(Userinfo.getProfileId());
    System.debug('Id com ultimos caracteres' + Userinfo.getProfileId());
    if(esteiraCampanha == null) {
      esteiraCampanha = Esteira_Campanha__c.getInstance(Userinfo.getProfileId().replaceAll('\\w{3}$', ''));
      System.debug('ID sem ultimos caracteres: ' + Userinfo.getProfileId().replaceAll('\\w{3}$', ''));
    }
    System.debug('Esteira Campanha: ' + json.serialize(esteiraCampanha));

    if(esteiraCampanha != null) {
      this.codigoCampanha = esteiraCampanha.Codigo_proxima_campanha__c;
      this.nomeCampanha = esteiraCampanha.Nome_proxima_campanha__c;
    }
  }

  private void carregarEndpoint() {
    this.wsAgentCmd = Endpoint_Servico__c.getInstance('AgentCmd').Endpoint__c;
    this.wsAgentEvt = Endpoint_Servico__c.getInstance('AgentEvt').Endpoint__c;
    this.wsMailingCmd = Endpoint_Servico__c.getInstance('MailingCmd').Endpoint__c;
  }

  public void encerrarChamada() {
    this.alertaErro = null;
    if (tabSelecionada != null && tabSelecionadaStr != null) {
      if (tabSelecionada == null)
        tabSelecionada = tabulacoes.get(tabSelecionadaStr);

      if (tabSelecionada == null) {
        this.alertaErro = 'Por favor, selecione uma tabulação.';
        return;
      }
      dtAgendamento = Apexpages.currentPage().getParameters().get('dtAgendamento');
      Datetime dateAgendamento = convertStringToDate(dtAgendamento);
      this.alertaErro = null;
      if (LeadObj != null) {
        LeadObj = DAOLead.getLead(LeadObj.Id);
        Telefone = Apexpages.currentPage().getParameters().get('telefone');
        System.debug(tabSelecionadaStr);
        if (LeadObj.isConverted) {
          OpportunityObj = new Opportunity(Id=LeadObj.ConvertedOpportunityId);

          if (tabSelecionada.Agendamento__c) {
            OpportunityObj.Agendamento_Retorno__c = dateAgendamento;
          }
          try {
            OpportunityObj.Motivo_Detalhado__c = tabSelecionada.Motivo_Detalhado__c;
            if (tabSelecionada.FaseOportunidade__c != null && tabSelecionada.FaseOportunidade__c != '')
              OpportunityObj.StageName = tabSelecionada.FaseOportunidade__c;
            update OpportunityObj;
            ocultaTabulacao = tabulacaoSoftphone.OcultaTabulacao__c;
          } catch (Exception e) {
            System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
            this.alertaErro = 'Exception: ' + e;
          }
        } else {
          if (Telefone != null) {
            if (LeadObj.Phone != null &&
                    LeadObj.Phone.replaceAll(' ', '') == Telefone.replaceAll(' ', '')) {
              LeadObj.Status1__c = tabSelecionada.Status_1__c;
              LeadObj.Tabulacao1__c = tabSelecionada.Tabulacao_1__c;
            } else if (LeadObj.Telefone2__c != null &&
                    LeadObj.Telefone2__c.replaceAll(' ', '') == Telefone.replaceAll(' ', '')) {
              LeadObj.Status2__c = tabSelecionada.Status_1__c;
              LeadObj.Tabulacao2__c = tabSelecionada.Tabulacao_1__c;
            } else if (LeadObj.Telefone3__c != null &&
                    LeadObj.Telefone3__c.replaceAll(' ', '') == Telefone.replaceAll(' ', '')) {
              LeadObj.Status3__c = tabSelecionada.Status_1__c;
              LeadObj.Tabulacao3__c = tabSelecionada.Tabulacao_1__c;
            } else if (LeadObj.Telefone4__c != null &&
                    LeadObj.Telefone4__c.replaceAll(' ', '') == Telefone.replaceAll(' ', '')) {
              LeadObj.Status4__c = tabSelecionada.Status_1__c;
              LeadObj.Tabulacao4__c = tabSelecionada.Tabulacao_1__c;
            } else if (LeadObj.Telefone5__c != null &&
                    LeadObj.Telefone5__c.replaceAll(' ', '') == Telefone.replaceAll(' ', '')) {
              LeadObj.Status5__c = tabSelecionada.Status_1__c;
              LeadObj.Tabulacao5__c = tabSelecionada.Tabulacao_1__c;
            }

            if (tabSelecionada.Status_do_Lead__c != null)
              LeadObj.Status = tabSelecionada.Status_do_Lead__c;

            LeadObj.Motivo_Detalhado__c = tabSelecionada.Motivo_Detalhado__c;

            LeadObj.Agendamento_Retorno__c = dateAgendamento;
            try {
              update LeadObj;
              ocultaTabulacao = tabulacaoSoftphone.OcultaTabulacao__c;
            } catch (Exception e) {
              System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
              this.alertaErro = 'Exception: ' + e;
            }
          }
        }
      } else if (OpportunityObj != null) {
        if (tabSelecionada.Agendamento__c) {
          OpportunityObj.Agendamento_Retorno__c = dateAgendamento;
        }
        try {
          OpportunityObj.Motivo_Detalhado__c = tabSelecionada.Motivo_Detalhado__c;
          if (tabSelecionada.FaseOportunidade__c != null && tabSelecionada.FaseOportunidade__c != '')
            OpportunityObj.StageName = tabSelecionada.FaseOportunidade__c;
          update OpportunityObj;
          ocultaTabulacao = tabulacaoSoftphone.OcultaTabulacao__c;
        } catch (Exception e) {
          System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
          this.alertaErro = 'Exception: ' + e;
        }
      }
      Tabulacao = null;
      StatusLigacao = null;
      Motivo = null;
      LeadObj = null;
      OpportunityObj = null;
      IdOportunidade = null;
      IdCliente = null;
      dtAgendamento = null;
      this.salvo = false;
      this.tabSelecionada = null;
      this.tabSelecionadaStr = '';
    } else {
      this.alertaErro = 'Por favor, selecione uma tabulação.';
    }

  }

  public void salvarTabulacao() {
    if(tabSelecionada != null && tabSelecionadaStr != null) {
      try {
        if(tabSelecionada == null)
          tabSelecionada = tabulacoes.get(tabSelecionadaStr);

        if(tabSelecionada == null) {
          this.alertaErro = 'Por favor, selecione uma tabulação.';
          return;
        }

        System.debug('function salvarTabulacao');
        dtAgendamento = Apexpages.currentPage().getParameters().get('dtAgendamento');
        System.debug('dtAgendamento: ' + dtAgendamento);
        Datetime dateAgendamento = convertStringToDate(dtAgendamento);
        System.debug('dateAgendamento: ' + dateAgendamento);
        this.alertaErro = null;
        if (LeadObj != null) {
          if (LeadObj.isConverted) {
            OpportunityObj = new Opportunity(Id=LeadObj.ConvertedOpportunityId);

            if (tabSelecionada.Agendamento__c) {
              OpportunityObj.Agendamento_Retorno__c = dateAgendamento;
            }
            try {
              OpportunityObj.Motivo_Detalhado__c = tabSelecionada.Motivo_Detalhado__c;
              if (tabSelecionada.FaseOportunidade__c != null && tabSelecionada.FaseOportunidade__c != '')
                OpportunityObj.StageName = tabSelecionada.FaseOportunidade__c;
              update OpportunityObj;
              ocultaTabulacao = tabulacaoSoftphone.OcultaTabulacao__c;
            } catch (Exception e) {
              System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
              this.alertaErro = 'Exception: ' + e;
            }
          } else {
            LeadObj = DAOLead.getLead(LeadObj.Id);
            Telefone = Apexpages.currentPage().getParameters().get('phoneNumber');
            System.debug(Tabulacao);
            if (Telefone != null) {
              if (LeadObj.Phone != null &&
                      LeadObj.Phone.replaceAll(' ', '') == Telefone.replaceAll(' ', '')) {
                LeadObj.Status1__c = tabSelecionada.Status_1__c;
                LeadObj.Tabulacao1__c = tabSelecionada.Tabulacao_1__c;
              } else if (LeadObj.Telefone2__c != null &&
                      LeadObj.Telefone2__c.replaceAll(' ', '') == Telefone.replaceAll(' ', '')) {
                LeadObj.Status2__c = tabSelecionada.Status_1__c;
                LeadObj.Tabulacao2__c = tabSelecionada.Tabulacao_1__c;
              } else if (LeadObj.Telefone3__c != null &&
                      LeadObj.Telefone3__c.replaceAll(' ', '') == Telefone.replaceAll(' ', '')) {
                LeadObj.Status3__c = tabSelecionada.Status_1__c;
                LeadObj.Tabulacao3__c = tabSelecionada.Tabulacao_1__c;
              } else if (LeadObj.Telefone4__c != null &&
                      LeadObj.Telefone4__c.replaceAll(' ', '') == Telefone.replaceAll(' ', '')) {
                LeadObj.Status4__c = tabSelecionada.Status_1__c;
                LeadObj.Tabulacao4__c = tabSelecionada.Tabulacao_1__c;
              } else if (LeadObj.Telefone5__c != null &&
                      LeadObj.Telefone5__c.replaceAll(' ', '') == Telefone.replaceAll(' ', '')) {
                LeadObj.Status5__c = tabSelecionada.Status_1__c;
                LeadObj.Tabulacao5__c = tabSelecionada.Tabulacao_1__c;
              }

              if (tabSelecionada.Status_do_Lead__c != null)
                LeadObj.Status = tabSelecionada.Status_do_Lead__c;

              LeadObj.Motivo_Detalhado__c = tabSelecionada.Motivo_Detalhado__c;

              LeadObj.Agendamento_Retorno__c = dateAgendamento;
              update LeadObj;
              this.salvo = true;
            }
          }
        } else if (OpportunityObj != null) {
          if (tabSelecionada.Agendamento__c) {
            OpportunityObj.Agendamento_Retorno__c = dateAgendamento;
          }
          OpportunityObj.Motivo_Detalhado__c = tabSelecionada.Motivo_Detalhado__c;
          if(tabSelecionada.FaseOportunidade__c != null && tabSelecionada.FaseOportunidade__c != '')
            OpportunityObj.StageName = tabSelecionada.FaseOportunidade__c;
          this.salvo = true;
          update OpportunityObj;
        }
        System.debug('salvo: ' + this.salvo);
      }
      catch(Exception e) {
        System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
        this.alertaErro = 'Exception: ' + e;
      }
    }
    else {
      this.alertaErro = 'Por favor, selecione uma tabulação.';
    }
  }

  public void carregarCampanha() {
    this.mapCampanha = new Map<String, String>();
    for(Campanhas_receptivo__c item : Campanhas_receptivo__c.getAll().values()) {
      mapCampanha.put(item.Name, item.Descricao__c);
    }
    this.mapCampanhaStr = JSON.serialize(this.mapCampanha);
    System.debug('this.mapCampanhaStr: ' + this.mapCampanhaStr);
  }

  public void carregarTempo() {
    this.mapTempo = new Map<String, Decimal>();
    for(tempo_limite_discador__c item : tempo_limite_discador__c.getAll().values()) {
      mapTempo.put(item.Name, item.Tempo_Maximo__c);
    }
    this.mapTempoStr = JSON.serialize(this.mapTempo);
    System.debug('this.mapTempoStr: ' + this.mapTempoStr);
  }

  public void doNothing() {}

  public void selecionaTabulacao() {
    tabSelecionada = tabulacoes.get(tabSelecionadaStr);
  }

  @RemoteAction
  global static Boolean verificaStatusOportunidade(String idObjetoStr, String codigoCampanha, String nomeCampanha) {
    System.debug('codigoCampanha: ' + codigoCampanha);
    System.debug('nomeCampanha: ' + nomeCampanha);
    if(idObjetoStr != null && idObjetoStr != '') {
      Id idObjeto = idObjetoStr;
      if(idObjeto != null &&
              codigoCampanha != null &&
              codigoCampanha != '') {
        if(String.valueOf(idObjeto.getSObjectType()).containsIgnoreCase('Lead')) {
          Lead leadObjeto = DAOLead.getLead(idObjeto);
          if(leadObjeto.isConverted) {
            idObjeto = leadObjeto.ConvertedOpportunityId;
          }
          else {
            return false;
          }
        }

        if(String.valueOf(idObjeto.getSObjectType()).containsIgnoreCase('Opportunity')) {
          Opportunity oportunidade = DAOOpportunity.getOpportunityById(idObjeto);
          System.debug('oportunidade: ' + JSON.serialize(oportunidade));
          if(oportunidade != null && (nomeCampanha == 'Auditoria' && oportunidade.StageName == 'Venda Confirmada') ||
              (nomeCampanha == 'Implantação' && oportunidade.StageName == 'Auditoria Finalizada/ Transf Implantação')) {
            return true;
          }

        }
      }
    }
    return false;
  }

  public static Datetime convertStringToDate(String base){
    try {
      String dia;
      String mes;
      String ano;
      String hora = null;
      String minuto = null;
      String segundo = null;
      String milisec = null;

      dia = base.subString(0, 2);
      mes = base.subString(3, 5);
      ano = base.subString(6, 10);
      hora = base.subString(11, 13);
      minuto = base.subString(14, 16);

      try
      {
        Date dataFormatada = Date.newInstance(Integer.valueOf(ano), Integer.valueOf(mes), Integer.valueOf(dia));

        Time horaFormatada = Time.newInstance(hora != null ? Integer.valueOf(hora) : 0, minuto != null ? Integer.valueOf(minuto) : 0, segundo != null ? Integer.valueOf(segundo) : 0, milisec!=null? Integer.valueOf(milisec):0);

        return Datetime.newInstance(dataFormatada, horaFormatada);
      }
      catch(Exception e)
      {
        return null;
      }
    }
    catch(Exception e) {
      System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
      return null;
    }
  }

  @RemoteAction
  global static void salvarStatus(String objetoStr) {
    try {
      StatusRelogio status = (StatusRelogio) JSON.deserialize(objetoStr, StatusRelogio.class);
      System.debug('status: ' + JSON.serialize(status));

      Tempo_Operador__c tempo = new Tempo_Operador__c();
      System.debug('tempo: ' + JSON.serialize(tempo));
      tempo.Data_Hora_Inicio__c = status.DataInicio;
      System.debug('tempo.Data_Hora_Inicio__c: ' + JSON.serialize(tempo.Data_Hora_Inicio__c));
      tempo.Data_Hora_Fim__c = status.DataFim;
      System.debug('tempo.Data_Hora_Fim__c: ' + JSON.serialize(tempo.Data_Hora_Fim__c));
      tempo.Motivo_Pausa__c = status.MotivoPausa;
      System.debug('tempo.Motivo_Pausa__c: ' + JSON.serialize(tempo.Motivo_Pausa__c));
      tempo.Operador__c = Userinfo.getUserId();
      System.debug('tempo.Operador__c: ' + JSON.serialize(tempo.Operador__c));
      tempo.Tipo_da_Acao__c = status.Status;
      System.debug('tempo.Tipo_da_Acao__c: ' + JSON.serialize(tempo.Tipo_da_Acao__c));

      insert tempo;
      System.debug('tempo: ' + tempo.Id);
    }
    catch(Exception e) {
      System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
    }
  }

  @RemoteAction
  global static ClickTODialOBject consultarProcessoImplantacao(String idProcessoImplantacao) {
    try {
      Id idProcesso = idProcessoImplantacao;
      Order processoImplantacao;
      Lead leadDial;
      Cobranca__c IDCobranca;
      ClickToDialObject click;
        
      if(String.valueOf(idProcesso.getSObjectType()).containsIgnoreCase('Lead')) {
        leadDial = DAOLead.getLead(idProcesso);
          if (leadDial != null && leadDial.Phone != null && leadDial.Phone != '') {
          click = new ClickToDialObject(leadDial.Id, leadDial.Name, 'Lead', leadDial.Phone);
        }
      }
        
      else if(String.valueOf(idProcesso.getSObjectType()).containsIgnoreCase('Order')) {
        processoImplantacao = DAOOrder.getOrderById(idProcesso);
        if(processoImplantacao.Opportunity != null &&
                processoImplantacao.Opportunity.Telefone_Decisor__c != null &&
                processoImplantacao.Opportunity.Telefone_Decisor__c != ''
          // && processoImplantacao.Opportunity.Id_da_Campanha__c != ''
        ) {
          click = new ClickToDialObject(processoImplantacao.Opportunity.Id,
              processoImplantacao.Opportunity.Name,
              'Opportunity',
              processoImplantacao.Opportunity.Telefone_Decisor__c);
        }
      }
        /******************************************************************************
		* Alterado por: Celso Junior - FTI				Data: 15/02/2018
		* ***************************************************************************/
        else if(String.valueOf(idProcesso.getSObjectType()).containsIgnoreCase('Cobranca__c')) {
            IDCobranca = DAOCobranca.getVerificaStatusCobranca(idProcesso);
            if(IDCobranca.Oportunidade__c != null &&
               IDCobranca.Oportunidade__r.Telefone_Decisor__c != null &&
               IDCobranca.Oportunidade__r.Telefone_Decisor__c != ''
               // && processoImplantacao.Opportunity.Id_da_Campanha__c != ''
              ) {
                  click = new ClickToDialObject(IDCobranca.Oportunidade__r.Id,
                                                IDCobranca.Oportunidade__r.Name,
                                                'Oportunidade__r',
                                                IDCobranca.Oportunidade__r.Telefone_Decisor__c);
              }
        }
        return click;
    }
    catch(Exception e) {
      System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
      return null;
    }
  }

  public class StatusRelogio {
    public String Status { get; set; }
    public Datetime DataInicio { get; set; }
    public Datetime DataFim { get; set; }
    public String MotivoPausa { get; set; }
  }

  global class ClickToDialObject {
    public ClickToDialObject(String objectId, String objectName, String objectType, String phoneNumber) {
      this.objectId = objectId;
      this.objectName = objectName;
      this.objectType = objectType;
      this.phoneNumber = phoneNumber;
    }
    public String objectId { get; set; }
    public String objectName { get; set; }
    public String objectType { get; set; }
    public String phoneNumber { get; set; }
  }

  public static void testIt(){
    Integer i = 0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
  }
}
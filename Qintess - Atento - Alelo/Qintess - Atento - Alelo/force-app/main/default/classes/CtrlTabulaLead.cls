public class CtrlTabulaLead {
    public Lead leadObj { get; set; }
    private Map<String, TabulacoesNovo__c> mTabulacoes { get; set; }
    private Map<String, TabulacoesNovo__c> mapNames { get; set; }

    public String ctiMessage {get; set;}
    public TabulacoesNovo__c tab1 { get; set; }
    public String tabulacao1 { get; set; }
    public Boolean liberarAba { get; set; }
    public Boolean isConverted { get; set; }
    public String opportunityConvertedId { get; set; }
    public Boolean salvo { get; set; }

    public String telefone { get; set; }

    public CtrlTabulaLead(ApexPages.StandardController standardController) {
        this.salvo = false;
        this.leadObj = (Lead) standardController.getRecord();
        this.leadObj = DAOLead.getLead(this.leadObj.Id);
        this.isConverted = this.leadObj.IsConverted;
        this.opportunityConvertedId = this.leadObj.ConvertedOpportunityId;
        this.liberarAba = false;
        mTabulacoes = TabulacoesNovo__c.getAll();
        mapNames = new Map<String, TabulacoesNovo__c>();
        for (String key : mTabulacoes.keySet()) {
            if (mTabulacoes.get(key).Motivo_Detalhado__c != null && mTabulacoes.get(key).Motivo_Detalhado__c != '' &&
                    !mTabulacoes.get(key).Omitir_Usuario__c)
                mapNames.put(mTabulacoes.get(key).Motivo_Detalhado__c, mTabulacoes.get(key));
        }
    }

    public List<SelectOption> getTabulacoes() {
        List<SelectOption> retorno = new List<SelectOption>();
        List<String> namesTab = new List<String>();

        retorno.add(new SelectOption('', 'Selecione a Tabulação'));

        namesTab.addAll(mapNames.keySet());
        namesTab.sort();
        for (String tb : namesTab) {
            TabulacoesNovo__c tabulac = mapNames.get(tb);
            retorno.add(new SelectOption(tabulac.Name, tabulac.Motivo_Detalhado__c));
        }


        return retorno;
    }

    public void salvar() {
        try {
            if (tab1 != null) {
                this.liberarAba = true;
                if (this.leadObj.Phone != null &&
                                this.leadObj.Phone.replaceAll(' ', '') == telefone.replaceAll(' ', '')) {
                    this.leadObj.Status1__c = tab1.Status_1__c;
                    this.leadObj.Tabulacao1__c = tab1.Tabulacao_1__c;
                } else if (this.leadObj.Telefone2__c != null &&
                                this.leadObj.Telefone2__c.replaceAll(' ', '') == telefone.replaceAll(' ', '')) {
                    this.leadObj.Status2__c = tab1.Status_1__c;
                    this.leadObj.Tabulacao2__c = tab1.Tabulacao_1__c;
                } else if (this.leadObj.Telefone3__c != null &&
                                this.leadObj.Telefone3__c.replaceAll(' ', '') == telefone.replaceAll(' ', '')) {
                    this.leadObj.Status3__c = tab1.Status_1__c;
                    this.leadObj.Tabulacao3__c = tab1.Tabulacao_1__c;
                } else if (this.leadObj.Telefone4__c != null &&
                                this.leadObj.Telefone4__c.replaceAll(' ', '') == telefone.replaceAll(' ', '')) {
                    this.leadObj.Status4__c = tab1.Status_1__c;
                    this.leadObj.Tabulacao4__c = tab1.Tabulacao_1__c;
                } else if (this.leadObj.Telefone5__c != null &&
                                this.leadObj.Telefone5__c.replaceAll(' ', '') == telefone.replaceAll(' ', '')) {
                    this.leadObj.Status5__c = tab1.Status_1__c;
                    this.leadObj.Tabulacao5__c = tab1.Tabulacao_1__c;
                }

                Datetime dataAgendamento = this.leadObj.Agendamento_Retorno__c;
                this.leadObj.Motivo_Detalhado__c = null;
                update this.leadObj;

                this.leadObj.Motivo_Detalhado__c = tab1.Motivo_Detalhado__c;

                if (tab1.Status_do_Lead__c != null)
                    this.leadObj.Status = tab1.Status_do_Lead__c;


                System.debug('tab1: ' + JSON.serialize(tab1));
                System.debug('lead: ' + JSON.serialize(this.leadObj));
                if ((tab1 != null && tab1.Agendamento__c) &&
                                this.leadObj.Agendamento_Retorno__c == null) {
                    ApexPages.addmessage(
                            new ApexPages.message(ApexPages.severity.ERROR,
                                    'Por favor preencha a data de Agendamento!'));
                    return;
                }

                TOCTIMessage model = new TOCTIMessage();

                model.Id = string.valueOf(this.leadObj.Motivo_Detalhado__c.ReplaceAll('.+\\((\\d+)\\).*', '$1'));

                model.DataAgendamento =
                        this.leadObj.Agendamento_Retorno__c == null ? '' : this.leadObj.Agendamento_Retorno__c.format(
                        'dd/MM/yyyy HH:mm');

                model.Tipo = 'Tabulacao';

                this.ctiMessage = json.serialize(model);
                update this.leadObj;

                this.leadObj = DAOLead.getLead(this.leadObj.Id);
                System.debug('this.lead: ' + JSON.serialize(this.leadObj));
                this.isConverted = this.leadObj.IsConverted;
                this.opportunityConvertedId = this.leadObj.ConvertedOpportunityId;
                ApexPages.addmessage(
                        new ApexPages.message(ApexPages.severity.CONFIRM, 'Operação realizada com sucesso!'));
                this.salvo = true;
            }
        } catch (DmlException ex) {
            system.debug('DmlException: ' + ex.getLineNumber());
            system.debug('DmlException: ' + ex.getStackTraceString());
            system.debug('DmlException: ' + ex.getTypeName());
            system.debug('DmlException: ' + ex.getCause());
            system.debug('DmlException: ' + ex.getMessage());

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));
        } catch (Exception ex) {
            system.debug('Exception: ' + ex.getLineNumber());
            system.debug('Exception: ' + ex.getStackTraceString());
            system.debug('Exception: ' + ex.getTypeName());
            system.debug('Exception: ' + ex.getCause());
            system.debug('Exception: ' + ex.getMessage());

            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro na atualização.'));
        }
    }

    public void selecionarTabulacao() {
        tab1 = tabulacao1 != null && tabulacao1 != '' ? mTabulacoes.get(tabulacao1) : null;
        System.debug('tab1: ' + JSON.serialize(tab1));
        System.debug('tabulacao1: ' + JSON.serialize(tabulacao1));
    }
}
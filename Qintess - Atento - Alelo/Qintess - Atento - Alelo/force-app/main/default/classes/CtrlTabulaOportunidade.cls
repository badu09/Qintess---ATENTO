public class CtrlTabulaOportunidade {
    public Opportunity oportunidade { get; set; }
    public Opportunity fakeOportunidade { get; set; }
    private Map<String, TabulacoesNovo__c> mTabulacoes { get; set; }
    private Map<String, TabulacoesNovo__c> mapNames { get; set; }

    public String ctiMessage {get; set;}
    public TabulacoesNovo__c tab1 { get; set; }
    public String tabulacao1 { get; set; }
    public Boolean liberarAba { get; set; }

    public String telefone { get; set; }
    public Boolean salvo { get; set; }

    public CtrlTabulaOportunidade(ApexPages.StandardController standardController) {
        this.salvo = false;
        this.oportunidade = (Opportunity) standardController.getRecord();
        this.fakeOportunidade = new Opportunity();
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

            //VANER
            //this.oportunidade.Flag_Tabulacao__c = false;
            //update oportunidade;
            //VANER

            this.oportunidade = DAOOpportunity.getOpportunityById(this.oportunidade.Id);
            this.oportunidade.Agendamento_Retorno__c = this.fakeOportunidade.Agendamento_Retorno__c;
            if ((oportunidade.Telefone_Decisor__c != null && oportunidade.Telefone_Decisor__c != '')
                //      || (oportunidade.Telefone_Operacional__c != null && oportunidade.Telefone_Operacional__c != '')
            ) {
                if (tab1 != null) {

                    //VANER
                    this.oportunidade.Flag_Tabulacao__c = false;
                    oportunidade.Motivo_Detalhado__c = null;
                    update oportunidade;
                    //VANER

                    oportunidade.Motivo_Detalhado__c = tab1.Motivo_Detalhado__c;
                    if (tab1.FaseOportunidade__c != null && tab1.FaseOportunidade__c != '')
                        oportunidade.StageName = tab1.FaseOportunidade__c;
                    //VANER
                    oportunidade.Flag_Tabulacao__c = TRUE;
                    //VANER

                    update oportunidade;
                }
            }

            if (tab1 != null) {

                //VANER
                this.oportunidade.Flag_Tabulacao__c = false;
                System.debug('Oportunidade 1: ' + JSON.serialize(this.oportunidade));
                update oportunidade;
                //VANER

                TOCTIMessage model = new TOCTIMessage();

                model.Id = string.valueOf(this.oportunidade.Motivo_Detalhado__c.ReplaceAll('.+\\((\\d+)\\).*', '$1'));

                model.DataAgendamento =
                        this.oportunidade.Agendamento_Retorno__c ==
                        null ? '' : this.oportunidade.Agendamento_Retorno__c.format(
                        'dd/MM/yyyy HH:mm');

                model.Tipo = 'Tabulacao';

                this.ctiMessage = json.serialize(model);

                //VANER
                this.oportunidade.Flag_Tabulacao__c = true;
                //VANER
                System.debug('Oportunidade 2: ' + JSON.serialize(this.oportunidade));
                update this.oportunidade;

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
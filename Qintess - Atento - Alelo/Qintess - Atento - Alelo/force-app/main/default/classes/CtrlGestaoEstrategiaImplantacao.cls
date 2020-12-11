global with sharing class CtrlGestaoEstrategiaImplantacao
{
    
    public boolean displayModalNova {get; set;}
    public boolean displayModalAtivado {get; set;}
    public String idEstrategia {get; set;}
    public String fieldsRequired {get; set;}
    public Boolean camposObrigatorios {get; set;}
    public Boolean verificaDataInicio {get; set;}
    public Boolean validacaoFidelizacao {get; set;}
    public Boolean isNotValidacaoFidelizacao {get; set;}
    public String relSelecionado {get; set;}
    public Date dataValida {get; set;}
    public Date dateValidaDataInicioVig {get; set;}
    public String quantidadeMaximaTentativas {get; set;}
    public String dataInicio {get; set;}
    public String idDesativado {get; set;}
    public string idRenitencia {get; set;}
    
    
    public final String nomeReport = 'Implantação - Gestão de Estratégia';
    public final String implantacao = 'Implantação';
    
    public Estrategia_Implantacao__c estrategia;
    
    
    public CtrlGestaoEstrategiaImplantacao(ApexPages.StandardSetController controller) {
        this.estrategia = (Estrategia_Implantacao__c)controller.getRecord();
    }
    
    public CtrlGestaoEstrategiaImplantacao() 
    {
        init();
    }
    
    public void init() 
    {
        
        System.debug('Inicio');
        
    }
    
    public List<User> getListaUsuarios(){
        
        List<Profile> listaPerfis = DAOProfile.getProfileByContainsName(implantacao);
        List<User> listaUser = DAOUser.getUserByProfile(listaPerfis);
        
        System.debug('LISTA USER : ' + listaUser);
        
        return listaUser;
    }
    
    public List<SelectOption> getListaRelatorios() 
    {
        List<SelectOption> lstRelatorios = new List<SelectOption>();
        
        lstRelatorios.add(new SelectOption('','-Nenhum-'));
        for(Report relatorio : DAOReport.getReportByFolder(nomeReport))
        {
            lstRelatorios.add(new SelectOption (String.valueOf(relatorio.Id),relatorio.Name));
        }
        
        return lstRelatorios;
    }
    
    public void closeModalNova()
    {
        
        displayModalNova = false;    
        
    }      
    
    public void showModalNova()
    {
        
        limpaCamposModal();
        validacaoFidelizacao = true;
        isNotValidacaoFidelizacao = false;
        displayModalNova = true; 
    }
    public void limpaCamposModal(){
        verificaDataInicio = false;
        camposObrigatorios = true;
        estrategia.id = null;
        relSelecionado = '';
        estrategia.Data_Fim_Vigencia__c = null;
        estrategia.Data_Inicio_Vigencia__c = null;
        estrategia.Implantacao_Fidelizada__c = '';
        estrategia.Quantidade_Maxima_Tentativas__c = null;
        
    }
    
    public void auxiliarModal(){
        camposObrigatorios = false;
        verificaDataInicio = true;
        displayModalNova = true;
        System.debug(fieldsRequired);
        valorizaCamposModal();
        
    } 
    
    public void valorizaCamposModal(){
        Estrategia_Implantacao__c estrategiaImplantacao = DAOEstrategiaImplantacao.getInstance().getEstrategiaImplantacaoById(fieldsRequired);
        System.debug(estrategiaImplantacao.Nome_Relatorio_Estrategia__c);
        
        
        relSelecionado = estrategiaImplantacao.Id_Relatorio_Estrategia__c;
        estrategia.id = estrategiaImplantacao.id;
        estrategia.Nome_Relatorio_Estrategia__c = estrategiaImplantacao.Nome_Relatorio_Estrategia__c;
        estrategia.Data_Fim_Vigencia__c = estrategiaImplantacao.Data_Fim_Vigencia__c;
        estrategia.Data_Inicio_Vigencia__c = estrategiaImplantacao.Data_Inicio_Vigencia__c;
        estrategia.Implantacao_Fidelizada__c = estrategiaImplantacao.Implantacao_Fidelizada__c;
        estrategia.Quantidade_Maxima_Tentativas__c = estrategiaImplantacao.Quantidade_Maxima_Tentativas__c;
        
        //Adequando campo quantidadeMax e Data Inicio para string e convertendo DATA para STRING.
        
        dataValida = System.today();
        dataValida += 1;
        
        if(estrategia.Data_Inicio_Vigencia__c >= dataValida){
            validacaoFidelizacao = true;
            isNotValidacaoFidelizacao = false;
        }else{
            validacaoFidelizacao = false;
            isNotValidacaoFidelizacao = true;
        }
        
        quantidadeMaximaTentativas = string.valueOf(estrategia.Quantidade_Maxima_Tentativas__c);     
        dataInicio = estrategia.Data_Inicio_Vigencia__c.format();
        
        
    }
    
    public Boolean validacaoCamposVazios(){
        Boolean valida = true;
        
        if(this.relSelecionado == null){
            valida = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Favor escolher um relátorio'));
        }
        if (estrategia.Data_Inicio_Vigencia__c == null ) {
            valida = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Favor preencher o campo Data de início.'));
        }
        if (estrategia.Data_Inicio_Vigencia__c <= System.today()) {
            valida = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Data início de vigência deve ser futura.'));
        }
        if (estrategia.Data_Fim_Vigencia__c == null) {
            valida = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Favor preencher o campo Data fim corretamente.'));
        }
        if ( estrategia.Data_Fim_Vigencia__c < estrategia.Data_Inicio_Vigencia__c ) {
            valida = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Data fim de vigência deve ser maior ou igual à data de início.'));
        }
        if (estrategia.Data_Fim_Vigencia__c <= System.today()) {
            valida = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Data fim de vigência deve ser futura.'));
        }
        if (estrategia.Quantidade_Maxima_Tentativas__c == null) {
            valida = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Favor preencher o campo Quantidade máxima de tentativas.'));
        }
        if (estrategia.Implantacao_Fidelizada__c == null) {
            valida = false;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Favor escolher Implantação Fidelizada'));
        }
        
        return valida;
    }
    
    
    public PageReference save()
    {
        Estrategia_Implantacao__c estrategiaImpl = new Estrategia_Implantacao__c();
        
        
        Boolean valida = validacaoCamposVazios();
        
        PageReference  page = null;
        if(valida == true){
            
            Try{
                
                Report relatorio = DAOReport.getReportById(relSelecionado);
                
                estrategiaImpl.Nome_Relatorio_Estrategia__c = relatorio.Name;
                estrategiaImpl.id = estrategia.id;
                estrategiaImpl.Id_Relatorio_Estrategia__c = relSelecionado;
                estrategiaImpl.Data_Fim_Vigencia__c = estrategia.Data_Fim_Vigencia__c;
                estrategiaImpl.Data_Inicio_Vigencia__c = estrategia.Data_Inicio_Vigencia__c;
                estrategiaImpl.Quantidade_Maxima_Tentativas__c = estrategia.Quantidade_Maxima_Tentativas__c;
                estrategiaImpl.Implantacao_Fidelizada__c = estrategia.Implantacao_Fidelizada__c;
                
                DAOEstrategiaImplantacao.getInstance().updateEstrategiaImplantacao(estrategiaImpl); 
                
                displayModalNova = false;
                
                page = new PageReference('/apex/GestaoEstrategiaImplantacao'); 
                page.setRedirect(true);
            }catch (Exception e){
                System.debug('ERRO AO INSERIR IMPLANTAÇÃO ESTRATEGICA ' + e.getMessage());
            }
            
            
            
        }
        return page;
    }
    
    public void Ativar(){
        
        displayModalAtivado = true;
        
    }
    
    
    
    public PageReference Desativar(){
        
        Estrategia_Implantacao__c estrategiaImplantacao = new Estrategia_Implantacao__c();
        estrategiaImplantacao.Ativado__c = false;
        estrategiaImplantacao.id = idDesativado; 

        dateValidaDataInicioVig = System.today();
        
        System.debug('debug Test  : ' + estrategiaImplantacao.id);
        estrategiaImplantacao = DAOEstrategiaImplantacao.getInstance().updateEstrategiaImplantacao(estrategiaImplantacao);
        
        List<Opportunity> listaOpportunity = DAOOpportunity.getOpportunityForEstrategia(String.valueOf(estrategiaImplantacao.id));

        System.debug('lista Opp antes do if > ' + listaOpportunity.size());
        List<Opportunity> listaOpportunityUpdate = new List<Opportunity>();

        if(estrategiaImplantacao.Data_Inicio_Vigencia__c <= dateValidaDataInicioVig){

            for(Opportunity oppObj : listaOpportunity){
                if((oppObj.Processo_Implantacao__r.OwnerId != null) && (oppObj.Processo_Implantacao__r.OwnerId == estrategiaImplantacao.Fila_Nova__c || oppObj.Processo_Implantacao__r.OwnerId == estrategiaImplantacao.Fila_Contatado__c)){
                    oppObj.Estrategia_Implantacao__c = null;
                    listaOpportunityUpdate.add(oppObj);
                }
            }

         listaOpportunityUpdate = DAOOpportunity.updateListOpportunity(listaOpportunityUpdate);
         System.debug('Lista opp : ' + listaOpportunityUpdate.size());

        }
     
        PageReference  page = new PageReference('/apex/GestaoEstrategiaImplantacao'); 
        page.setRedirect(true);
        
        return page;
        
    }
    
    public PageReference Resubmeter(){
        
        Estrategia_Implantacao__c estrategiaImpl = new Estrategia_Implantacao__c();
        estrategiaImpl.Renitencia__c = true;
        estrategiaImpl.Id = idRenitencia;
        
        system.debug('estrategiaImpl.id: '+estrategiaImpl.id);
        estrategiaImpl = DAOEstrategiaImplantacao.getInstance().updateEstrategiaImplantacao(estrategiaImpl);
        
        PageReference  page = new PageReference('/apex/GestaoEstrategiaImplantacao'); 
        page.setRedirect(true);
        
        return page;
    }
    
}
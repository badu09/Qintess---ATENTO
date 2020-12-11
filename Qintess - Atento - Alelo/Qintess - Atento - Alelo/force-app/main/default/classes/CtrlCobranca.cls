global class CtrlCobranca {

    public String ctiMessage {get; set;}

    public Cobranca__c cobranca {get; set;}

    public List<Cobranca__c> lCobranca {get; set;}

    Public List<Opportunity> lOportunidade {get; set;}

    public Opportunity oportunidade {get; set;}

    public TOCTIMessage model { get; set; }
    
    
    public CtrlCobranca(ApexPages.StandardController controller){
        if (! Test.isRunningTest ()) { 
            controller.addFields(new List<String> {'Account.Id', 'Account.CPF_CNPJ__c'});}
        
        this.oportunidade = (Opportunity)controller.getRecord();

        system.debug('oportunidade: ' + json.serialize(this.oportunidade));

    }

    public void carregaProduto() {
        
        Set<id> setOportunidade = new Set<id>();
        
        this.lOportunidade = new List<Opportunity>();
        
        this.lOportunidade =
            DAOOpportunity.getOpportunityForAccountProdutoAleloByCobranca(this.oportunidade.Account.Id, this.oportunidade.id);
        system.debug('this.lOportunidade: ' + this.lOportunidade);
        
        for (Opportunity item : this.lOportunidade) {
            setOportunidade.add(item.id);
        }
        
		this.lCobranca = DAOCobranca.getCarregaCobranca(setOportunidade);
		system.debug('this.lCobranca: ' + this.lCobranca);
        
		List<Cobranca__c> lCobrancaAux = new List<Cobranca__c>();

		for (Cobranca__c cob :this.lCobranca) {
			cob.Status__c = 'Cobranca';

			lCobrancaAux.add(cob);
		}
		update lCobrancaAux;
		this.lCobranca = lCobrancaAux;

		system.debug('this.lCobranca: ' + this.lCobranca);
	}

	private void atualizarCobranca() {

		List<Cobranca__c> lCobranca = new List<Cobranca__c>();

		for (Cobranca__c cob :this.lCobranca) {
			if (cob.Produtos_Alelo__c != null && cob.Status__c != 'Finalizado') {

				if ((String.isNotBlank(cob.Tabulacao_Cobranca_Pai__c))) {

					cob.Status__c = 'Disponível';
					cob.Data_Hora_Tabulacao__c = Datetime.now();
					lCobranca.add(cob);
				}
			}
		}

		system.debug('lCobranca: ' + json.serialize(lCobranca));
		if (!lCobranca.isEmpty()) {
			update this.lCobranca;
		}else{
			update this.lCobranca;
		}
	}

	private void enviarCTIMessage() {
    	 
    	this.ctiMessage = '';
    	 
    	Opportunity oportunidadePrincipal = DAOOpportunity.getOpportunityById(this.oportunidade.Id);
    		
    	model = new TOCTIMessage();
    	
    	model.Id = string.valueOf(oportunidadePrincipal.Tabulacao_OLOS_para_Implantacao__c);
    		
    	model.Tipo = 'Tabulacao';
         
         system.debug('model: '+model);
    	
    	this.ctiMessage = json.serialize(model);
    	
    	system.debug('ctiMessage: ' + this.ctiMessage);
    }

    public void salvar() {
        
        try {
            if(this.lCobranca.isEmpty()){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Operação não realizada! Você não possui uma cobrança'));
                enviarCTIMessage();

            }else{

                atualizarCobranca();

                enviarCTIMessage();
                
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Operação realizada com sucesso.'));
            }
        }
    	catch(DmlException ex) {
    		system.debug('DmlException: ' + ex.getLineNumber());
            system.debug('DmlException: ' + ex.getStackTraceString());
            system.debug('DmlException: ' + ex.getTypeName());
            system.debug('DmlException: ' + ex.getCause());
            system.debug('DmlException: ' + ex.getMessage());
            
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getDmlMessage(0)));
		}
    	catch(Exception ex) {
    		system.debug('Exception: ' + ex.getLineNumber());
            system.debug('Exception: ' + ex.getStackTraceString());
            system.debug('Exception: ' + ex.getTypeName());
            system.debug('Exception: ' + ex.getCause());
            system.debug('Exception: ' + ex.getMessage());
    		
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro na atualização.'));
		}
    }
}
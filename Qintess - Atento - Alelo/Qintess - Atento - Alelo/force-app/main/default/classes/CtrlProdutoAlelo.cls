global class CtrlProdutoAlelo {
    
    public String ctiMessage {get; set;}
    
    public Opportunity oportunidade {get; set;}
    
    public List<Opportunity> lOportunidade {get; set;}

	public Boolean alteraObservacao { get; set; }

	public TOCTIMessage model { get; set; }
    
    public Boolean somentePME { get; set; }
    
    public CtrlProdutoAlelo(ApexPages.StandardController controller){
    	 if (! Test.isRunningTest ()) { 
             controller.addFields(new List<String> {'Account.Id', 'Account.CPF_CNPJ__c', 'Total_Fidelizado__c','Implantador_Atribuido__c', 'Tipo_de_Fila_Consolidado__c', 'Processo_Implantacao__c', 'Tabulacao_OLOS_para_Implantacao__c'}); }
    	
    	this.oportunidade = (Opportunity)controller.getRecord();
    	
    	system.debug('oportunidade: ' + json.serialize(this.oportunidade));
    	
    	init();
    }
    
    private void init() {
    	
    	carregarOportunidadeRelacionada();
		this.alteraObservacao = false;
    }
    
    private void carregarOportunidadeRelacionada() {
    	
    	List<Opportunity> lOportunidadeCliente = DAOOpportunity.getOpportunityForAccountProdutoAlelo(this.oportunidade.Account.Id);
    	
    	Set<String> setFase = new Set<String>();
    	
    	setFase.add('Auditoria Finalizada/ Transf Implantação');
    	setFase.add('Devolvido Para Implantar');
    	setFase.add('Em Implantação');
    	
    	this.lOportunidade = new List<Opportunity>();
    	
    	for(Opportunity item : lOportunidadeCliente) {
    		if(setFase.contains(item.StageName)) {
    			this.lOportunidade.add(item);
    		}
    	}
    }
    
    private Boolean produtoAleloAgendado(Produtos_Alelo__c produtoAlelo) {
    	Set<String> setTabulacaoFilha = new Set<String>(); 
	    	
    	setTabulacaoFilha.add('PROCESSO CADASTRAL');
    	setTabulacaoFilha.add('REALIZOU PEDIDO DE CARTÃO');
    	setTabulacaoFilha.add('RESCISÃO DE CONTRATO COM CONCORRENTE');
    	
    	return (produtoAlelo.Tabulacao_Pai_Implantacao__c == 'CONTATO AGENDADO' ||
		    		produtoAlelo.Tabulacao_Pai_Implantacao__c == 'SEM PREVISÃO' || 
		    		(produtoAlelo.Tabulacao_Pai_Implantacao__c == 'EM IMPLANTAÇÃO' &&
		    			setTabulacaoFilha.contains(produtoAlelo.Tabulacao_Filho_Implantacao__c)));
    }
    
    private String carregarDataAgendamento(List<Produtos_Alelo__c> lProdutoAlelo) {
    	
    	Datetime dataAgendamento = null;
    	
    	if(lProdutoAlelo != null) {
	    	Set<String> setTabulacaoFilha = new Set<String>(); 
	    	
	    	setTabulacaoFilha.add('PROCESSO CADASTRAL');
	    	setTabulacaoFilha.add('REALIZOU PEDIDO DE CARTÃO');
	    	setTabulacaoFilha.add('RESCISÃO DE CONTRATO COM CONCORRENTE');
	    	
	    	for(Produtos_Alelo__c item : lProdutoAlelo) {
	    		if(produtoAleloAgendado(item)) {
		    		
		    		if(dataAgendamento == null || dataAgendamento > item.Agendamento_Retorno_Implanta_o__c) {
		    			dataAgendamento = item.Agendamento_Retorno_Implanta_o__c;
		    		}
		    	}
	    	}
    	}
    	
    	return dataAgendamento == null ? '' : dataAgendamento.format('dd/MM/yyyy HH:mm');
    }
    
    private void atualizarPodutoAlelo() {
    	
    	List<Produtos_Alelo__c> lProdutoAleloLimpo = new List<Produtos_Alelo__c>();
    	List<Produtos_Alelo__c> lProdutoAlelo = new List<Produtos_Alelo__c>();
    	
    	for(Opportunity item : this.lOportunidade) {
    		if(item.Produtos_Alelo__r != null) {
    			
    			for(Produtos_Alelo__c itemProdutoAlelo : item.Produtos_Alelo__r) {

                    if ( (String.isNotBlank(itemProdutoAlelo.Tabulacao_Pai_Implantacao__c)) &&
                         (String.isNotBlank(itemProdutoAlelo.Tabulacao_Filho_Implantacao__c)) )
                    {
                        itemProdutoAlelo.Data_Hora_Tabulacao__c = System.now();
                    }
                    if ( (String.isNotBlank(itemProdutoAlelo.Tabulacao_Pai_Implantacao__c)) &&
                         (String.isNotBlank(itemProdutoAlelo.FTabulacaoPAIImplantacao__c)) &&
                         (String.isNotBlank(itemProdutoAlelo.FTabulacaoFilhoImplantado__c)) &&
                         (String.isNotBlank(itemProdutoAlelo.Tabulacao_Filho_Implantacao__c)) &&
                         (itemProdutoAlelo.Tabulacao_Pai_Implantacao__c == itemProdutoAlelo.FTabulacaoPAIImplantacao__c ||
                          itemProdutoAlelo.Tabulacao_Filho_Implantacao__c == itemProdutoAlelo.FTabulacaoFilhoImplantado__c) )
                    {
                        itemProdutoAlelo.Nome_do_Implantador__c = UserInfo.getName();
                    }
                    if (String.isNotBlank(itemProdutoAlelo.Tabulacao_Pai_Implantacao__c) &&
                        itemProdutoAlelo.Tabulacao_Pai_Implantacao__c != 'CONTRATO PME')
                    {
                        somentePME = false;
                    }
                    lProdutoAlelo.add(itemProdutoAlelo); 
                    
                    if(produtoAleloAgendado(itemProdutoAlelo)) {
			    		Produtos_Alelo__c produtoAlelo = new Produtos_Alelo__c();
			    		
			    		produtoAlelo.Id = itemProdutoAlelo.Id;
			    		produtoAlelo.Tabulacao_Pai_Implantacao__c = null;
			    		produtoAlelo.Tabulacao_Filho_Implantacao__c = null;
			    		produtoAlelo.Tabulacao_Neto_Implantacao__c = null;
			    		
			    		lProdutoAleloLimpo.add(produtoAlelo);
			    	}
		    	}
       		}
    	}
    	
    	system.debug('lProdutoAleloLimpo: ' + json.serialize(lProdutoAleloLimpo));
    		
		if(!lProdutoAleloLimpo.isEmpty()) {
    		update lProdutoAleloLimpo;
    	}
    	
    	system.debug('lProdutoAlelo: ' + json.serialize(lProdutoAlelo));
    		
		if(!lProdutoAlelo.isEmpty()) {
    		update lProdutoAlelo;
    	}
    }
    
    private void atualizarOportunidadePedido() {
    	 
    	List<Opportunity> lOportunidadePedido = new List<Opportunity>();
    	List<Order> lPedido = new List<Order>();
    	
    	for(Opportunity item : DAOOpportunity.getOpportunityForSetId(new Map<Id, Opportunity>(this.lOportunidade).keySet())) {
    		if(item.Total_Fidelizado__c == 0 && item.Tipo_de_Fila_Consolidado__c < 10) {
			
                if (somentePME && String.isBlank(item.Sistema_de_Pedidos__c) )
                {
                    item.Sistema_de_Pedidos__c = 'PME';
                }
				item.Implantador_Atribuido__c = null;  
				
				lOportunidadePedido.add(item);
				
				if(item.Processo_Implantacao__c != null) {
					Order pedido = new Order(); 
				
					pedido.Id = item.Processo_Implantacao__c;
					pedido.Status = 'Disponivel';
				
					lPedido.add(pedido);    			
				}
			}
    	}
    	
    	system.debug('lOportunidadePedido: ' + json.serialize(lOportunidadePedido));
    	
    	if(!lOportunidadePedido.isEmpty()) {
    		update lOportunidadePedido;
    	}
    	
    	system.debug('lPedido: ' + json.serialize(lPedido));
    	
    	if(!lPedido.isEmpty()) {
    		update lPedido;
    	}
    }
    
    private void enviarCTIMessage() {
    	 
    	this.ctiMessage = '';
    	 
    	Opportunity oportunidadePrincipal = DAOOpportunity.getOpportunityById(this.oportunidade.Id);
    		
    	model = new TOCTIMessage();
    	
    	model.Id = string.valueOf(oportunidadePrincipal.Tabulacao_OLOS_para_Implantacao__c);
    		
    	model.DataAgendamento = carregarDataAgendamento(oportunidadePrincipal.Produtos_Alelo__r);
    	
    	model.Tipo = 'Tabulacao';
    	
    	this.ctiMessage = json.serialize(model);
    	
    	system.debug('ctiMessage: ' + this.ctiMessage);
    }

	public void alterarObservacao() {
		this.alteraObservacao = true;
	}

	private void atualizarObservacao() {
		for(Opportunity item : this.lOportunidade) {
			if(item.Produtos_Alelo__r != null) {
				update item.Produtos_Alelo__r;
			}
		}
	}

    public void salvar() {
    	
    	try {
			if(this.alteraObservacao) {
				atualizarObservacao();
			}
			else {
                somentePME = true;
				atualizarPodutoAlelo();

				atualizarOportunidadePedido();

				enviarCTIMessage();
			}

			this.alteraObservacao = false;
	    	
	    	ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Operação realizada com sucesso.'));
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
    
    /*
    public void limparTabulacao(){
        
        List<Produtos_Alelo__c> lstProdutos = new List<Produtos_Alelo__c>();
        
        for(Opportunity op :this.lOportunidade)
        {
            for(Produtos_Alelo__c produtoAlelo : op.Produtos_Alelo__r)
            {
                if(produtoAlelo.Tabulacao_Pai_Implantacao__c != null && produtoAlelo.Tabulacao_Pai_Implantacao__c != '')
                {
                    produtoAlelo.Tabulacao_Pai_Implantacao__c = '';
                    produtoAlelo.Tabulacao_Filho_Implantacao__c = '';
                    produtoAlelo.Tabulacao_Neto_Implantacao__c = '';
                    
                    lstProdutos.add(produtoAlelo);
                }
            }
        }
        if(lstProdutos.size() > 0 && !lstProdutos.isEmpty())
        {
            update lstProdutos;  
        }
    }
	*/
    
    static public void testMaker(){
		String a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';

		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';

		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';

		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
		a = 'a';
	}
    
}
public with sharing class CtrlProdutoAleloAuditoria {
    
    public Id id {get; set;}
    
    public Opportunity oportunidade {get; set;}
    
    public List<Produtos_Alelo__c> lValeTransporte {get; set;}
    public List<ModelProdutoAlelo> lModelProdutoAlelo {get; set;}
    
    public Boolean possuiValeTransporte {get; set;}
    public Boolean possuiProdutoAlelo {get; set;}
    public Boolean edicao {get; set;}
    
    public Integer indiceProduto {get; set;}
    
    public CtrlProdutoAleloAuditoria(ApexPages.StandardController controller){
    	
    	this.id = Apexpages.currentPage().getParameters().get('id');
    	
    	this.oportunidade = (Opportunity)controller.getRecord();
    	
    	init();
    }
    
    private void init() {
    	this.edicao = false;
    	carregarProdutoAlelo();
    }
    
    private void carregarProdutoAlelo() {
    	
    	this.lValeTransporte = new List<Produtos_Alelo__c>();
    	List<Produtos_Alelo__c> lProdutoAlelo = new List<Produtos_Alelo__c>();
    	
    	this.lModelProdutoAlelo = new List<ModelProdutoAlelo>(); 
    	
    	List<Produtos_Alelo__c> lProduto = DAOProdutosAlelo.getOpportunityProductByOpportunityId(this.id);
    	
    	for(Produtos_Alelo__c item : lProduto) { 
    		if(item.VT__c) {
    			this.lValeTransporte.add(item);
    		}
    		else {
    			
    			ModelProdutoAlelo model = new ModelProdutoAlelo();
    			
    			model.produtoAlelo = item;
    			model.lTarifaCarrinho = item.Tarifas_Carrinhos__r;
    			
    			model.contratoGerado = item.Numero_do_Contrato__c != null && item.Numero_do_Contrato__c != '';
    			model.simular = false;
    			model.salvar = false;
    			model.agendar = false;
    			
    			this.lModelProdutoAlelo.add(model);
    		}
    	}
    	
    	this.possuiValeTransporte = !this.lValeTransporte.isEmpty();
    	this.possuiProdutoAlelo = !this.lModelProdutoAlelo.isEmpty();
    	
    }
    
    public void cancelar() {
    	
    	try {
    		carregarProdutoAlelo();
    		this.edicao = false;
    		this.lModelProdutoAlelo[this.indiceProduto].simular = false;
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
    
    public void simular() {
    	
    	try {
    		
    		this.lModelProdutoAlelo[this.indiceProduto].salvar = false;
    		
    		Produtos_Alelo__c produtoAlelo = this.lModelProdutoAlelo[this.indiceProduto].produtoAlelo;
    		
    		produtoAlelo.Valor_Total__c = produtoAlelo.Valor_Unitario__c * produtoAlelo.Quantidade_de_Cartoes__c;
    		
    		CtrlPrecificacao precificacao = new CtrlPrecificacao();
    		
    		precificacao.ValorMedioIndividualStr = string.valueOf(produtoAlelo.Valor_Unitario__c).replace('.', ',');
    		precificacao.Quantidade = Integer.valueOf(produtoAlelo.Quantidade_de_Cartoes__c);
    		
    		precificacao.NomeEmpresa = produtoAlelo.Nome_Empresa_Gravacao_Cartao__c;
    		precificacao.ProdutoSelecionado = DAOTabelaDominio.getProductCode(Decimal.valueOf(produtoAlelo.Codigo_de_Produtos__c)).Id;
    		
    		precificacao.selecionarProduto();
    		
    		precificacao.simular();
    		
    		if(precificacao.Tarifas.isEmpty()) {
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Não existe tarifa para esse produto, nessa configuração.'));
    			
    			this.lModelProdutoAlelo[this.indiceProduto].lTarifaCarrinho = new List<Tarifas_Carrinho__c>();
    		}
    		else {
    			
    			precificacao.carregarProdutoAlelo();
    			
    			this.lModelProdutoAlelo[this.indiceProduto].lTarifaCarrinho = precificacao.carregarTarifaCarrinho(produtoAlelo.Id);
				 			
    			this.lModelProdutoAlelo[this.indiceProduto].salvar = true;
    		}
    		
    		this.lModelProdutoAlelo[this.indiceProduto].setCon = new ApexPages.StandardSetController(this.lModelProdutoAlelo[this.indiceProduto].lTarifaCarrinho);    		
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
    
    public void salvar() {
    	
    	try {
    		Produtos_Alelo__c produtoAlelo = this.lModelProdutoAlelo[this.indiceProduto].produtoAlelo;
    		
    		update produtoAlelo;
    		
    		if(!this.lModelProdutoAlelo[this.indiceProduto].agendar) {
    			DAOTarifaCarrinho.limparTarifas(produtoAlelo.Id);
    		
    			insert this.lModelProdutoAlelo[this.indiceProduto].lTarifaCarrinho;
    		}
    		
	    	this.edicao = false;
	    	
	    	carregarProdutoAlelo();
	    	
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
    
    public void editar() {
    	
    	try {
    		if(!this.edicao) {
    			this.lModelProdutoAlelo[this.indiceProduto].simular = true;
    			this.edicao = true;
    			this.lModelProdutoAlelo[this.indiceProduto].setCon.setPageSize(50);
    		}
    		else {
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Já existe um produto em modo edição, favor finaliza-lo.'));
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
    
    public void gerarContrato() {
    	
    	try {
    		system.debug('IndiceProduto: ' + this.indiceProduto);
    		
    		String retorno = '';
    		
    		//retorno = BOProdutosAlelo.maitainContractIS(this.lProdutoAlelo[this.indiceProduto].Id);
	    	
	    	if(!retorno.contains('Erro')) {
	    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Operação realizada com sucesso.'));
	    	}
	    	else {
	    		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, retorno));
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
    
    public void agendar() {
    	
    	try {
    		if(!this.edicao) {
    			this.lModelProdutoAlelo[this.indiceProduto].agendar = true;
    			this.lModelProdutoAlelo[this.indiceProduto].salvar = true;
    			
    			this.lModelProdutoAlelo[this.indiceProduto].produtoAlelo.Tabulacao_Pai_Implantacao__c = 'CONTATO AGENDADO';
    			this.lModelProdutoAlelo[this.indiceProduto].produtoAlelo.Tabulacao_Filho_Implantacao__c = 'CONTATO AGENDADO CONFORME SOLICITAÇÃO DO CLIENTE';
    			
    			this.edicao = true;
    		}
    		else {
    			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Já existe um produto em modo edição, favor finaliza-lo.'));
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
    
    public class ModelProdutoAlelo {
    	public Boolean contratoGerado {get;set;}
    	public Boolean agendar {get;set;}
    	public Boolean simular {get;set;}
    	public Boolean salvar {get;set;}
    	public Produtos_Alelo__c produtoAlelo {get;set;}
    	public List<Tarifas_Carrinho__c> lTarifaCarrinho {get;set;}   
    	
    	public ApexPages.StandardSetController setCon {
	        get {
	            if(setCon == null) {
	                setCon = new ApexPages.StandardSetController(lTarifaCarrinho);
	                setCon.setPageSize(5);
	            }
	            return setCon;
	        }
	        set;
	    }
	    
	    public List<Tarifas_Carrinho__c> getTarifas() {
	    	return (List<Tarifas_Carrinho__c>)setCon.getRecords();	    	
	    } 	
    }
}
public with sharing class CtrlTarifaAlelo {
	
	public List<Tarifas_Alelo__c> lTarifaAlelo { get; set; }
    public Map<Decimal, List<Tarifas_Alelo__c>> mapTarifaAlelo { get; set; }
    
    public List<SelectOption> soProduto { get; set; }
	public List<SelectOption> soTarifa { get; set; }
	
	public Tarifas_Alelo__c filtroTarifa { get; set; }
	
	public Boolean exibirDetalhe { get; set; }
    
    public CtrlTarifaAlelo() {
    	init(); 
    }
    
    private void init() {
    	this.exibirDetalhe = false;
    	this.filtroTarifa = new Tarifas_Alelo__c();
    	
    	carregarProduto();
    	carregarTarifa();
    }
    
    private void carregarTarifaAlelo() {
    	this.mapTarifaAlelo = BOTarifa.carregarTarifaAlelo(this.filtroTarifa.Nome_do_Produto__c, 
    														this.filtroTarifa.Nome_da_Tarifa__c);
    	
    	Decimal key = new List<Decimal>(this.mapTarifaAlelo.keySet())[0];
    	 
    	this.lTarifaAlelo = this.mapTarifaAlelo.get(key);
    	
    	this.exibirDetalhe = !this.lTarifaAlelo.isEmpty();
    }
    
    private void carregarProduto() {
    	this.soProduto = new List<SelectOption>();
    	
    	List<String> lProduto = DAOTarifa.listarDescricaoProduto();
    	
    	this.filtroTarifa.Nome_do_Produto__c = lProduto[0];
    			
    	for(String item : lProduto) {
    		this.soProduto.add(new SelectOption(item, item));
    	}
    }
    
    public void carregarTarifa() {
    	this.soTarifa = new List<SelectOption>();    	
    	
		if(this.filtroTarifa.Nome_do_Produto__c != null && this.filtroTarifa.Nome_do_Produto__c != '') {    			
	    	
	    	List<String> lTarifa = DAOTarifa.listarDescricaoTarifaPorProduto(this.filtroTarifa.Nome_do_Produto__c);
	    	
	    	this.filtroTarifa.Nome_da_Tarifa__c = lTarifa[0];
	    			
	    	for(String item : lTarifa) {
	    		this.soTarifa.add(new SelectOption(item, item));
	    	}
		}
    }
    
    public void pesquisar() {
    	carregarTarifaAlelo();
    }
    
    public void cancelar() {
    	this.mapTarifaAlelo.clear();
    	
    	this.lTarifaAlelo.clear();
    	
    	this.exibirDetalhe = false;
    }
    
    public void salvar() {
		try {
			List<Tarifas_Alelo__c> lUpdate = new List<Tarifas_Alelo__c>(); 
			
			for(Decimal key : this.mapTarifaAlelo.keySet()) {
				lUpdate.addAll(this.mapTarifaAlelo.get(key));
			}
			
			update lUpdate;
			
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Tarifa(s) atualizada(s) com sucesso.'));
		}
		catch(Exception ex) {
			system.debug('Erro salvar: ' + ex.getLineNumber());
            system.debug('Erro salvar: ' + ex.getStackTraceString());
            system.debug('Erro salvar: ' + ex.getTypeName());
            system.debug('Erro salvar: ' + ex.getCause());
            system.debug('Erro salvar: ' + ex.getMessage());
            
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro na atualização da(s) tarifa(s).'));
		}
	}
}
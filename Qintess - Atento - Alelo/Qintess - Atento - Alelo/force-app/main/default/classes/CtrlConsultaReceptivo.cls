public with sharing class CtrlConsultaReceptivo {
    
    public String phoneNumber {get; set;}
    public String campaignId {get; set;}
    
    public String cnpjCpf {get; set;}
    
    public List<Lead> lLead {get; set;}
    public List<Account> lCliente {get; set;}
    public List<Opportunity> lOportunidade {get; set;}
    
    public Lead lead {get; set;}
    
    public Boolean exibirConsulta {get; set;}
    public Boolean exibirCliente {get; set;}
    
    public Boolean possuiRegistro {get; set;}
    public Boolean gerarLead {get; set;}
    
    public CtrlConsultaReceptivo() {
    	init();
    } 
    
    private void init() {
    	
    	this.phoneNumber = Apexpages.currentPage().getParameters().get('phoneNumber');
    	this.campaignId = Apexpages.currentPage().getParameters().get('campaignId');
    	
    	this.exibirConsulta = true;
    	this.exibirCliente = false;
    	this.possuiRegistro = false;
    	this.gerarLead = false;
    	
    	this.lLead = new List<Lead>();
    	this.lCliente = new List<Account>();
    	this.lOportunidade = new List<Opportunity>();
    } 
    
    public void consultar() {
    	
    	this.exibirCliente = false;
    	
    	List<List<sObject>> lSObject = [FIND :this.cnpjCpf IN ALL FIELDS RETURNING Lead(Id, Name, CNPJ__c, Nome_da_Campanha__c, Status, IsConverted WHERE IsConverted = false), Account(Id, Name, CPF_CNPJ__c)];
		
		this.lLead = lSObject[0]; 
		
		this.lCliente = lSObject[1];
		
		if(this.lLead.isEmpty() && this.lCliente.isEmpty()) {
			configurarLead();
			
    		this.gerarLead = true;
		}
		else {
				
			if(!this.lCliente.isEmpty()) {	
				this.lOportunidade = DAOOpportunity.getOpportunityForAccount(lCliente[0].Id);
				
				this.exibirCliente = this.lOportunidade.isEmpty();
			} 
			
			this.possuiRegistro = true;
		}
    } 
    
    public void novoLead() {
    	this.exibirConsulta = false;
    	this.gerarLead = true;
    	this.possuiRegistro = false;
    	
    	configurarLead();
    }
    
    public void gravarLead() {
    	try {
    		insert this.lead;
    	}
    	catch(DmlException e) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getDmlMessage(0)));
		}
    	catch(Exception e) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Erro na atualização.'));
		}
    }
    
    public void cancelar() { 
    	this.exibirConsulta = true;
    	this.possuiRegistro = true;
    	this.gerarLead = false;
    }
    
    private void configurarLead() {
    	
    	this.lead = new Lead();
    	
    	this.lead.RecordTypeId = DAORecordType.obterPorDeveloperName('Receptivo').Id;
    	this.lead.CNPJ__c = this.cnpjCpf;
    	this.lead.Phone = this.phoneNumber;
    	this.lead.Status = 'NOVO (006)';
    	
    	Campanhas_receptivo__c campanhasReceptivo = Campanhas_receptivo__c.getInstance(this.campaignId);
    	
    	if(campanhasReceptivo != null) {
    		this.lead.Nome_da_Campanha__c = 'Receptivo – ' + campanhasReceptivo.Descricao__c;
    	}
    	else {
    		this.lead.Nome_da_Campanha__c = 'Receptivo';
    	}
    }
}
public with sharing class CtrlFichaPropostaPDF {
    public Id idOpportunity { get; set; }
	public Opportunity objOportunidade { get; set; }
	public Account objAccountParent { get; set; }
	public Account objAccount { get; set; }
	public Contact objContact1 { get; set; }
	public Contact objContact2 { get; set; }
	public Contact objContact3 { get; set; }
	public Contact objContact4 { get; set; }
	public String cnpjContratante { get; set; }
	public String cpfResponsavelLegal1 { get; set; }
	public String cpfResponsavelLegal2 { get; set; }
	public String cpfContact1 { get; set; }
	public String cpfContact2 { get; set; }
	public String cpfContact3 { get; set; }
	public String cpfContact4 { get; set; }
	public List<Produtos_Alelo__c> listaOpportunityProduct {get; set; }
	
    public String AtividadePrincipalCompleto { get; set; }
    public Integer FormaConstituicao { get; set; }
    
    public CtrlFichaPropostaPDF() {
		init();
	}
	
	public void init() {
		this.idOpportunity = ApexPages.currentPage().getParameters().get('id');
		this.objOportunidade = DAOOpportunity.getOpportunityById(this.idOpportunity);
		this.loadAccount();
		this.loadContact();
		this.loadOpportunityProduct();
		this.AtividadePrincipalCompleto = '';
		this.cnpjContratante = Util.formatCPFCNPJ(this.objOportunidade.Account.CPF_CNPJ__c);
		
		if(this.objOportunidade.Responsavel_Legal__r != null)
			this.cpfResponsavelLegal1 = Util.formatCPFCNPJ(this.objOportunidade.Responsavel_Legal__r.CPF__c);
		if(this.objOportunidade.Responsavel_Legal_2__r != null)
			this.cpfResponsavelLegal2 = Util.formatCPFCNPJ(this.objOportunidade.Responsavel_Legal_2__r.CPF__c);

		if(objOportunidade != null) {
			if(objOportunidade.Account.Secao_Ramo_de_Atividade__c != null) {
				this.AtividadePrincipalCompleto += objOportunidade.Account.Secao_Ramo_de_Atividade__c;
			}
			
			if(objOportunidade.Account.Divisao_Ramo_de_Atividade__c != null) {
				this.AtividadePrincipalCompleto += ' - ' + objOportunidade.Account.Divisao_Ramo_de_Atividade__c;
			}
		}

		if(this.objAccountParent != null) {
			if(this.objAccountParent.Forma_de_Constituicao__c != null) {
				this.FormaConstituicao = Integer.valueOf(this.objAccountParent.Forma_de_Constituicao__c.substring(0, 2));
				System.debug(this.FormaConstituicao);
			}
		}
		
		system.debug('objOportunidade: ' + JSON.serialize(objOportunidade)); 
	}
	
	public void loadAccount(){
		if(this.objOportunidade.Account.Parent.Id != null){
			this.objAccountParent = DAOAccount.getAccountById(this.objOportunidade.Account.Parent.Id);
			this.objAccount = DAOAccount.getAccountById(this.objOportunidade.Account.Id);
		}else{
			this.objAccountParent = DAOAccount.getAccountById(this.objOportunidade.Account.Id);
			this.objAccount = new Account();
		}
	}
	
	public void loadContact(){
		this.objContact1 = new Contact();
		this.objContact2 = new Contact();
		this.objContact3 = new Contact();
		this.objContact4 = new Contact();
		
		if(this.objOportunidade.Contato_da_oportunidade__c != null){
			this.objContact1 = DAOContact.getContactById(this.objOportunidade.Contato_da_oportunidade__c);
			this.cpfContact1 = Util.formatCPFCNPJ(this.objContact1.CPF__c);
		}
		if(this.objOportunidade.Contato_da_oportunidade_2__c != null){
			this.objContact2 = DAOContact.getContactById(this.objOportunidade.Contato_da_oportunidade_2__c);
			this.cpfContact2 = Util.formatCPFCNPJ(this.objContact2.CPF__c);
		}
		if(this.objOportunidade.Contato_da_oportunidade_3__c != null){
			this.objContact3 = DAOContact.getContactById(this.objOportunidade.Contato_da_oportunidade_3__c);
			this.cpfContact3 = Util.formatCPFCNPJ(this.objContact3.CPF__c);
		}
		if(this.objOportunidade.Contato_da_oportunidade_4__c != null){
			this.objContact4 = DAOContact.getContactById(this.objOportunidade.Contato_da_oportunidade_4__c);
			this.cpfContact4 = Util.formatCPFCNPJ(this.objContact4.CPF__c);
		}
	}
	
	private void loadOpportunityProduct() {
		this.listaOpportunityProduct = DAOProdutosAlelo.getOpportunityProductByOpportunityId(this.idOpportunity);
	}

	public String getFormatCurrency() {
		Decimal value;
		if(objOportunidade != null && objOportunidade.Account != null && objOportunidade.Account.Faturamento__c != null) {
			value = objOportunidade.Account.Faturamento__c;
		}
		else {
			value = 0;
		}
		return String.valueOf(value.setScale(2)).replaceAll('\\.', ',').replaceAll('(\\d)(?=(\\d\\d\\d)+(?!\\d))',
		'$1.');

	}
}
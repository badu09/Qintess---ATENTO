public with sharing class CtrlModeloPropostaPDF {
	private ApexPages.StandardController controllerPage;
	public Id idOpportunity { get; set; }
	public Id idOwner { get; set; }
	public Opportunity objOpportunity { get; set; }
	public String contatoOppName { get; set; }
	public List<Produtos_Alelo__c> listaOpportunityProduct { get; set; }
	public Produtos_Alelo__c aleloRefeicao { get; set; }
	public Produtos_Alelo__c aleloAlimentacao { get; set; }
	public Produtos_Alelo__c aleloNatalAlimentacao { get; set; }
	public Produtos_Alelo__c aleloValeTransporte { get; set; }
	public Produtos_Alelo__c aleloFlexCar { get; set; }
	public Produtos_Alelo__c aleloCultura { get; set; }
	public Produtos_Alelo__c aleloMobilidade { get; set; }
	public Produtos_Alelo__c aleloAuto { get; set; }
	public String dataExtenso { get; set; }
	public Boolean cartaoCredito { get; set; }
	public Boolean temAuto {get; set;}

	public CtrlModeloPropostaPDF() {
		try
		{
			this.idOpportunity = ApexPages.currentPage().getParameters().get('id');
			system.debug('this.idOpportunity: ' + this.idOpportunity);
			this.idOwner = UserInfo.getUserId();
			init();
		} catch(Exception ex) {
			system.debug('Exception: ' + ex.getStackTraceString());
		}
	}

	public CtrlModeloPropostaPDF(ApexPages.StandardController controller) {
		try
		{
			this.controllerPage = controller;
			this.idOpportunity = ApexPages.currentPage().getParameters().get('id');
			system.debug('this.idOpportunity: ' + this.idOpportunity);
			this.idOwner = UserInfo.getUserId();
			init();
		} catch(Exception ex) {
			system.debug('Exception: ' + ex.getStackTraceString());
		}
	}

	public CtrlModeloPropostaPDF(Id opportunityId) {
		this.idOpportunity = opportunityId;
		this.loadOpportunityProduct();
	}

	private void init() {
		this.loadDate();
		this.loadOpportunity();
		this.loadOpportunityProduct();
		this.getContatoNameOpp(objOpportunity.Contato_da_oportunidade__r.Name);
	}

	private void loadDate() {
		this.dataExtenso = Date.today().day() + ' de ' + Util.getNameMonth(Date.today().month()) + ' de ' + Date.today().year();
	}

	private void loadOpportunity() {
		this.objOpportunity = DAOOpportunity.getOpportunityById(this.idOpportunity);
	}

	private void loadOpportunityProduct() {
		this.listaOpportunityProduct = DAOProdutosAlelo.getOpportunityProductByOpportunityId(this.idOpportunity);

		for(Produtos_Alelo__c item : this.listaOpportunityProduct) {
			if(item.Name == 'Alelo Refeição')
				this.aleloRefeicao = item;
			if(item.Name == 'Alelo Alimentação')
				this.aleloAlimentacao = item;
			if(item.Name == 'Alelo Natal Alimentação')
				this.aleloNatalAlimentacao = item;
			if(item.Name == 'Alelo Vale-Transporte')
				this.aleloValeTransporte = item;
			if(item.Name == 'Flex Car Visa Vale')
			{
				this.aleloFlexCar = item;
				temAuto = true;
			}
			if(item.Name == 'Alelo Cultura')
				this.aleloCultura = item;
			if(item.Name == 'Alelo Mobilidade')
				this.aleloMobilidade = item;
			if(item.Name == 'AUTO')
				temAuto = true;
			if(item.Name == 'ALELO AUTO')
				this.aleloAuto = item;

			System.debug('Nome: ' + item.Name);

			if(item != null && item.FormaPagamento__c != null && item.FormaPagamento__c.containsIgnoreCase('CARTAO CREDITO'))
			{
				cartaoCredito = true;
			}
			else
			{
				cartaoCredito = false;
			}
		}

		system.debug('this.aleloRefeicao: ' + this.aleloRefeicao);
	}

	private void getContatoNameOpp(String contatoName){
		if(contatoName != null){
			contatoOppName = contatoName + ',';
		} else {
			contatoOppName = '';
		}

	}
	/*
	private void loadOpportunityProduct(Id opportunityId) {
	  //this.listaOpportunityProduct = DAOProdutosAlelo.getOpportunityProductByOpportunityId(this.idOpportunity);
	  this.aleloRefeicao = DAOProdutosAlelo.getOpportunityProductByOpportunityIdNameProduct(this.idOpportunity, 'Alelo Refeição');
	  this.aleloAlimentacao = DAOProdutosAlelo.getOpportunityProductByOpportunityIdNameProduct(this.idOpportunity, 'Alelo Alimentação');
	  this.aleloNatalAlimentacao = DAOProdutosAlelo.getOpportunityProductByOpportunityIdNameProduct(this.idOpportunity, 'Alelo Natal Alimentação');
	  this.aleloValeTransporte = DAOProdutosAlelo.getOpportunityProductByOpportunityIdNameProduct(this.idOpportunity, 'Alelo Vale-Transporte');
	  this.aleloFlexCar = DAOProdutosAlelo.getOpportunityProductByOpportunityIdNameProduct(this.idOpportunity, 'Alelo Flex Car');
	  this.aleloCultura = DAOProdutosAlelo.getOpportunityProductByOpportunityIdNameProduct(this.idOpportunity, 'Alelo Cultura');
	}*/
}
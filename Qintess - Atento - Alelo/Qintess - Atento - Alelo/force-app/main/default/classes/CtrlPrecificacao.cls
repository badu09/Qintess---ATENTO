global with sharing class CtrlPrecificacao {
	public Boolean EntregaCentralizada { get; set; }
	public Boolean FaturamentoCentralizado { get; set; }
	public Boolean SolicitacaoReemissao { get; set; }
	public Boolean prepax { get; set; }
	public String ValorMedioIndividualStr { get; set; }
	public Decimal ValorMedioIndividual { get{System.debug('ValorMedioIndividualStr: ' + ValorMedioIndividualStr); return ValorMedioIndividualStr != null ? Decimal.valueOf(ValorMedioIndividualStr.replace('.', '').replace(',', '.')) : 0;} set; }
	public Integer Quantidade { get; set; }
	public String NomeEmpresa { get; set; }
	public Boolean MostraDetalhes { get; set; }
	public String ProdutoSelecionado { get; set; }
	public List<Tarifas_Alelo__c> TarifasObj { get; set; }
	public List<TOTarifaPrecificacao> Tarifas { get; set; }
	public List<TOItem> Carrinho { get; set; }
	public Map<Id, Dominio__c> Produtos { get; set; }
	public Map<Decimal, Dominio__c> mapFeeCode { get; set; }
	public TOItem ItemSelecionado { get; set; }
	public Opportunity Oportunidade { get; set; }
	public Decimal ValorTarifaSomado { get; set; }
	public Produtos_Alelo__c produtosAlelo { get; set; }
	public Boolean simulacao { get; set; }
	public Boolean simulacaoNivelAlcada { get; set; }
	public Map<Decimal, List<Nivel_de_Alcada__c>> mapNivelAlcada { get; set; }
	public Boolean callTest { get; set; }
	public Boolean isCarrinho { get; set; }
	public Boolean desabilita { get; set; }
	public Boolean validarNivelAlcada { get; set; }
	public String urlOrg { get; set; }
	public Map<Decimal, Tarifas_Alelo__c> mapTarifaAlelo { get; set; }
	public Boolean manutencaoMensalZerado { get; set; }
	public Boolean disponibilizacaoBeneficioZerado { get; set; }
	public Boolean temManutencaoMensal { get; set; }
	public Boolean temDisponibilizacaoBeneficio { get; set; }
	public Boolean temAuto;
	public Boolean temMobilidade;
	public String IdOportunidade;
	public Integer indexTarifa {get; set;}

	public CtrlPrecificacao() {
		this.prepax = false;
		this.produtosAlelo =  new Produtos_Alelo__c();
		IdOportunidade = Apexpages.currentPage().getParameters().get('Id');
		this.Oportunidade = DAOOpportunity.getOpportunityById(IdOportunidade);
		this.Produtos = new Map<Id, Dominio__c>(DAOTabelaDominio.getListProductCode('ProductCode'));
		this.mapFeeCode =  DAOTabelaDominio.getMapFeeCode();
		this.EntregaCentralizada = false;
		this.FaturamentoCentralizado = false;
		this.SolicitacaoReemissao = false;
		this.ValorMedioIndividualStr = '0';
		this.Quantidade = null;
		this.NomeEmpresa = '';
		this.MostraDetalhes = false;
		this.Tarifas = new List<TOTarifaPrecificacao>();
		this.Carrinho = new List<TOItem>();
		this.simulacao = false;
		this.simulacaoNivelAlcada = false;
		this.callTest = false;
		this.validarNivelAlcada = true;
		this.manutencaoMensalZerado = false;
		this.disponibilizacaoBeneficioZerado = false;
		this.temManutencaoMensal = false;
		this.temDisponibilizacaoBeneficio = false;
		this.urlOrg = system.URL.getSalesforceBaseUrl().toExternalForm();
		validarAutoMobilidade();

	}
 
	public void selecionarProduto() {
		
		if(this.ProdutoSelecionado == null || this.ProdutoSelecionado == '') {
			this.ProdutoSelecionado = Apexpages.currentPage().getParameters().get('idProduto');
		}	
		Dominio__c dominioProduto = produtos.get(produtoSelecionado);
		System.debug('this.ProdutoSelecionado: ' + this.ProdutoSelecionado);
		if(dominioProduto.Codigo_Identificador__c == 300 || dominioProduto.Codigo_Identificador__c == 301 
			|| dominioProduto.Codigo_Identificador__c == 302)
		{
			if(temAuto || temMobilidade)
			{
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Não é permitido selecionar os produtos Flex Car Visa Vale, AUTO e Mobilidade na mesma oportunidade.'));
				return;
			}
		}		
		
		this.MostraDetalhes = true;
		this.Tarifas = new List<TOTarifaPrecificacao>();
		this.TarifasObj = new List<Tarifas_Alelo__c>();
		this.ItemSelecionado = new TOItem(this.Produtos.get(this.ProdutoSelecionado));
		this.manutencaoMensalZerado = false;
		this.disponibilizacaoBeneficioZerado = false;
		this.temManutencaoMensal = false;
		this.temDisponibilizacaoBeneficio = false;
		this.prepax = false;
		
		if((this.ItemSelecionado.Produto.Codigo_Identificador__c >= 700 && this.ItemSelecionado.Produto.Codigo_Identificador__c <= 710))
			this.validarNivelAlcada = false;
	}

	public void simular() {
		Set<String> sApoio = new Set<String>();
		Dominio__c produto = this.Produtos.get(this.ProdutoSelecionado);
		this.ValorTarifaSomado = 0;
		this.simulacao =  false;
		this.mapTarifaAlelo =  new map<Decimal, Tarifas_Alelo__c>();
		this.manutencaoMensalZerado = false;
		this.disponibilizacaoBeneficioZerado = false;
		this.temManutencaoMensal = false;
		this.temDisponibilizacaoBeneficio = false;
		this.prepax = false;
		
		system.debug('produtosAlelo.Banco__c: ' + produtosAlelo.Banco__c);
		
		if(this.NomeEmpresa == null || this.NomeEmpresa == '') {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Preencha o campo "Nome da Empresa para Gravação do Cartão" para continuar.'));
			return;
		}
		
		if((produtosAlelo.Banco__c != null) && (produtosAlelo.Agencia_Digito__c == null || produtosAlelo.Agencia_Digito__c == '')) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Preencha o campo "Agência" para continuar.'));
			return;
		}
		
		if((produtosAlelo.Banco__c != null) && (produtosAlelo.Digito__c == null || produtosAlelo.Digito__c == '')) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Preencha o campo "Digíto" para continuar.'));
			return;
		}
		
		this.simulacao =  true;
		
		if(this.Tarifas.isEmpty()){
			this.Tarifas = new List<TOTarifaPrecificacao>();
			this.TarifasObj = BOTarifa.encontrarTarifa(ValorMedioIndividual, Quantidade, String.valueOf(produto.Codigo_Identificador__c), produtosAlelo.FormaPagamento__c);
			Integer pkAlelo = null;
			
			system.debug('TarifasObj: ' + this.TarifasObj);
			
			for(Tarifas_Alelo__c item : this.TarifasObj) {
				if(sApoio.size() <= 0 || !sApoio.contains(item.Nome_da_Tarifa__c)) {
					sApoio.add(item.Nome_da_Tarifa__c);
					Dominio__c dominio = mapFeeCode.get(item.Codigo_da_Tarifa__c);
					pkAlelo = 0;
					if(item.Codigo_da_Tarifa__c == 2) {
						this.temManutencaoMensal = true;
						if(item.Valor_Unitario__c <= 0) {
							this.manutencaoMensalZerado = true;
						}
					}
					else if(item.Codigo_da_Tarifa__c == 4) {
						this.temDisponibilizacaoBeneficio = true;
						if(item.Valor_Unitario__c <= 0) {
							this.disponibilizacaoBeneficioZerado = true;
						}
					}
					
					this.prepax = item.Percentual__c;
					
					if(!item.Percentual__c)
						this.validarNivelAlcada = true;
					
					if(dominio != null)
						pkAlelo = Integer.valueOF(dominio.PK_Atento__c);
					
					this.Tarifas.add(new TOTarifaPrecificacao(item, pkAlelo));
					this.mapTarifaAlelo.put(item.Codigo_da_Tarifa__c, item);
				}
			}
			this.Tarifas.sort();
			
			if(this.Tarifas.isEmpty())
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Não existe tarifa para esse produto, nessa configuração.'));
		}

	}
	
	public void simularNivelAlcada() {
		Dominio__c produto = this.Produtos.get(this.ProdutoSelecionado);
		this.ValorTarifaSomado = 0;
		this.simulacaoNivelAlcada = true;
		Decimal valorTarifa = 0;
		Boolean nivelValido = true;
		Tarifas_Alelo__c objTarifaAlelo = null;

		if(!this.Tarifas.isEmpty() && this.validar(this.Tarifas)){
			List<Nivel_de_Alcada__c> listaNivelAlcada = DAONivelAlcada.getByValormedioQtdProduto(ValorMedioIndividual, Quantidade, String.valueOf(produto.Codigo_Identificador__c), produtosAlelo.FormaPagamento__c);

			for(TOTarifaPrecificacao item : this.Tarifas){
				valorTarifa = Util.decimalvalueOf(item.ValorTarifa);
				item.nivel = '1';
				nivelValido = false;
				
//				system.debug('item.Tarifa.Codigo_da_Tarifa__c: ' + item.Tarifa.Codigo_da_Tarifa__c);
//				system.debug('valorTarifa: ' + valorTarifa);
//				system.debug('listaNivelAlcada: ' + JSON.serialize(listaNivelAlcada));
				
				objTarifaAlelo = this.mapTarifaAlelo.get(item.Tarifa.Codigo_da_Tarifa__c);
				//verificar se houve alteração no valor
				if(objTarifaAlelo != null && objTarifaAlelo.Valor_Unitario__c != valorTarifa){

					for(Nivel_de_Alcada__c retorno : listaNivelAlcada){
						if(retorno.Codigo_da_Tarifa__c == item.Tarifa.Codigo_da_Tarifa__c){
							if(valorTarifa >= retorno.Valor_Unitario__c){
								// system.debug('retorno.Valor_Unitario__c: ' + retorno.Valor_Unitario__c);
								// system.debug('retorno.Nivel_de_Alcada__c: ' + retorno.Nivel_de_Alcada__c);
								nivelValido = true;
								item.nivel = retorno.Nivel_de_Alcada__c;
							}else{
								break;
							}
						}else if(retorno.Codigo_da_Tarifa__c > item.Tarifa.Codigo_da_Tarifa__c){
							break;
						}
					}

					if(!nivelValido){
						item.nivel = 'Valor não permitido.';
						this.simulacaoNivelAlcada = false;
					}
				}else{
					item.nivel = '1';
				}
				
				if((item.Tarifa.Codigo_da_Tarifa__c == 2 || item.Tarifa.Codigo_da_Tarifa__c == 4) && valorTarifa == 0) {
					item.nivel = '1';
					this.simulacaoNivelAlcada = true;
				}
				
				if(item.nivel == 'Valor não permitido.')
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Verifique a coluna "Nova Tarifa", pois existe(m) valor(es) não permitido(s).'));
			}
			
			if(this.simulacaoNivelAlcada){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Simulação de nível de alçada realizada com sucesso.'));
			}
		}

	}




	public void removerTarifa(){
		this.Tarifas.remove(this.indexTarifa - 1);
	}

	public void adicionarCarrinho() {
		this.isCarrinho = false;

		System.debug('Tarifas: ' +  this.Tarifas);
		
		if(this.validar(this.Tarifas)){

			Dominio__c dominioProduto = ItemSelecionado.Produto;
			if(dominioProduto.Codigo_Identificador__c == 300 || dominioProduto.Codigo_Identificador__c == 301
				|| dominioProduto.Codigo_Identificador__c == 302)
			{
				temAuto = true;
				temMobilidade = true;
			}

			this.salvar();
			this.Carrinho.add(this.ItemSelecionado);
			this.limpar();
			
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM, 'Produto adicionado ao carrinho com sucesso.'));
			
			this.isCarrinho = true;
		}
	}
	
	private Boolean validar(List<TOTarifaPrecificacao> tarifas){
		Decimal valorManutencaoMensal = 0;
		Decimal valorDisponibilizacaoBeneficio = 0;
		Decimal codigoProduto = this.ItemSelecionado.Produto.Codigo_Identificador__c;
		for(TOTarifaPrecificacao tarTO : tarifas) {
			
			if(tarTO.Tarifa.Codigo_da_Tarifa__c == 2.0){
				if(!this.callTest)
					valorManutencaoMensal = Util.decimalvalueOf(tarTO.ValorTarifaDec);
			}
			if(tarTO.Tarifa.Codigo_da_Tarifa__c == 4.0)
				valorDisponibilizacaoBeneficio = Util.decimalvalueOf(tarTO.ValorTarifaDec);
		}
		System.debug('codigoProduto: ' + codigoProduto);
		System.debug('manutencaoMensalZerado: ' + manutencaoMensalZerado);
		System.debug('disponibilizacaoBeneficioZerado: ' + disponibilizacaoBeneficioZerado);
		if((codigoProduto == 100 || codigoProduto == 200 || codigoProduto == 202 || codigoProduto == 400) 
			&& (!manutencaoMensalZerado && !disponibilizacaoBeneficioZerado)
			&& (temManutencaoMensal && temDisponibilizacaoBeneficio)) {
			if((valorManutencaoMensal == 0 && valorDisponibilizacaoBeneficio == 0) && this.validarNivelAlcada){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Favor informar um dos campos, Manutenção Mensal ou Disponibilização do Benefício.'));
				this.simulacaoNivelAlcada = false;
				return false;
			}
			
			if((valorManutencaoMensal > 0 && valorDisponibilizacaoBeneficio > 0) && this.validarNivelAlcada){
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, 'Favor informar somente um dos campos, Manutenção Mensal ou Disponibilização do Benefício.'));
				this.simulacaoNivelAlcada = false;
				return false;
			}
		}

		Map<Integer, String> mapTarifas = new Map<Integer, String>();
		for (TOTarifaPrecificacao tarifa : this.Tarifas) {
			mapTarifas.put(Integer.valueOf(tarifa.Tarifa.Codigo_da_Tarifa__c), tarifa.Tarifa.Nome_da_Tarifa__c);
		}


		if (mapTarifas.containsKey(2) && mapTarifas.containsKey(4)){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Para inserir o produto ao carrinho é necessário excluir a taxa de manutenção OU a taxa de disponibilização') );
			return false;
		}
		
		return true;
	}
	
	private void salvar(){
		/*for(TOTarifaPrecificacao tarItem : this.Tarifas) {
			if(tarItem.Tarifa.Valor_Unitario__c > 0) {
				this.ValorTarifaSomado += Util.decimalValueOf(tarItem.ValorTarifaDec);
			}
			else {
				this.ValorTarifaSomado += Util.decimalValueOf(tarItem.Tarifa.Valor_Unitario__c);
			}
		}

		this.ItemSelecionado.Quantidade = Quantidade;
		this.ItemSelecionado.EntregaCentralizada = EntregaCentralizada;
		this.ItemSelecionado.FaturamentoCentralizado = FaturamentoCentralizado;
		this.ItemSelecionado.SolicitacaoReemissao = SolicitacaoReemissao;
		this.ItemSelecionado.Tarifas = this.Tarifas;
		this.ItemSelecionado.ValorTarifaTotal = ValorTarifaSomado;
		this.ItemSelecionado.ValorUnitario = ValorMedioIndividual;

		Produtos_Alelo__c produtoObj = new Produtos_Alelo__c();
		if(this.ItemSelecionado.ProdutoObj != null) {
			produtoObj = this.ItemSelecionado.ProdutoObj;
		}
		if(produtoObj.Id == null)
			produtoObj.Oportunidade__c = this.oportunidade.Id;
		
		produtoObj.Banco__c = this.produtosAlelo.Banco__c;
		produtoObj.Agencia_Digito__c = this.produtosAlelo.Agencia_Digito__c;
		produtoObj.Digito__c = this.produtosAlelo.Digito__c;
		produtoObj.Codigo_CAB__c = this.produtosAlelo.Codigo_CAB__c;
		if(this.ItemSelecionado.ValorUnitario != null) {
			produtoObj.Valor_Unitario__c = this.ItemSelecionado.ValorUnitario;
		} else {
			produtoObj.Valor_Unitario__c = 0;
		}
		produtoObj.Codigo_de_Produtos__c = String.valueOf(this.ItemSelecionado.Produto.Codigo_Identificador__c);
		produtoObj.Nome_do_Produto__c = this.ItemSelecionado.Produto.Descricao__c;
		produtoObj.Name = this.ItemSelecionado.Produto.Descricao__c;
		produtoObj.Disponibilizacao_mensal__c = this.ValorMedioIndividual;
		produtoObj.Quantidade_de_Cartoes__c = this.ItemSelecionado.Quantidade;
		produtoObj.Valor_Total__c = produtoObj.Valor_Unitario__c * produtoObj.Quantidade_de_Cartoes__c;
		produtoObj.Nome_Empresa_Gravacao_Cartao__c = this.NomeEmpresa;
		produtoObj.Entrega_Centralizada__c = this.ItemSelecionado.EntregaCentralizada;
		produtoObj.Faturamento_Centralizado__c = this.ItemSelecionado.FaturamentoCentralizado;
		produtoObj.Permitir_Reemissao_Usuario__c = this.ItemSelecionado.SolicitacaoReemissao;*/
		
		Produtos_Alelo__c produtoObj = carregarProdutoAlelo();
		
		upsert produtoObj;
		
		system.debug('produtoObj: ' + produtoObj);

		DAOTarifaCarrinho.limparTarifas(produtoObj.Id);

		/*for(TOTarifaPrecificacao tarTO : this.ItemSelecionado.Tarifas) {
			
			Tarifas_Carrinho__c tarObj = new Tarifas_Carrinho__c();
			tarObj.Produtos_Alelo__c = produtoObj.Id;
			tarObj.Codigo_da_Tarifa__c = tarTO.Tarifa.Codigo_da_Tarifa__c;
			tarObj.Nome_da_Tarifa__c = tarTO.Tarifa.Nome_da_Tarifa__c;
			tarObj.Name = tarTO.Tarifa.Nome_da_Tarifa__c;
			tarObj.Codigo_de_Produtos__c = tarTO.Tarifa.Codigo_de_Produtos__c;
			tarObj.Nome_do_Produto__c = tarTO.Tarifa.Nome_do_Produto__c;
			tarObj.Quantidade_de_Funcionarios_no_Contrato__c = tarTO.Tarifa.Quantidade_de_Funcionarios_no_Contrato__c;
			tarObj.Qtd_Max_Beneficios__c = tarTO.Tarifa.Qtd_Max_Beneficios__c;
			tarObj.Qtd_Min_Beneficios__c = tarTO.Tarifa.Qtd_Min__c;
			tarObj.Valor_Minimo__c = tarTO.Tarifa.Valor_Minimo__c;
			tarObj.Valor_Maximo__c = tarTO.Tarifa.Valor_Maximo__c;
			if(!tarTO.Tarifa.Percentual__c) {
				tarObj.Valor_Tarifa_Padrao__c = tarTO.Tarifa.Valor_Unitario__c;
				tarObj.Valor_Unitario__c = Util.decimalValueOf(tarTO.ValorTarifaDec);
			}
			else {
				tarObj.Percentual__c = tarTO.Tarifa.Percentual__c;
				tarObj.Valor_Tarifa_Padrao_Prepax__c = tarTO.Tarifa.Valor_Unitario_Prepax__c;
				tarObj.Valor_Unitario_Prepax__c = Util.decimalValueOf(tarTO.ValorTarifaDec);				
			}
			tarObj.Nivel_de_Alcada__c = Integer.valueOf(tarTO.nivel);
			
			insert tarObj;
			
			system.debug('tarObj: ' + tarObj);
			system.debug('tarTO: ' + tarTO);
		}*/
		
		List<Tarifas_Carrinho__c> lTarifaCarrinho = carregarTarifaCarrinho(produtoObj.Id);
		
		insert lTarifaCarrinho;
		
		this.ItemSelecionado.ProdutoObj = produtoObj;
	}
	
	public Produtos_Alelo__c carregarProdutoAlelo() {
		for(TOTarifaPrecificacao tarItem : this.Tarifas) {
			if(tarItem.Tarifa.Valor_Unitario__c > 0) {
				this.ValorTarifaSomado += Util.decimalValueOf(tarItem.ValorTarifaDec);
			}
			else {
				this.ValorTarifaSomado += Util.decimalValueOf(tarItem.Tarifa.Valor_Unitario__c);
			}
		}

		this.ItemSelecionado.Quantidade = Quantidade;
		this.ItemSelecionado.EntregaCentralizada = EntregaCentralizada;
		this.ItemSelecionado.FaturamentoCentralizado = FaturamentoCentralizado;
		this.ItemSelecionado.SolicitacaoReemissao = SolicitacaoReemissao;
		this.ItemSelecionado.Tarifas = this.Tarifas;
		this.ItemSelecionado.ValorTarifaTotal = ValorTarifaSomado;
		this.ItemSelecionado.ValorUnitario = ValorMedioIndividual;

		Produtos_Alelo__c produtoObj = new Produtos_Alelo__c();
		if(this.ItemSelecionado.ProdutoObj != null) {
			produtoObj = this.ItemSelecionado.ProdutoObj;
		}
		if(produtoObj.Id == null)
			produtoObj.Oportunidade__c = this.oportunidade.Id;
		
		produtoObj.Banco__c = this.produtosAlelo.Banco__c;
		produtoObj.Agencia_Digito__c = this.produtosAlelo.Agencia_Digito__c;
		produtoObj.Digito__c = this.produtosAlelo.Digito__c;
		produtoObj.Codigo_CAB__c = this.produtosAlelo.Codigo_CAB__c;
		if(this.ItemSelecionado.ValorUnitario != null) {
			produtoObj.Valor_Unitario__c = this.ItemSelecionado.ValorUnitario;
		} else {
			produtoObj.Valor_Unitario__c = 0;
		}
		produtoObj.Codigo_de_Produtos__c = String.valueOf(this.ItemSelecionado.Produto.Codigo_Identificador__c);
		produtoObj.Nome_do_Produto__c = this.ItemSelecionado.Produto.Descricao__c;
		produtoObj.Name = this.ItemSelecionado.Produto.Descricao__c;
		produtoObj.Disponibilizacao_mensal__c = this.ValorMedioIndividual;
		produtoObj.Quantidade_de_Cartoes__c = this.ItemSelecionado.Quantidade;
		produtoObj.Valor_Total__c = produtoObj.Valor_Unitario__c * produtoObj.Quantidade_de_Cartoes__c;
		produtoObj.Nome_Empresa_Gravacao_Cartao__c = this.NomeEmpresa;
		produtoObj.Entrega_Centralizada__c = this.ItemSelecionado.EntregaCentralizada;
		produtoObj.Faturamento_Centralizado__c = this.ItemSelecionado.FaturamentoCentralizado;
		produtoObj.Permitir_Reemissao_Usuario__c = this.ItemSelecionado.SolicitacaoReemissao;
		produtoObj.FormaPagamento__c = this.produtosAlelo.FormaPagamento__c;
		
		system.debug('produtoObj: ' + json.serialize(produtoObj));
		
		return produtoObj;
	}
	
	public List<Tarifas_Carrinho__c> carregarTarifaCarrinho(Id idProdutoAlelo) {
		
		List<Tarifas_Carrinho__c> lTarifaCarrinho = new List<Tarifas_Carrinho__c>();
		
		for(TOTarifaPrecificacao tarTO : this.ItemSelecionado.Tarifas) {
			
			Tarifas_Carrinho__c tarObj = new Tarifas_Carrinho__c();
			
			tarObj.Produtos_Alelo__c = idProdutoAlelo;
			tarObj.Codigo_da_Tarifa__c = tarTO.Tarifa.Codigo_da_Tarifa__c;
			tarObj.Nome_da_Tarifa__c = tarTO.Tarifa.Nome_da_Tarifa__c;
			tarObj.Name = tarTO.Tarifa.Nome_da_Tarifa__c;
			tarObj.Codigo_de_Produtos__c = tarTO.Tarifa.Codigo_de_Produtos__c;
			tarObj.Nome_do_Produto__c = tarTO.Tarifa.Nome_do_Produto__c;
			tarObj.Quantidade_de_Funcionarios_no_Contrato__c = tarTO.Tarifa.Quantidade_de_Funcionarios_no_Contrato__c;
			tarObj.Qtd_Max_Beneficios__c = tarTO.Tarifa.Qtd_Max_Beneficios__c;
			tarObj.Qtd_Min_Beneficios__c = tarTO.Tarifa.Qtd_Min__c;
			tarObj.Valor_Minimo__c = tarTO.Tarifa.Valor_Minimo__c;
			tarObj.Valor_Maximo__c = tarTO.Tarifa.Valor_Maximo__c;
			
			if(!tarTO.Tarifa.Percentual__c) {
				tarObj.Valor_Tarifa_Padrao__c = tarTO.Tarifa.Valor_Unitario__c;
				tarObj.Valor_Unitario__c = Util.decimalValueOf(tarTO.ValorTarifaDec);
			}
			else {
				tarObj.Percentual__c = tarTO.Tarifa.Percentual__c;
				tarObj.Valor_Tarifa_Padrao_Prepax__c = tarTO.Tarifa.Valor_Unitario_Prepax__c;
				tarObj.Valor_Unitario_Prepax__c = Util.decimalValueOf(tarTO.ValorTarifaDec);				
			}
			
			tarObj.Nivel_de_Alcada__c = Integer.valueOf(tarTO.nivel);
			
			lTarifaCarrinho.add(tarObj);
			
			system.debug('tarObj: ' + tarObj);
			system.debug('tarTO: ' + tarTO);
		}
		
		return lTarifaCarrinho;
	}

	public void editar() {
		if(!this.Carrinho.isEmpty()){
			Integer rowIndex = Integer.valueOf(Apexpages.currentPage().getParameters().get('index'));
			this.ItemSelecionado = this.Carrinho[rowIndex];
			this.Tarifas = this.ItemSelecionado.Tarifas;
			this.MostraDetalhes = true;
			this.ValorMedioIndividualStr = String.valueOf(this.ItemSelecionado.ValorUnitario).replace('.', ',');
			this.Quantidade = this.ItemSelecionado.Quantidade;
			this.EntregaCentralizada = this.ItemSelecionado.EntregaCentralizada;
			this.FaturamentoCentralizado = this.ItemSelecionado.FaturamentoCentralizado;
			this.SolicitacaoReemissao = this.ItemSelecionado.SolicitacaoReemissao;
			this.ProdutoSelecionado = this.ItemSelecionado.Produto.Id;
			this.Carrinho.remove(rowIndex);
			this.simulacao = true;
		}
	}

	public void excluir() {
		Integer rowIndex = Integer.valueOf(Apexpages.currentPage().getParameters().get('index'));
		this.Carrinho.remove(rowIndex);
		validarAutoMobilidade();
	}

	public void limparSimulacao() {
		this.limpar();
	}
	
	private void limpar(){
		this.produtosAlelo =  new Produtos_Alelo__c();
		this.Tarifas = new List<TOTarifaPrecificacao>();
		this.MostraDetalhes = false;
		this.ItemSelecionado = null;
		this.EntregaCentralizada = false;
		this.FaturamentoCentralizado = false;
		this.SolicitacaoReemissao = false;
		this.ValorMedioIndividualStr = '0';
		this.Quantidade = null;
		this.NomeEmpresa = '';
		this.ProdutoSelecionado = null;
		this.simulacao = false;
		this.simulacaoNivelAlcada = false;
	}

	private void validarAutoMobilidade()
	{
		List<Produtos_Alelo__c> itens = [SELECT Id, Codigo_de_Produtos__c 
										   FROM Produtos_Alelo__c 
										  WHERE Oportunidade__c =: IdOportunidade 
										    AND Codigo_de_Produtos__c in ('300', '301', '302')];
		temAuto = false;
		temMobilidade = false;										    
		if(!itens.isEmpty())
		{
			for(Produtos_Alelo__c item : itens)
			{
				if(item.Codigo_de_Produtos__c == '301' || item.Codigo_de_Produtos__c == '300')
				{
					temAuto = true;
				}

				if(item.Codigo_de_Produtos__c == '302')
				{
					temMobilidade = true;
				}
			}
		}
		if(!Carrinho.isEmpty())
		{
			for(TOItem item : Carrinho)
			{
				Dominio__c dominioProduto = item.Produto;
				if(dominioProduto.Codigo_Identificador__c == 301 || dominioProduto.Codigo_Identificador__c == 302)
				{
					temAuto = true;
					temMobilidade = true;
				}
			}
		}	
	}

	public class TOItem {
		public Dominio__c Produto { get; set; }
		public Integer Quantidade { get; set; }
		public Decimal ValorUnitario { get; set; }
		public Decimal ValorTotal { get {return Decimal.valueOf(this.Quantidade) * this.ValorUnitario;} set; }
		public Boolean EntregaCentralizada { get; set; }
		public Boolean FaturamentoCentralizado { get; set; }
		public Boolean SolicitacaoReemissao { get; set; }
		public List<TOTarifaPrecificacao> Tarifas { get; set; }
		public Decimal ValorTarifaTotal { get; set; }
		public Produtos_Alelo__c ProdutoObj { get; set; }

		public TOItem(Dominio__c produto) {
			this.Produto = produto;
			this.Quantidade = 0;
			this.ValorUnitario = 0;
			this.EntregaCentralizada = false;
			this.FaturamentoCentralizado = false;
			this.SolicitacaoReemissao = false;
			this.ValorTarifaTotal = 0;
		}
	}

	global class TOTarifaPrecificacao implements Comparable{
		public Tarifas_Alelo__c Tarifa { get; set; }
		public Nivel_de_Alcada__c NivelAlcada { get; set; }
		public String ValorTarifa { get; set; }
		public Decimal ValorTarifaDec { get{return ValorTarifa != null ? Util.decimalvalueOf(ValorTarifa) : 0;} set; }
		public String nivel { get; set; }
		public Integer PKAlelo { get; set; }

		public TOTarifaPrecificacao(Tarifas_Alelo__c tarifa, Integer pkAlelo) {
			this.Tarifa = tarifa;
			if(this.Tarifa != null && (this.Tarifa.Valor_Unitario__c != null || this.Tarifa.Valor_Unitario_Prepax__c != null )) {
				if(this.Tarifa.Percentual__c)
					this.ValorTarifa = String.valueOf(this.Tarifa.Valor_Unitario_Prepax__c);
				else					
					this.ValorTarifa = String.valueOf(this.Tarifa.Valor_Unitario__c).replace('.', ',');
			}
			else {
				this.ValorTarifa = '0';
			}
			this.nivel = '1';
			this.PKAlelo = pkAlelo;
		}

		global Integer compareTo(Object compareTo) {
			TOTarifaPrecificacao compareToEmp = (TOTarifaPrecificacao)compareTo;
			if (PKAlelo == compareToEmp.PKAlelo) return 0;
			if (PKAlelo > compareToEmp.PKAlelo) return 1;
			return -1;
		}
	}

}
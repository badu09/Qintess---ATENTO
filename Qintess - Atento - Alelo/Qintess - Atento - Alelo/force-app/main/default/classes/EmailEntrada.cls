global class EmailEntrada implements Messaging.InboundEmailHandler
{
	private String descriptionErro { get;set; }

	private final Set<String> produtos = new Set<String>{'Refeição', 'Flex Car', 'Alimentação', 'Gestão de Vale-Transporte', 'Natal Alimentação', 'Vale-Cultura', 'Alelo Auto', 'Alelo-Premiacao', 'Alelo Incentivo', 'Alelo-Despesas', 'Alelo Pagamentos', 'Alelo Pronto'};

	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope) {
		system.debug('email: ' + JSON.serialize(email));
		Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
		String idRef = Util.getValueString(email.Subject, 'ref:', ']');
		String toAddress = email.toAddresses != null ? String.valueOf(email.toAddresses) : '';
		String ccAddresses = email.ccAddresses != null ? String.valueOf(email.ccAddresses) : '';
		EmailServicesAddress objEmailServicesAddress = DAOEmailServicesAddress.getByLocalPart('emailleadprocess');
		String emailLead = objEmailServicesAddress != null ? objEmailServicesAddress.EmailDomainName : '';
		objEmailServicesAddress = DAOEmailServicesAddress.getByLocalPart('emailopportunityprocess');
		String emailOpportunity = objEmailServicesAddress != null ? objEmailServicesAddress.EmailDomainName : '';

		system.debug('INICIO: EmailEntrada');

		if(idRef != null)
		{
			this.insertEmailMessage(email, envelope, null, idRef);
			this.insertTask(email, envelope, idRef);
		}
		else
		{
			this.insertLead(email, envelope, idRef);

		}

		result.success = true;
		return result;

	}

	private void insertLead(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope, String idRef){
		Lead objLead = null;
		String htmlBody = email.htmlBody;
		htmlBody = htmlBody.unescapeHtml4();
		htmlBody = htmlBody.trim()
				.replaceAll('\n', '')
				.replaceAll('^.*(<body.*?\\/body>).*$', '$1')
				.replaceAll('style=".*?"', '')
				.replaceAll('class=".*?"', '')
				.replaceAll('align=".*?"', '')
				.replaceAll('border=".*?"', '');
		String[] body = null;

		EmailTO emailObj = new EmailTO();

		if(email.subject == 'Prospect Middle' ||
           email.subject == 'Cadastro Prospect Empresa - Site Alelo' ||
           email.subject == 'ENC: Cadastro Prospect Empresa - Site Alelo'){
            
			system.debug('email.subject: ' + email.subject);

			objLead = new Lead();
			RecordType objRecordType = DAORecordType.obterPorDeveloperName('Site');
			System.debug('body: ' + htmlBody);

			emailObj.cnpj = getValueBody(htmlBody, 'CNPJ:');

			emailObj.razaoSocial = getValueBody(htmlBody, 'Razão Social:');
			emailObj.nomeFantasia = getValueBody(htmlBody, 'Nome Fantasia:');
			emailObj.numeroFuncionarios = getValueBody(htmlBody, 'Número de Funcionários:');
			emailObj.orgaoPublico = getValueBody(htmlBody, 'É Orgão público:');
			emailObj.municipio = getValueBody(htmlBody, 'Estado:');
			emailObj.estado = getValueBody(htmlBody, 'Município:');
			emailObj.bairro = getValueBody(htmlBody, 'Bairro:');
			emailObj.endereco = getValueBody(htmlBody, 'Endereço:');
			emailObj.numero = getValueBody(htmlBody, 'Número:');
			emailObj.complemento = getValueBody(htmlBody, 'Complemento:');
			emailObj.cep = getValueBody(htmlBody, 'CEP:');
			emailObj.nomeContato = getValueBody(htmlBody, 'Nome do Contato:');
			emailObj.ddd = getValueBody(htmlBody, 'DDD:');
			emailObj.telefone = getValueBody(htmlBody, 'Telefone:');
			emailObj.email = getValueBody(htmlBody, 'E-mail:');
			emailObj.receberInformacoes = getValueBody(htmlBody, 'Receber informações:');
			emailObj.dataCadastro = getValueBody(htmlBody, 'Dada do Cadastro:');
			emailObj.produtos = new List<ProdutoTo>();
			for(String p : produtos) {
				ProdutoTo prod = new ProdutoTo();
				prod.nome = p;
				prod.temInteresse = getValueBodyProduto(htmlBody, p, 'Tem Interesse:');
				prod.quantidade = getValueBodyProduto(htmlBody, p, 'Quantidade:');
				prod.valor = getValueBodyProduto(htmlBody, p, 'Valor:');
				emailObj.produtos.add(prod);
			}

			System.debug('emailObj: ' + JSON.serialize(emailObj));

			if(emailObj.cnpj != null && emailObj.cnpj != ''
					&& emailObj.nomeFantasia != null && emailObj.nomeFantasia != ''
					&& emailObj.ddd != null && emailObj.ddd !=''
					&& emailObj.telefone != null && emailObj.telefone != ''
					&& emailObj.nomeContato != null && emailObj.nomeContato != ''
					&& emailObj.email != null && emailObj.email != '') {


				objLead.CNPJ__c = emailObj.cnpj;
				objLead.Razao_Social__c = emailObj.razaoSocial;
				objLead.Nome_Fantasia__c = emailObj.nomeFantasia;
				objLead.Company = emailObj.nomeFantasia;
				objLead.NumberOfEmployees = convertToInteger(emailObj.numeroFuncionarios);
				objLead.EOrgaoPublico__c = emailObj.orgaoPublico;
				objLead.Bairro__c = emailObj.bairro;
				objLead.Street = emailObj.endereco;
				objLead.Complemento__c = emailObj.complemento;
				objLead.CEP__c = convertToDecimal(emailObj.cep);
				objLead.FirstName = emailOBj.nomeContato.contains(' ') ? emailObj.nomeContato.split(' ')[0] : emailObj.nomeContato;
				objLead.LastName = emailOBj.nomeContato.contains(' ') ? emailObj.nomeContato.split(' ')[0] : emailObj.nomeContato;
				objLead.DDD__c = convertToDecimal(emailObj.ddd);
				objLead.Phone = objLead.DDD__c + emailObj.telefone;
				objLead.Email = emailObj.email;
				objLead.Data_do_Cadastro__c = Util.formatDate(emailObj.dataCadastro);
				objLead.Status = 'NOVO (006)';
				objLead.Description = this.descriptionErro == null ? 'Wathever' : this.descriptionErro;
				objLead.RecordTypeId = objRecordType != null ? objRecordType.Id : null;

				for(ProdutoTo p : emailObj.produtos) {
					if(p.nome.equalsIgnoreCase('Refeição')) {
						objLead.InteresseRefeicao__c = p.temInteresse;
						objLead.QuantidadeRefeicao__c = convertToDecimal(p.quantidade);
						objLead.ValorRefeicao__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Flex Car')) {
						objLead.InteresseFlexCar__c = p.temInteresse;
						objLead.QuantidadeFlexCar__c = convertToDecimal(p.quantidade);
						objLead.ValorFlexCar__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Alimentação')) {
						objLead.InteresseAlimentacao__c = p.temInteresse;
						objLead.QuantidadeAlimentacao__c = convertToDecimal(p.quantidade);
						objLead.ValorAlimentacao__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Gestão de Vale-Transporte')) {
						objLead.InteresseGestaodeValeTransporte__c = p.temInteresse;
						objLead.QuantidadeValeTransporte__c = convertToDecimal(p.quantidade);
						objLead.ValorValeTransporte__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Natal Alimentação')) {
						objLead.InteresseNatalAlimentacao__c = p.temInteresse;
						objLead.QuantidadeNatalAlimentacao__c = convertToDecimal(p.quantidade);
						objLead.ValorNatalAlimentacao__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Vale-Cultura')) {
						objLead.InteresseValeCultura__c = p.temInteresse;
						objLead.QuantidadeValeCultura__c = convertToDecimal(p.quantidade);
						objLead.ValorValeCultura__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Alelo Auto')) {
						objLead.InteresseAleloAuto__c = p.temInteresse;
						objLead.QuantidadeAleloPronto__c = convertToDecimal(p.quantidade);
						objLead.ValorAleloAuto__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Alelo-Premiacao')) {
						objLead.InteresseAleloPremiacao__c = p.temInteresse;
						objLead.QuantidadeAleloPremiacao__c = convertToDecimal(p.quantidade);
						objLead.ValorAleloPremiacao__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Alelo Incentivo')) {
						objLead.InteresseAleloIncentivo__c = p.temInteresse;
						objLead.QuantidadeAleloIncentivo__c = convertToDecimal(p.quantidade);
						objLead.ValorAleloIncentivo__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Alelo-Despesas')) {
						objLead.InteresseAleloDespesas__c = p.temInteresse;
						objLead.QuantidadeAleloDespesas__c = convertToDecimal(p.quantidade);
						objLead.ValorAleloDespesas__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Alelo Pagamentos')) {
						objLead.InteresseAleloPagamentos__c = p.temInteresse;
						objLead.QuantidadeAleloPagamento__c = convertToDecimal(p.quantidade);
						objLead.ValorAleloPagamento__c = convertToDecimal(p.valor);
					}
					else if(p.nome.equalsIgnoreCase('Alelo Pronto')) {
						objLead.InteresseAleloPronto__c = p.temInteresse;
						objLead.QuantidadeAleloPronto__c = convertToDecimal(p.quantidade);
						objLead.ValorAleloPronto__c = convertToDecimal(p.valor);
					}
				}

				system.debug('objLead: ' + JSON.serialize(objLead));

				insert objLead;

				// this.insertEmailMessage(email, envelope, emailContato, objLead.Id);
				this.insertTask(email, envelope, objLead.Id);
			}
			else{
				System.debug('Campos obrigatorios Não Preenchidos');
			}
		}
	}

	public String getValueBody(String htmlBody, String campo){
		try {
//			if(Pattern.matches('(?:.)*' + campo + '(?:.)*?td.*?>(.*?)<(?:.)*', htmlBody)) {
			if(Pattern.matches('^.*' + campo + '(?:.)*?td.*?>(.*?)<.*', htmlBody)) {
				String retorno = htmlBody.replaceAll('^.*' + campo + '(?:.)*?td.*?>(.*?)<.*', '$1').replace('\u00a0','');
				return retorno;
			}
			else {
				return '';
			}

		}catch(Exception ex){
			system.debug('Exception: ' + ex + ' - Message: ' + ex.getStackTraceString());
			if(ex.getMessage().length() > 32000) {
				this.descriptionErro = ex.getMessage().substring(0, 31999);
			}
			else {
				this.descriptionErro = ex.getMessage();
			}

			return '';
		}
	}

	private String getValueBodyProduto(String htmlBody, String produto, String campo){
		try {
			if(Pattern.matches('^.*' + produto + '.*?' + campo + '.*?td.*?>(.*?)<.*$', htmlBody)) {
				return htmlBody.replaceAll('^.*' + produto + '.*?' + campo + '.*?td.*?>(.*?)<.*$', '$1').replace('\u00a0','');
			}
			else {
				return '';
			}


		}catch(Exception ex){
			system.debug('Exception: ' + ex + ' - Message: ' + ex.getStackTraceString());
			if(ex.getMessage().length() > 32000) {
				this.descriptionErro = ex.getMessage().substring(0, 31999);
			}
			else {
				this.descriptionErro = ex.getMessage();
			}

			return '';
		}
	}

	private void insertEmailMessage(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope, String fromAddress, Id id){
		EmailMessage objEmailMEssage = new EmailMessage();

		//objEmailMEssage.ParentId = '500P0000005VNE1IAO';
		objEmailMEssage.Subject = email.subject.contains('ref:') ? email.subject : email.subject + ' [ref:' + id + ']';
		objEmailMEssage.Status = '1';
		objEmailMEssage.MessageDate = Date.today();
		objEmailMEssage.Incoming = true;
		objEmailMEssage.HtmlBody = Util.truncate(email.htmlBody, 32000);
		objEmailMEssage.TextBody = Util.truncate(email.plainTextBody, 32000);
		objEmailMEssage.FromAddress = fromAddress != null ? fromAddress : envelope.fromAddress;
		objEmailMEssage.ToAddress = email.toAddresses != null ? string.join(email.toAddresses,';') : null;
		objEmailMEssage.CcAddress = email.ccAddresses != null ? string.join(email.ccAddresses,';')  : null;
		objEmailMEssage.FromName = email.fromname;

		if(Util.getNameObject(id) == 'Lead')
			objEmailMEssage.Lead__c = id;
		else if(Util.getNameObject(id) == 'Opportunity')
			objEmailMEssage.Oportunidade__c = id;

		insert objEmailMEssage;
	}

	private void insertTask(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope, Id id){
		Task objTask = new Task();

		objTask.Description = Util.truncate(email.plainTextBody, 32000);
		objTask.Priority  = 'Normal';
		objTask.Status = 'Inbound Email';
		objTask.Subject = email.subject;
		objTask.IsReminderSet = true;
		objTask.ReminderDateTime = Date.today().addDays(2);
		//objTask.WhoId = id;

		if(Util.getNameObject(id) == 'Lead')
			objTask.WhoId = id;
		else if(Util.getNameObject(id) == 'Opportunity')
			objTask.WhatId = id;

		upsert objTask;
	}

	public Decimal convertToDecimal(String numero) {
		try {
			return Decimal.valueOf(numero);
		}
		catch(Exception e) {
			System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
			return 0;
		}
	}

	public Integer convertToInteger(String numero) {
		try {
			return Integer.valueOf(numero);
		}
		catch(Exception e) {
			System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
			return 0;
		}
	}

	public class EmailTO {
		private String cnpj { get; set; }
		private String razaoSocial { get; set; }
		private String nomeFantasia { get; set; }
		private String numeroFuncionarios { get; set; }
		private String orgaoPublico { get; set; }
		private String municipio { get; set; }
		private String estado { get; set; }
		private String bairro { get; set; }
		private String endereco { get; set; }
		private String numero { get; set; }
		private String complemento { get; set; }
		private String cep { get; set; }
		private String nomeContato { get; set; }
		private String ddd { get; set; }
		private String telefone { get; set; }
		private String email { get; set; }
		private String receberInformacoes { get; set; }
		private String dataCadastro { get; set; }
		private List<ProdutoTo> produtos { get; set; }
	}

	public class ProdutoTo {
		private String nome { get; set; }
		private String temInteresse { get; set; }
		private String quantidade { get; set; }
		private String valor { get; set; }
	}
}
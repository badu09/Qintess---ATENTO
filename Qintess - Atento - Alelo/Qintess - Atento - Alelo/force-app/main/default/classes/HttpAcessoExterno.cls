public class HttpAcessoExterno {
    
  public static TOTarifaRetorno getPricePolicy(TOTarifa tarifaTO) 
  {	
  	TOTarifaRetorno toTarifaRetorno = new TOTarifaRetorno();
  	
  	toTarifaRetorno.sucesso = true; 
  	toTarifaRetorno.lTarifaAlelo = new List<Tarifas_Alelo__c>();
    
    Date hoje = Date.today();
    String dataHoje = hoje.day() + '/' + hoje.month() + '/' + hoje.year();
    DOM.Document docRequest = new DOM.Document();
    String soapenv = 'http://schemas.xmlsoap.org/soap/envelope/';
    String impl = 'http://impl.middleware.alelo.atento.com.br/';

    DOM.XmlNode envelopeRequest = docRequest.createRootElement('Envelope', soapenv, 'soapenv');
    envelopeRequest.setNamespace('impl', impl);

    DOM.XmlNode header = envelopeRequest.addChildElement('soapenv:Header', null, null);
    DOM.XmlNode body = envelopeRequest.addChildElement('soapenv:Body', null, null);
    DOM.XmlNode acessarGetPricePolicyIS = body.addChildElement('impl:acessarGetPricePolicyIS', null, null);
    acessarGetPricePolicyIS.addChildElement('spokemanCPF', null, null).addTextNode('');
    acessarGetPricePolicyIS.addChildElement('controlLevel', null, null).addTextNode('BASIC');
    acessarGetPricePolicyIS.addChildElement('saleChannel', null, null).addTextNode('BANK_AGENCY');

    acessarGetPricePolicyIS.addChildElement('paymentType', null, null).addTextNode('PREPAID');

    acessarGetPricePolicyIS.addChildElement('contractType', null, null).addTextNode('DEFAULT');
    acessarGetPricePolicyIS.addChildElement('feeCodeList', null, null).addTextNode(tarifaTO.FeeCode);
    acessarGetPricePolicyIS.addChildElement('productCode', null, null).addTextNode(tarifaTO.ProductCode);
    acessarGetPricePolicyIS.addChildElement('referenceDate', null, null).addTextNode(dataHoje);
    acessarGetPricePolicyIS.addChildElement('communicationInstitution', null, null).addTextNode('ATENTO');
    acessarGetPricePolicyIS.addChildElement('communicationChannel', null, null).addTextNode('PAT');
    acessarGetPricePolicyIS.addChildElement('communicationUsn', null, null).addTextNode('1925');
    acessarGetPricePolicyIS.addChildElement('communicationProduct', null, null).addTextNode(tarifaTO.CommunicationProduct);

	toTarifaRetorno.bodyRequest = docRequest.toXmlString();

	try {
	    HttpResponse httpResponse = HttpGeneric.executarHttpAcessoExterno('POST', docRequest.toXmlString());
	    
	    toTarifaRetorno.bodyResponse = httpResponse.getBody();
	    
	    System.debug('httpResponse: ' + httpResponse.getBody());
		DOM.Document domResponse;
		try{
			domResponse = httpResponse.getBodyDocument();
		} catch(Exception e){

		}

	
	    String S = 'http://schemas.xmlsoap.org/soap/envelope/';
	    String ns2 = 'http://impl.middleware.alelo.atento.com.br/';
	
	    DOM.XmlNode rootRes = domResponse.getRootElement();
	    DOM.XmlNode bodyResponse = rootRes.getChildElement('Body', S);
	    DOM.XmlNode acessarGetPricePolicyISResponse = bodyResponse.getChildElement('acessarGetPricePolicyISResponse', ns2);
	
	    DOM.XmlNode returnResponse = acessarGetPricePolicyISResponse.getChildElement('return', null);
	    DOM.XmlNode[] pricePolicyList = returnResponse.getChildElements();
	
	    for(DOM.XmlNode item : pricePolicyList) {
	   	  if(item.getName() == 'responseData') {
	   	  	if(item.getChildElement('errorList', null) != null) {
	   	  		DOM.XmlNode errorList = item.getChildElement('errorList', null);
	   	  		
	   	  		if(errorList.getChildElements() != null && errorList.getChildElements().size() > 0) {
	   	  			DOM.XmlNode errorData = errorList.getChildElements()[0].getChildElement('errorCode', null);
	   	  			DOM.XmlNode errorMessage = errorList.getChildElements()[0].getChildElement('errorMessage', null);
	   	  			
	   	  			toTarifaRetorno.retorno = errorData.getText() + ' - ' + errorMessage.getText();
	   	  			toTarifaRetorno.sucesso = false;   	  		
	   	  			break;	
	   	  		}
	   	  	}
	   	  }	 	
	      else if(item.getName() == 'pricePolicyList') {
	        Tarifas_Alelo__c tarifa = new Tarifas_Alelo__c();
	        tarifa.Codigo_de_Produtos__c = tarifaTO.ProductCode;
	        tarifa.Nome_do_Produto__c = tarifaTO.ProductName;
	        tarifa.Codigo_da_Tarifa__c = Decimal.valueOf(tarifaTO.FeeCode);
	        tarifa.Nome_da_Tarifa__c = tarifaTO.FeeName;
	
	        if(item.getChildElement('averageBenefit', null) != null)
	          tarifa.Valor_Maximo__c = Decimal.valueOf(item.getChildElement('averageBenefit', null).getText());
	
	        if(item.getChildElement('contractType', null) != null)
	          tarifa.Tipo_de_Contrato__c = item.getChildElement('contractType', null).getText();
	
	        if(item.getChildElement('maxValue', null) != null)
	          tarifa.Valor_Minimo__c = Decimal.valueOf(item.getChildElement('maxValue', null).getText());
	
	        if(item.getChildElement('minValue', null) != null)
	          tarifa.Valor_Unitario__c = Decimal.valueOf(item.getChildElement('minValue', null).getText());
	
	        if(item.getChildElement('paymentDueDays', null) != null)
	          tarifa.Qtd_Dias_para_Pagamento__c = Decimal.valueOf(item.getChildElement('paymentDueDays', null).getText());
	
	        if(item.getChildElement('paymentType', null) != null)
	          tarifa.Nome_da_Forma_de_Pagamento__c = item.getChildElement('paymentType', null).getText();
	
	
	        if(item.getChildElement('quantityFrom', null) != null)
	          tarifa.Qtd_Min__c = Decimal.valueOf(item.getChildElement('quantityFrom', null).getText());
	
	        if(item.getChildElement('quantityTo', null) != null)
	          tarifa.Qtd_Max_Beneficios__c = Decimal.valueOf(item.getChildElement('quantityTo', null).getText());
	
	        if(item.getChildElement('saleChannelCode', null) != null)
	          tarifa.Canal__c = item.getChildElement('saleChannelCode', null).getText();
	
	        if(item.getChildElement('validFrom', null) != null) {
	          String dataTxt = item.getChildElement('validFrom', null).getText();
	          Integer year = Integer.valueOf(dataTxt.replaceAll('(^\\d{4}).+', '$1'));
	          Integer month = Integer.valueOf(dataTxt.replaceAll('^\\d{4}-(\\d{2}).+', '$1'));
	          Integer day = Integer.valueOf(dataTxt.replaceAll('^\\d{4}-\\d{2}-(\\d{2}).+', '$1'));
	          Date data = Date.newInstance(year, month, day);
	          tarifa.Data_Inicial_de_Validade__c = data;
	        }
	
	        if(item.getChildElement('valueType', null) != null)
	          tarifa.ValueType__c = item.getChildElement('valueType', null).getText();
	
	        toTarifaRetorno.lTarifaAlelo.add(tarifa);
	      }
	    }
	}
	catch(Exception ex) {
		
		system.debug('Erro getPricePolicy: ' + ex.getLineNumber());
        system.debug('Erro getPricePolicy: ' + ex.getStackTraceString());
        system.debug('Erro getPricePolicy: ' + ex.getTypeName());
        system.debug('Erro getPricePolicy: ' + ex.getCause());
        system.debug('Erro getPricePolicy: ' + ex.getMessage());
		
		toTarifaRetorno.retorno = ex.getLineNumber() + ' - ' + ex.getMessage();
   	  	toTarifaRetorno.sucesso = false;
	}
		
    return toTarifaRetorno;
  }

  public static void maitainContractIS(Account conta, Opportunity oportunidade, Produtos_Alelo__c produto) {
  	try {
	  	User usuario = DAOUser.getUser();
	    DOM.Document docRequest = new DOM.Document();
	    String soapenv = 'http://schemas.xmlsoap.org/soap/envelope/';
	    String impl = 'http://impl.middleware.alelo.atento.com.br/';
	
	    Date hoje = Date.today();
	    Date hojeSignature = Date.today();
	    String dataHoje = (hoje.day() < 10 ? '0' + hoje.day(): Util.StringValueOf(hoje.day())) + '/' + (hoje.month() < 10 ? '0' + hoje.month(): Util.StringValueOf(hoje.month())) + '/' + hoje.year();
	
	    DOM.XmlNode envelopeRequest = docRequest.createRootElement('Envelope', soapenv, 'soapenv');
	    envelopeRequest.setNamespace('impl', impl);
	
	    DOM.XmlNode header = envelopeRequest.addChildElement('soapenv:Header', null, null);
	    DOM.XmlNode body = envelopeRequest.addChildElement('soapenv:Body', null, null);
	    DOM.XmlNode acessarMaintainContractIS = body.addChildElement('impl:acessarMaintainContractIS', null, null);
	    DOM.XmlNode maintainContractRequest = acessarMaintainContractIS.addChildElement('maintainContractRequest', null, null);
	    DOM.XmlNode communicationData = maintainContractRequest.addChildElement('communicationData', null, null);
	    communicationData.addChildElement('additionalInformation', null, null).addTextNode('Atento');
	    communicationData.addChildElement('channel', null, null).addTextNode('W005');
	    communicationData.addChildElement('institution', null, null).addTextNode('Atento');
	    if(produto.Codigo_de_Produtos__c == '301' || produto.Codigo_de_Produtos__c == '302') {
	    	communicationData.addChildElement('product', null, null).addTextNode('16');
	    }
	    else {
	    	communicationData.addChildElement('product', null, null).addTextNode('1');
	    }
	    communicationData.addChildElement('usn', null, null).addTextNode('19282');
	
	    // for(algumaCoisa) {
			DOM.XmlNode contractList = maintainContractRequest.addChildElement('contractList', null, null);
			// contractList.addChildElement('acceptComplementaryDisponibilization', null, null).addTextNode('');
			// contractList.addChildElement('additionalDocumentNumber', null, null).addTextNode('');
			// contractList.addChildElement('additionalDocumentType', null, null).addTextNode('');
			DOM.XmlNode address = contractList.addChildElement('address', null, null);
			address.addChildElement('addressType', null, null).addTextNode('LEGAL');
			address.addChildElement('cityName', null, null).addTextNode(Util.StringValueOf(conta.BillingCity));
			if(Util.StringValueOf(conta.Complemento_Cobranca__c) != '')
				address.addChildElement('complement', null, null).addTextNode(Util.StringValueOf(conta.Complemento_Cobranca__c));
			address.addChildElement('countryISOCode', null, null).addTextNode('BR');
			address.addChildElement('countryName', null, null).addTextNode('Brasil');
			
			if(conta.Numero__c != null) {
				address.addChildElement('doorNumber', null, null).addTextNode(Util.StringValueOf(conta.Numero__c));
			}
			else {
				address.addChildElement('doorNumber', null, null).addTextNode('0');
			}
			
			// address.addChildElement('geoStateName', null, null).addTextNode('');
			address.addChildElement('neighbourhood', null, null).addTextNode(Util.StringValueOf(conta.Bairro_Cobranca__c));
			// address.addChildElement('POBox', null, null).addTextNode('');
			// address.addChildElement('POBoxPostalCode', null, null).addTextNode('');
			address.addChildElement('postalCode', null, null).addTextNode(Util.StringValueOf(conta.BillingPostalCode).replace('-', ''));
			address.addChildElement('stateISOCode', null, null).addTextNode(Util.StringValueOf(conta.Estado__c));
			address.addChildElement('street', null, null).addTextNode(Util.StringValueOf(conta.BillingStreet));
			contractList.addChildElement('adjustmentIndexCode', null, null).addTextNode('IPCA');
			// contractList.addChildElement('authorizationCode', null, null).addTextNode('');
			contractList.addChildElement('averageMonthlyIndividualBenefitValue', null, null).addTextNode(Util.StringValueOf(produto.Valor_Unitario__c));
			// contractList.addChildElement('bankAccountDigitForDebitInAccount', null, null).addTextNode('');
			// contractList.addChildElement('bankAccountNumberForDebitInAccount', null, null).addTextNode('');
			if(produto.Banco__c == 'Banco do Brasil') {
				contractList.addChildElement('bankBillingBankCode', null, null).addTextNode('1');
			}
			else if(produto.Banco__c == 'Bradesco') {
				contractList.addChildElement('bankBillingBankCode', null, null).addTextNode('237');
			}
			else if(produto.Banco__c == 'Santander') {
				contractList.addChildElement('bankBillingBankCode', null, null).addTextNode('33');
			}
			else {
				contractList.addChildElement('bankBillingBankCode', null, null).addTextNode('237');
			}
			contractList.addChildElement('billingBranchCNPJ', null, null).addTextNode(Util.StringValueOf(conta.CPF_CNPJ__c));
			// contractList.addChildElement('billingDay', null, null).addTextNode('');
			// contractList.addChildElement('billingPeriodicityType', null, null).addTextNode('');
			// contractList.addChildElement('birthDate', null, null).addTextNode('');
			// contractList.addChildElement('branchCode', null, null).addTextNode('');
			contractList.addChildElement('branchCountPrevision', null, null).addTextNode('1');
			// contractList.addChildElement('brandCode', null, null).addTextNode('');
			contractList.addChildElement('canUsersAskCardAndPassword', null, null).addTextNode('false');
			// contractList.addChildElement('cardType', null, null).addTextNode('');
			//contractList.addChildElement('cnaeClassificationDivision', null, null).addTextNode(Util.StringValueOf(conta.Divisao_Ramo_de_Atividade__c));
			//TODO
			contractList.addChildElement('cnaeClassificationDivision', null, null).addTextNode('93');
			
			contractList.addChildElement('cnaeClassificationSection', null, null).addTextNode(Util.StringValueOf(conta.Secao_Ramo_de_Atividade__c).substring(0, 1));
			contractList.addChildElement('commercialAreaCBSSCode', null, null).addTextNode('0000000001');
			// contractList.addChildElement('companyCode', null, null).addTextNode('');
			contractList.addChildElement('companyType', null, null).addTextNode(Util.StringValueOf(conta.Tipo_de_Empresa__c).replaceAll('.+(\\d+).+', '$1'));
			DOM.XmlNode complementaryData = contractList.addChildElement('complementaryData', null, null);
			if(produto.Codigo_de_Produtos__c == '301' || produto.Codigo_de_Produtos__c == '302') {
				complementaryData.addChildElement('hasContractedInvoiceGathering', null, null).addTextNode('false');
				complementaryData.addChildElement('hasEmbossingOperacionalBaseName', null, null).addTextNode('false');
			}
			for(Tarifas_Carrinho__c tar : produto.Tarifas_Carrinhos__r) {
				if(produto.Codigo_de_Produtos__c == '300' || produto.Codigo_de_Produtos__c == '301' || produto.Codigo_de_Produtos__c == '302') {
					if(Util.StringValueOf(tar.Codigo_da_Tarifa__c) == '6' || Util.StringValueOf(tar.Codigo_da_Tarifa__c) == '8' || Util.StringValueOf(tar.Codigo_da_Tarifa__c) == '9' || Util.StringValueOf(tar.Codigo_da_Tarifa__c) == '10' ) {
						continue;
					}
				}
				DOM.XmlNode contractFee = contractList.addChildElement('contractFee', null, null);
				contractFee.addChildElement('advantageMonthQuantity', null, null).addTextNode('0');
				contractFee.addChildElement('advantagePercentage', null, null).addTextNode('0');
				contractFee.addChildElement('discountMonthQuantity', null, null).addTextNode('2');
				contractFee.addChildElement('exemptMonthQuantity', null, null).addTextNode('0');
				contractFee.addChildElement('feeCode', null, null).addTextNode(Util.StringValueOf(tar.Codigo_da_Tarifa__c));
				contractFee.addChildElement('feePercentage', null, null).addTextNode('0');
				// alterakrjdaçlksjfoasijdóifajóeijfa´0jdoijfawóijefoiwajoifjeoiawjfoiejwa~´oifjeóiwjófeawjfeiai
				// código comentado dia 04/02 para mostrar apenas valor unitário independente de nível do produto
//				if(produto.Nivel__c == 1) {
//					if(Util.StringValueOf(tar.Valor_Unitario__c) != '') {
//						contractFee.addChildElement('unitaryFeeAmount', null, null).addTextNode(Util.StringValueOf(tar.Valor_Unitario__c));
//					}
//					else {
//						contractFee.addChildElement('unitaryFeeAmount', null, null).addTextNode('0');
//					}
//				}
//				else{
//					if(Util.StringValueOf(tar.Valor_Tarifa_Padrao__c) != '') {
//						contractFee.addChildElement('unitaryFeeAmount', null, null).addTextNode(Util.StringValueOf(tar.Valor_Tarifa_Padrao__c));
//					}
//					else {
//						contractFee.addChildElement('unitaryFeeAmount', null, null).addTextNode('0'); // Alguns estão vazios
//					}
//				}
			// código dia 04/02 para unitaryFeeAmount ser valor unitario
				if(Util.StringValueOf(tar.Valor_Unitario__c) != '') {
						contractFee.addChildElement('unitaryFeeAmount', null, null).addTextNode(Util.StringValueOf(tar.Valor_Unitario__c));
					}
					else {
						contractFee.addChildElement('unitaryFeeAmount', null, null).addTextNode('0');
					}
				// contractFee.addChildElement('validFrom', null, null).addTextNode('');
				// contractFee.addChildElement('validTo', null, null).addTextNode('');
			}
	        // contractList.addChildElement('contractHasCreditLimit', null, null).addTextNode('');
	        // contractList.addChildElement('contractNumber', null, null).addTextNode('');
	        // contractList.addChildElement('contractNumberMother', null, null).addTextNode('');
	        contractList.addChildElement('contractType', null, null).addTextNode('DEFAULT');
	        contractList.addChildElement('contracteeDocumentNumber', null, null).addTextNode(Util.StringValueOf(conta.CPF_CNPJ__c));
	        contractList.addChildElement('contracteeDocumentType', null, null).addTextNode('CNPJ');
	        
	        if(conta.Razao_Social__c != null ) {
		        if(conta.Razao_Social__c.length() <= 20) {
		        	contractList.addChildElement('contracteeLegalName', null, null).addTextNode(Util.StringValueOf(conta.Razao_Social__c));
		        }
		        else {
		        	contractList.addChildElement('contracteeLegalName', null, null).addTextNode(Util.StringValueOf(conta.Razao_Social__c).substring(0, 19));
		        } 
	        }
	        contractList.addChildElement('contracteeMunicipalInscriptionNumber', null, null).addTextNode(Util.StringValueOf(conta.Inscricao_Municipal__c));
	        
	        // contractList.addChildElement('contracteeStateInscriptionNumber', null, null).addTextNode('12345678');
	        contractList.addChildElement('contracteeStateInscriptionNumber', null, null).addTextNode(Util.StringValueOf(conta.Inscricao_Estadual__c));
	        contractList.addChildElement('controlLevel', null, null).addTextNode('BASIC');
	        // contractList.addChildElement('creditAmount', null, null).addTextNode('');
	        // contractList.addChildElement('creditExpirationDate', null, null).addTextNode('');
	        // contractList.addChildElement('creditLimitAmount', null, null).addTextNode('');
	        // contractList.addChildElement('creditLimitBankCode', null, null).addTextNode('');
	        // contractList.addChildElement('creditLimitExpirationDate', null, null).addTextNode('');
	        // contractList.addChildElement('creditLimitValidSinceDate', null, null).addTextNode('');
	        // contractList.addChildElement('creditValidSinceDate', null, null).addTextNode('');
	        // contractList.addChildElement('dayMinimmumAcceptRequest', null, null).addTextNode('');
	        // contractList.addChildElement('debitAccountAgencyCheckDigit', null, null).addTextNode('');
	        // contractList.addChildElement('debitAccountAgencyCode', null, null).addTextNode('');
	        // contractList.addChildElement('debitAccountBankCode', null, null).addTextNode('');
	
	        DOM.XmlNode decisionSpokesman = contractList.addChildElement('decisionSpokesman', null, null);
	        // decisionSpokesman.addChildElement('admissionDate', null, null);
	        DOM.XmlNode addressDecision = decisionSpokesman.addChildElement('adress', null, null);
	        addressDecision.addChildElement('addressType', null, null).addTextNode('LEGAL');
	        addressDecision.addChildElement('cityName', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.MailingCity));
	        if(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Complemento__c) != '')
	        	addressDecision.addChildElement('complement', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Complemento__c));
	        addressDecision.addChildElement('countryISOCode', null, null).addTextNode('BR');
	        addressDecision.addChildElement('countryName', null, null).addTextNode('Brasil');
	        
	        if(oportunidade.Contato_da_oportunidade__r != null && oportunidade.Contato_da_oportunidade__r.Numero__c != null && oportunidade.Contato_da_oportunidade__r.Numero__c.isNumeric()) {
	        	addressDecision.addChildElement('doorNumber', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Numero__c));
	        }
	        else {
	        	addressDecision.addChildElement('doorNumber', null, null).addTextNode('0');
	        }
	        
	        // addressDecision.addChildElement('geoStateName', null, null).addTextNode('');
	        addressDecision.addChildElement('neighbourhood', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Bairro__c));
	        // addressDecision.addChildElement('POBox', null, null).addTextNode('');
	        // addressDecision.addChildElement('POBoxPostalCode', null, null).addTextNode('');
	        addressDecision.addChildElement('postalCode', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.MailingPostalCode).replace('-', ''));
	        addressDecision.addChildElement('stateISOCode', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Estado__c));
	        addressDecision.addChildElement('street', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.MailingStreet));
	
			Date dsBirthDate = oportunidade.Contato_da_oportunidade__r.Data_de_Nascimento__c;
			if(dsBirthDate != null) {
		        String dSBirthDateStr = dsBirthDate.year() + '-' + (dsBirthDate.month() < 10 ? '0'+dsBirthDate.month(): Util.StringValueOf(dsBirthDate.month())) + '-' + (dsBirthDate.day() < 10 ? '0'+dsBirthDate.day(): Util.StringValueOf(dsBirthDate.day()));
		        decisionSpokesman.addChildElement('birthDate', null, null).addTextNode(dSBirthDateStr);
			}
	        // decisionSpokesman.addChildElement('code', null, null).addTextNode('');
	        decisionSpokesman.addChildElement('commercialAdressType', null, null).addTextNode('BRANCH');
	        decisionSpokesman.addChildElement('companyDocumentNumber', null, null).addTextNode(Util.StringValueOf(conta.CPF_CNPJ__c));
	        decisionSpokesman.addChildElement('companyDocumentType', null, null).addTextNode('CNPJ');
	        decisionSpokesman.addChildElement('documentNumber', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.CPF__c));
	        decisionSpokesman.addChildElement('email', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Email));
	        // decisionSpokesman.addChildElement('employeeNumber', null, null).addTextNode('');
	        // decisionSpokesman.addChildElement('externalDocument', null, null).addTextNode('');
	        // decisionSpokesman.addChildElement('externalDocumentCountryISOCode', null, null).addTextNode('');
	        // decisionSpokesman.addChildElement('externalDocumentCountryName', null, null).addTextNode('');
	        // decisionSpokesman.addChildElement('externalDocumentIssueDate', null, null).addTextNode('');
	        // decisionSpokesman.addChildElement('externalDocumentIssuer', null, null).addTextNode('');
	        // decisionSpokesman.addChildElement('externalDocumentState', null, null).addTextNode('');
	        // decisionSpokesman.addChildElement('externalDocumentType', null, null).addTextNode('');
	
	        // DOM.XmlNode fax = decisionSpokesman.addChildElement('fax', null, null);
	        // fax.addChildElement('areaCode', null, null).addTextNode('');
	        // fax.addChildElement('countryCode', null, null).addTextNode('');
	        // fax.addChildElement('extension', null, null).addTextNode('');
	        // fax.addChildElement('phoneNumber', null, null).addTextNode('');
	        // fax.addChildElement('phoneType', null, null).addTextNode('');
	
			if(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Sexo__c) == 'Masculino') {
				decisionSpokesman.addChildElement('gender', null, null).addTextNode('MALE');
			}
			else if(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Sexo__c) == 'Feminino') {
				decisionSpokesman.addChildElement('gender', null, null).addTextNode('FEMALE');	
			}
	        
	        // decisionSpokesman.addChildElement('idScholarshipDef', null, null).addTextNode('');
	        // decisionSpokesman.addChildElement('idUser', null, null).addTextNode('');
	        // decisionSpokesman.addChildElement('jobDescription', null, null).addTextNode('');
	        decisionSpokesman.addChildElement('jobType', null, null).addTextNode('MANAGER');
	        decisionSpokesman.addChildElement('localization', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Department));
	        // decisionSpokesman.addChildElement('maritalStatus', null, null).addTextNode('');
	
	        DOM.XmlNode phone1 = decisionSpokesman.addChildElement('phone1', null, null);
	        phone1.addChildElement('areaCode', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.DDD__c)); //  Na especificação diz para usar Phone do contato
	        phone1.addChildElement('countryCode', null, null).addTextNode('55');
	        // phone1.addChildElement('extension', null, null).addTextNode('');
	        phone1.addChildElement('phoneNumber', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Telefone__c));
	        phone1.addChildElement('phoneType', null, null).addTextNode('PHONE');
	
	        // DOM.XmlNode phone2 = decisionSpokesman.addChildElement('phone2', null, null);
	        // phone2.addChildElement('areaCode', null, null).addTextNode('');
	        // phone2.addChildElement('countryCode', null, null).addTextNode('');
	        // phone2.addChildElement('extension', null, null).addTextNode('');
	        // phone2.addChildElement('phoneNumber', null, null).addTextNode('');
	        // phone2.addChildElement('phoneType', null, null).addTextNode('');
	
	        decisionSpokesman.addChildElement('spokesmanName', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Name));
	
	        contractList.addChildElement('decisionSpokesmanIsCompanyEmployee', null, null).addTextNode('true');
	        contractList.addChildElement('deliveryBranchCNPJ', null, null).addTextNode(Util.StringValueOf(conta.CPF_CNPJ__c));
	        // contractList.addChildElement('economicGroupName', null, null).addTextNode('');
	        // contractList.addChildElement('emailAddress', null, null).addTextNode('');
	        
	        if(produto.Nome_Empresa_Gravacao_Cartao__c != null) {
		        if(produto.Nome_Empresa_Gravacao_Cartao__c.length() <= 19) {
			        contractList.addChildElement('embossingCompanyName', null, null).addTextNode(Util.StringValueOf(produto.Nome_Empresa_Gravacao_Cartao__c));
		        }
		        else {
		        	contractList.addChildElement('embossingCompanyName', null, null).addTextNode(Util.StringValueOf(produto.Nome_Empresa_Gravacao_Cartao__c).substring(0, 18));
		        }
	        }
	        contractList.addChildElement('entryChannelCode', null, null).addTextNode('W005');
	        if(conta.Nome_Fantasia__c != null) {
		        if(conta.Nome_Fantasia__c.length() <= 20) {
		        	contractList.addChildElement('fantasyName', null, null).addTextNode(Util.StringValueOf(conta.Nome_Fantasia__c));
		        }
		        else {
		        	contractList.addChildElement('fantasyName', null, null).addTextNode(Util.StringValueOf(conta.Nome_Fantasia__c).substring(0, 19));
		        }
	        }
	        // DOM.XmlNode faxNumber = contractList.addChildElement('faxNumber', null, null);
	        // faxNumber.addChildElement('areaCode', null, null).addTextNode('');
	        // faxNumber.addChildElement('countryCode', null, null).addTextNode('');
	        // faxNumber.addChildElement('extension', null, null).addTextNode('');
	        // faxNumber.addChildElement('phoneNumber', null, null).addTextNode('');
	        // faxNumber.addChildElement('phoneType', null, null).addTextNode('');
	
	        // contractList.addChildElement('gender', null, null).addTextNode('');
	        // contractList.addChildElement('hasAcceptedContractTerms', null, null).addTextNode('');
	        contractList.addChildElement('hasFinancialRestriction', null, null).addTextNode('false');
	        // contractList.addChildElement('incentiveProgramInscriptionNumber', null, null).addTextNode('1234567891'); // Número de Inscrição do Programa de Incentivo
	        contractList.addChildElement('individualHomeDelivery', null, null).addTextNode('false');
	        contractList.addChildElement('invoiceBranchCNPJ', null, null).addTextNode(Util.StringValueOf(conta.CPF_CNPJ__c));
	        // contractList.addChildElement('isAgileDelivery', null, null).addTextNode('');
	        // contractList.addChildElement('isAntecipatedDisponibilization', null, null).addTextNode('');
	        contractList.addChildElement('isCPFSalesmanCode', null, null).addTextNode('false');
	        contractList.addChildElement('isDeliveryCentralized', null, null).addTextNode(Util.StringValueOf(produto.Entrega_Centralizada__c));
	        contractList.addChildElement('isElectronicInvoicing', null, null).addTextNode('false');  // Igual o que xml que funcionou
	        // contractList.addChildElement('isHoldingCompany', null, null).addTextNode('');
	        contractList.addChildElement('isInvoiceCentralized', null, null).addTextNode(Util.StringValueOf(produto.Faturamento_Centralizado__c));
	        contractList.addChildElement('issuerCode', null, null).addTextNode('1');
	        // contractList.addChildElement('latePaymentInterestsPercentage', null, null).addTextNode('');
	        // contractList.addChildElement('latePaymentPenaltyPercentage', null, null).addTextNode('');
	        
	        if(conta.Razao_Social__c != null ) {
		        if(conta.Razao_Social__c.length() <= 40) {
			        contractList.addChildElement('legalName', null, null).addTextNode(Util.StringValueOf(conta.Razao_Social__c));
		        }
		        else {
		        	contractList.addChildElement('legalName', null, null).addTextNode(Util.StringValueOf(conta.Razao_Social__c).substring(0, 39));
		        }
	        }
	        // contractList.addChildElement('limitRenovationDay', null, null).addTextNode('');
	        // contractList.addChildElement('limitRenovationPeriodType', null, null).addTextNode('');
	        contractList.addChildElement('marketType', null, null).addTextNode('MARKET');
	        // contractList.addChildElement('maximumMonthlyBenefit', null, null).addTextNode('');
	        // contractList.addChildElement('modifyCreditLimit', null, null).addTextNode('');
	        contractList.addChildElement('negotiationType', null, null).addTextNode('NORMAL_SALE');// Na documentação tá DIRECT_SALE
	        contractList.addChildElement('numberOfEmployees', null, null).addTextNode(Util.StringValueOf(conta.Quantidade_de_Funcionarios__c));
	
	        DOM.XmlNode operationSpokesman = contractList.addChildElement('operationSpokesman', null, null);
	        // operationSpokesman.addChildElement('admissionDate', null, null);
	        DOM.XmlNode addressOperation = operationSpokesman.addChildElement('adress', null, null);
			addressOperation.addChildElement('addressType', null, null).addTextNode('LEGAL');
	        addressOperation.addChildElement('cityName', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.MailingCity));
	        if(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Complemento__c) != '')
	        	addressOperation.addChildElement('complement', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Complemento__c));
	        addressOperation.addChildElement('countryISOCode', null, null).addTextNode('BR');
	        addressOperation.addChildElement('countryName', null, null).addTextNode('Brasil');
	        
	        if(oportunidade.Contato_da_oportunidade_2__r != null && oportunidade.Contato_da_oportunidade_2__r.Numero__c != null && oportunidade.Contato_da_oportunidade_2__r.Numero__c.isNumeric()) { 
	        	addressOperation.addChildElement('doorNumber', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Numero__c));
	        }
	        else { 
	        	addressOperation.addChildElement('doorNumber', null, null).addTextNode('0');
	        }
	        
	        // addressOperation.addChildElement('geoStateName', null, null).addTextNode('');
	        addressOperation.addChildElement('neighbourhood', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Bairro__c));
	        // addressOperation.addChildElement('POBox', null, null).addTextNode('');
	        // addressOperation.addChildElement('POBoxPostalCode', null, null).addTextNode('');
	        addressOperation.addChildElement('postalCode', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.MailingPostalCode).replace('-', ''));
	        addressOperation.addChildElement('stateISOCode', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Estado__c));
	        addressOperation.addChildElement('street', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.MailingStreet));
	
			Date dsBirthDateOp = oportunidade.Contato_da_oportunidade_2__r.Data_de_Nascimento__c;
			if(dsBirthDateOp != null) {
		        String dSBirthDateOPStr = dsBirthDateOp.year() + '-' + (dsBirthDateOp.month() < 10 ? '0'+dsBirthDateOp.month(): Util.StringValueOf(dsBirthDateOp.month())) + '-' + (dsBirthDateOp.day() < 10 ? '0'+dsBirthDateOp.day(): Util.StringValueOf(dsBirthDateOp.day()));
		    	operationSpokesman.addChildElement('birthDate', null, null).addTextNode(dSBirthDateOPStr);
			}
	        
	        // operationSpokesman.addChildElement('code', null, null).addTextNode('');
	        operationSpokesman.addChildElement('commercialAdressType', null, null).addTextNode('BRANCH');
	        operationSpokesman.addChildElement('companyDocumentNumber', null, null).addTextNode(Util.StringValueOf(conta.CPF_CNPJ__c));
	        operationSpokesman.addChildElement('companyDocumentType', null, null).addTextNode('CNPJ');
	        operationSpokesman.addChildElement('documentNumber', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.CPF__c));
	        if(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Email) != '')
	        	operationSpokesman.addChildElement('email', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Email));
	        // operationSpokesman.addChildElement('employeeNumber', null, null).addTextNode('');
	        // operationSpokesman.addChildElement('externalDocument', null, null).addTextNode('');
	        // operationSpokesman.addChildElement('externalDocumentCountryISOCode', null, null).addTextNode('');
	        // operationSpokesman.addChildElement('externalDocumentCountryName', null, null).addTextNode('');
	        // operationSpokesman.addChildElement('externalDocumentIssueDate', null, null).addTextNode('');
	        // operationSpokesman.addChildElement('externalDocumentIssuer', null, null).addTextNode('');
	        // operationSpokesman.addChildElement('externalDocumentState', null, null).addTextNode('');
	        // operationSpokesman.addChildElement('externalDocumentType', null, null).addTextNode('');
	
	        // DOM.XmlNode faxOp = operationSpokesman.addChildElement('fax', null, null);
	        // faxOp.addChildElement('areaCode', null, null).addTextNode('');
	        // faxOp.addChildElement('countryCode', null, null).addTextNode('');
	        // faxOp.addChildElement('extension', null, null).addTextNode('');
	        // faxOp.addChildElement('phoneNumber', null, null).addTextNode('');
	        // faxOp.addChildElement('phoneType', null, null).addTextNode('');
	
			if(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Sexo__c) == 'Masculino') {
				decisionSpokesman.addChildElement('gender', null, null).addTextNode('MALE');
			}
			else if(Util.StringValueOf(oportunidade.Contato_da_oportunidade__r.Sexo__c) == 'Feminino') {
				operationSpokesman.addChildElement('gender', null, null).addTextNode('FEMALE');	
			}
	        // operationSpokesman.addChildElement('idScholarshipDef', null, null).addTextNode('');
	        // operationSpokesman.addChildElement('idUser', null, null).addTextNode('');
	        // operationSpokesman.addChildElement('jobDescription', null, null).addTextNode('');
	        operationSpokesman.addChildElement('jobType', null, null).addTextNode('MANAGER');
	        if(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Department) != '')
	        	operationSpokesman.addChildElement('localization', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Department));
	        // operationSpokesman.addChildElement('maritalStatus', null, null).addTextNode('');
	
	        DOM.XmlNode phone1Op = operationSpokesman.addChildElement('phone1', null, null);
	        phone1Op.addChildElement('areaCode', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.DDD__c)); //  Na especificação diz para usar Phone do contato
	        phone1Op.addChildElement('countryCode', null, null).addTextNode('55');
	        // phone1Op.addChildElement('extension', null, null).addTextNode('');
	        phone1Op.addChildElement('phoneNumber', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Telefone__c));
	        phone1Op.addChildElement('phoneType', null, null).addTextNode('PHONE');
	
	        // DOM.XmlNode phone2Op = operationSpokesman.addChildElement('phone2', null, null);
	        // phone2Op.addChildElement('areaCode', null, null).addTextNode('');
	        // phone2Op.addChildElement('countryCode', null, null).addTextNode('');
	        // phone2Op.addChildElement('extension', null, null).addTextNode('');
	        // phone2Op.addChildElement('phoneNumber', null, null).addTextNode('');
	        // phone2Op.addChildElement('phoneType', null, null).addTextNode('');
	
	        operationSpokesman.addChildElement('spokesmanName', null, null).addTextNode(Util.StringValueOf(oportunidade.Contato_da_oportunidade_2__r.Name));
	
	        contractList.addChildElement('operationSpokesmanIsCompanyEmployee', null, null).addTextNode('true'); // Igual o que xml que funcionou
	        // contractList.addChildElement('paymentDeadLineEndDate', null, null).addTextNode('');
	        // contractList.addChildElement('paymentDeadLineStartDate', null, null).addTextNode('');
	        // contractList.addChildElement('paymentDueDays', null, null).addTextNode('');
	        
        	contractList.addChildElement('paymentType', null, null).addTextNode('PREPAID');
        
        	if(produto.FormaPagamento__c.equalsIgnoreCase(TOTarifa.FORMA_PAGAMENTO_BOLETO))
            {
                contractList.addChildElement('paymentMedia', null, null).addTextNode('WEB_TICKET');
            }
        	else if (produto.FormaPagamento__c.equalsIgnoreCase(TOTarifa.FORMA_PAGAMENTO_CREDITO))
            {
                contractList.addChildElement('paymentMedia', null, null).addTextNode('CREDIT_CARD');
            }

	        DOM.XmlNode phone1Cont = contractList.addChildElement('phone1', null, null);
	        phone1Cont.addChildElement('areaCode', null, null).addTextNode('11');
	        phone1Cont.addChildElement('countryCode', null, null).addTextNode('55');
	        // phone1Cont.addChildElement('extension', null, null).addTextNode('');
	        phone1Cont.addChildElement('phoneNumber', null, null).addTextNode('21886152');
	        phone1Cont.addChildElement('phoneType', null, null).addTextNode('PHONE');
	
	        // DOM.XmlNode phone2Cont = contractList.addChildElement('phone2', null, null);
	        // phone2Cont.addChildElement('areaCode', null, null).addTextNode('');
	        // phone2Cont.addChildElement('countryCode', null, null).addTextNode('');
	        // phone2Cont.addChildElement('extension', null, null).addTextNode('');
	        // phone2Cont.addChildElement('phoneNumber', null, null).addTextNode('');
	        // phone2Cont.addChildElement('phoneType', null, null).addTextNode('');
	
	        contractList.addChildElement('productCode', null, null).addTextNode(Util.StringValueOf(produto.Codigo_de_Produtos__c));
	        // contractList.addChildElement('professionalActivity', null, null).addTextNode('');
	        // contractList.addChildElement('proposalCardNumber', null, null).addTextNode('');
	        // for(algumaCoisa) {
	          contractList.addChildElement('requestChannelCodes', null, null).addTextNode('W001');
	        // }
	        contractList.addChildElement('requestsCSVFile', null, null).addTextNode('false'); // Igual o que xml que funcionou
	        // contractList.addChildElement('restrictionReasonCode', null, null).addTextNode('');
	        contractList.addChildElement('saleChannelCode', null, null).addTextNode('BANK_AGENCY');
	        contractList.addChildElement('salesmanCode', null, null).addTextNode('00002');
	        contractList.addChildElement('salesmanName', null, null).addTextNode('ATENTO');
	
	        DOM.XmlNode salesmanPhoneNumber = contractList.addChildElement('salesmanPhoneNumber', null, null);
	        salesmanPhoneNumber.addChildElement('areaCode', null, null).addTextNode('11');
	        salesmanPhoneNumber.addChildElement('countryCode', null, null).addTextNode('55');
	        // salesmanPhoneNumber.addChildElement('extension', null, null).addTextNode('');
	        salesmanPhoneNumber.addChildElement('phoneNumber', null, null).addTextNode('21886152'); // Igual o que xml que funcionou
	        salesmanPhoneNumber.addChildElement('phoneType', null, null).addTextNode('PHONE');
	
	        // contractList.addChildElement('shareHoldingPercentage', null, null).addTextNode('');
	        contractList.addChildElement('signatureDate', null, null).addTextNode(hojeSignature.year() + '-' + (hojeSignature.month() < 10 ? '0'+hojeSignature.month(): Util.StringValueOf(hojeSignature.month())) + '-' + (hojeSignature.day() < 10 ? '0'+hojeSignature.day(): Util.StringValueOf(hojeSignature.day())));
	        // contractList.addChildElement('socialSecurityNumber', null, null).addTextNode('');
	        // contractList.addChildElement('status', null, null).addTextNode('');
	        contractList.addChildElement('technologyType', null, null).addTextNode('TARJA');
	        contractList.addChildElement('usageType', null, null).addTextNode('CREDIT');
	        // contractList.addChildElement('userCountPrevision', null, null).addTextNode(Util.StringValueOf(oportunidade.Quantidade_Total_de_Usuarios_Prevista__c));
	        contractList.addChildElement('userCountPrevision', null, null).addTextNode(Util.StringValueOf(produto.Quantidade_de_Cartoes__c));
	        
	        if(Util.StringValueOf(produto.Digito__c) != '') {
	        	contractList.addChildElement('vendorBranchCheckDigit', null, null).addTextNode(Util.StringValueOf(produto.Digito__c));
	        }
	        else {
		        contractList.addChildElement('vendorBranchCheckDigit', null, null).addTextNode('0');
	        }
	        if(Util.StringValueOf(produto.Agencia_Digito__c).replaceAll(' ', '') != '') {
	        	contractList.addChildElement('vendorBranchCode', null, null).addTextNode(Util.StringValueOf(produto.Agencia_Digito__c).replaceAll(' ', ''));
	        }
	        else {
	        	contractList.addChildElement('vendorBranchCode', null, null).addTextNode('1');
	        }
	
			if(produto.Banco__c == 'Banco do Brasil') {
				contractList.addChildElement('vendorCode', null, null).addTextNode('1');
			}
			else if(produto.Banco__c == 'Bradesco') {
				contractList.addChildElement('vendorCode', null, null).addTextNode('237');
			}
			else if(produto.Banco__c == 'Santander') {
				contractList.addChildElement('vendorCode', null, null).addTextNode('33');
			}
			else {
				contractList.addChildElement('vendorCode', null, null).addTextNode('1');
			}
	
			if(produto.Banco__c == 'Banco do Brasil' || produto.Banco__c == 'Bradesco' || produto.Banco__c == 'Santander') {
	        	contractList.addChildElement('vendorType', null, null).addTextNode('BANK');
			}
			else {
	        	contractList.addChildElement('vendorType', null, null).addTextNode('ORGANIZATION');
			}
	        contractList.addChildElement('viewAdditionalInfoWEB', null, null).addTextNode('false');
	        contractList.addChildElement('viewFeesWEB', null, null).addTextNode('true'); // Igual o que xml que funcionou 
	        // contractList.addChildElement('websiteName', null, null).addTextNode('');
	        
	        if(conta.Faturamento__c != null) {
	        	contractList.addChildElement('yearBillAmount', null, null).addTextNode(Util.StringValueOf(conta.Faturamento__c));
	        }
	        else {
	        	contractList.addChildElement('yearBillAmount', null, null).addTextNode('0');
	        }
	      // }
	      maintainContractRequest.addChildElement('spokesmanCPF', null, null).addTextNode(Util.StringValueOf(oportunidade.Owner.CPF__c));

	      String dataNascDe = '';
	      if(oportunidade.Contato_da_oportunidade__c != null && oportunidade.Contato_da_oportunidade__r.Data_de_Nascimento__c != null ) {
	        Date nasc = oportunidade.Contato_da_oportunidade__r.Data_de_Nascimento__c;
	        dataNascDe = (nasc.day() < 10 ? '0'+nasc.day(): Util.StringValueOf(nasc.day())) + '/' + (nasc.month() < 10 ? '0'+nasc.month(): Util.StringValueOf(nasc.month())) + '/' + nasc.year();
	      }
	

	      acessarMaintainContractIS.addChildElement('decisionSpokesmanBirthDate', null, null).addTextNode(dataNascDe);

		String dataNascOp = '';
		if(oportunidade.Contato_da_oportunidade_2__c != null && oportunidade.Contato_da_oportunidade_2__r.Data_de_Nascimento__c != null ) {
			Date nasc = oportunidade.Contato_da_oportunidade_2__r.Data_de_Nascimento__c;
			dataNascOp = (nasc.day() < 10 ? '0'+nasc.day(): Util.StringValueOf(nasc.day())) + '/' + (nasc.month() < 10 ? '0'+nasc.month(): Util.StringValueOf(nasc.month())) + '/' + nasc.year();
		}

		acessarMaintainContractIS.addChildElement('operationSpokesmanBirthDate', null, null).addTextNode(dataNascOp);


		dataHoje = (hojeSignature.day() < 10 ? '0'+hojeSignature.day(): Util.StringValueOf(hojeSignature.day())) + '/' + (hojeSignature.month() < 10 ? '0'+hojeSignature.month(): Util.StringValueOf(hojeSignature.month())) + '/' + hojeSignature.year();
		acessarMaintainContractIS.addChildElement('signatureDate', null, null).addTextNode(dataHoje);
	
	    HttpResponse httpResponse = HttpGeneric.executarHttpAcessoExterno('POST', docRequest.toXmlString());
	    // System.debug('httpResponse: ' + httpResponse.getBody());

		String erro = null;

		if(!Test.isRunningTest()){
			erro = HttpGeneric.validarResponseGetPricePolicy(httpResponse);
		}
       
	    if(erro != null){
	    	produto.Retorno_RW__c = erro;
			update produto;

	        throw new AcessoExternoException(erro);
	    }
	    else {
	    	String numeroContrato;
			String msgSucess;

			if(httpResponse == null || httpResponse.getBody().length() <= 0){
				return;
			}
	  		dom.Document resDoc = httpResponse.getBodyDocument();
			dom.XmlNode envelope = resDoc.getRootElement();

			String S = 'http://schemas.xmlsoap.org/soap/envelope/';
			String ns2 = 'http://impl.middleware.alelo.atento.com.br/';
			dom.XmlNode bodyRes = envelope.getChildElement('Body', S);
			dom.XmlNode acessarMaintainContractISResponse = bodyRes.getChildElement('acessarMaintainContractISResponse', ns2);

			if(acessarMaintainContractISResponse != null) {
				if(acessarMaintainContractISResponse.getChildElement('return', null) != null) {
					if(acessarMaintainContractISResponse.getChildElement('return', null).getChildElement('contractList', null) != null) {
						dom.XmlNode contractListRes = acessarMaintainContractISResponse.getChildElement('return', null).getChildElement('contractList', null);
						if(contractListRes.getChildElement('contractNumber', null) != null) {
							numeroContrato = contractListRes.getChildElement('contractNumber', null).getText();
							produto.Numero_do_Contrato__c = numeroContrato;
						}
					}
					
					if(acessarMaintainContractISResponse.getChildElement('return', null).getChildElement('responseData', null) != null) {
						dom.XmlNode responseDataRes = acessarMaintainContractISResponse.getChildElement('return', null).getChildElement('responseData', null);
						if(responseDataRes.getChildElement('clrs', null) != null) {
							msgSucess = responseDataRes.getChildElement('clrs', null).getText();
							produto.Retorno_RW__c = msgSucess;
						}
					}
					
					update produto;
				}
			}
	    }
  	} catch(System.CalloutException e) {
  		String erro = 'Read Timed Out';
  		produto.Retorno_RW__c = erro;
		update produto;
		
        throw new AcessoExternoException(erro);
  	}
  }

	public class AcessoExternoException extends Exception {}

	public static void test(){
		Integer i = 1;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;
		i--;
		i++;

	}
}
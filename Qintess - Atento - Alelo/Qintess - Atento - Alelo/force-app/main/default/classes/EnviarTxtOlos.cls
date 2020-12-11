global class EnviarTxtOlos {

	private static String nomeCampanha;

	@InvocableMethod(label='Enviar Maillings para Olos')
	global static void enviarMaillingOlos(List<WrapperClass> request){

		List<String> corpo = montarListaCorpo(request);
		System.debug('====ENVIAR TXT OLOS REQUEST====');
		System.debug(JSON.serialize(request));
		System.debug('===============================');

		Messaging.SendEmailResult[] result = enviarEmail(corpo);

		System.debug(result.get(0));

	}

	private static List<String> montarListaCorpo(List<WrapperClass> request){
		List<String> corpo = new List<String>();
		for (WrapperClass wc : request){
			StringBuilder sb = new StringBuilder();
			sb.adicionar(String.valueOf(wc.IdSF).toLowerCase()+wc.CNPJ+';');
			sb.adicionar(wc.CNPJ+';');
			sb.adicionar(wc.CAMPANHA+';');
			sb.adicionar(wc.NAME+';');
			sb.adicionar(wc.PHONE+';');
			sb.adicionar(wc.PHONE2+';');
			sb.adicionar(wc.PHONE3+';');
			sb.adicionar(wc.PHONE4+';');
			sb.adicionar(wc.PHONE5+';');
			sb.adicionar(wc.CORINGA_1+';');
			sb.adicionar(wc.CORINGA_2+';');
			sb.adicionar(wc.CORINGA_3+';');
			sb.adicionar(wc.CORINGA_4+';');
			sb.adicionar(wc.CORINGA_5+';');
			String linha = sb.getString()+'\n';
			corpo.add(linha);

			if (nomeCampanha == null){
				nomeCampanha = wc.CAMPANHA;
			}
		}

		return corpo;
	}

	private static String retornaNomeArquivo(String campanha){
		return 'S_F_LEAD_'+Datetime.now().format('ddMMyyyy')+campanha+'.txt';
	}

	private static Blob criarCorpoArquivo(List<String> registros){

		StringBuilder sb = new StringBuilder();
		String header = 'ID;CNPJ;CAMPANHA;NAME;PHONE;PHONE2;PHONE3;PHONE4;PHONE5;CORINGA_1;CORINGA_2;CORINGA_3;CORINGA_4;CORINGA_5';
		sb.adicionar(header);

		for (String s : registros){
			sb.adicionar(s);
		}

		return Blob.valueOf(sb.getStringPorLinha());
	}

	private static Messaging.SendEmailResult[] enviarEmail(List<String> registros){
		Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();

		Blob b = criarCorpoArquivo(registros);

		Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
		efa.setFileName(retornaNomeArquivo(nomeCampanha));
		efa.setBody(b);

		List<OrgWideEmailAddress> lista = DAOOrgWideEmailAddress.getEmailAddressByName('Mailing Olos');

		String[] toAddresses = new String[]{'renan.mastropaolo@qintess.com', 'NocVendAleloTlv@ATENTO.com.br','sidney.coutinho@qintess.com'};
		emailMessage.setSubject( 'Relatório Olos');
		emailMessage.setToAddresses( toAddresses );
		emailMessage.setPlainTextBody( 'Segue arquivo em anexo.');
		emailMessage.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
		emailMessage.setOrgWideEmailAddressId(lista.get(0).Id);

		return Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
	}

	global class WrapperClass{
		@InvocableVariable
		global Id IdSF;
		@InvocableVariable
		global String CNPJ;

		private String NewIdOlos;

		@InvocableVariable
		global String CAMPANHA;
		@InvocableVariable
		global String NAME;
		@InvocableVariable
		global String PHONE;
		@InvocableVariable
		global String PHONE2;
		@InvocableVariable
		global String PHONE3;
		@InvocableVariable
		global String PHONE4;
		@InvocableVariable
		global String PHONE5;
		@InvocableVariable
		global String CORINGA_1;
		@InvocableVariable
		global String CORINGA_2;
		@InvocableVariable
		global String CORINGA_3;
		@InvocableVariable
		global String CORINGA_4;
		@InvocableVariable
		global String CORINGA_5;

		public String getNewIDOlos() {
			return String.valueOf(IdSF).toLowerCase()+CNPJ;
		}
	}

}
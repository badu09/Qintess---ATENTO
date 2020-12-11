global class GerarCsvFilasM{

	global static void enviarCSVEmail(List<PedidoFila> request){
		List<String> corpo = montarListaCorpo(request);
		System.debug('====ENVIAR TXT OLOS REQUEST====');
		System.debug(JSON.serialize(request));
		System.debug('===============================');

		Messaging.SendEmailResult[] result = enviarEmail(corpo);

		System.debug(result.get(0));

	}

	private static List<String> montarListaCorpo(List<PedidoFila> request){
		List<String> corpo = new List<String>();
		for (PedidoFila wc : request){
			StringBuilder sb = new StringBuilder();

			sb.adicionar('"'+wc.idPedido+'"'+',');
			sb.adicionar('"'+wc.idFila+'"');
			String linha = sb.getString()+'\n';
			corpo.add(linha);
		}

		return corpo;
	}

	private static String retornaNomeArquivo(){
		return Datetime.now().format('ddMMyyyy_hh_mm')+'.csv';
	}

	private static Blob criarCorpoArquivo(List<String> registros){

		StringBuilder sb = new StringBuilder();
		String header = '"Id","OwnerId"';
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
		efa.setFileName(retornaNomeArquivo());
		efa.setBody(b);

		List<OrgWideEmailAddress> lista = DAOOrgWideEmailAddress.getEmailAddressByName('CSVFilasM');

		String[] toAddresses = new String[]{'renan.mastropaolo@qintess.com','sidney.coutinho@qintess.com'};
		emailMessage.setSubject( 'Relatório Olos');
		emailMessage.setToAddresses( toAddresses );
		emailMessage.setPlainTextBody( 'Segue arquivo em anexo.');
		emailMessage.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
		emailMessage.setOrgWideEmailAddressId(lista.get(0).Id);

		return Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
	}

	global class PedidoFila{
		public PedidoFila(Id idPedido, Id idFila) {
			this.idPedido = idPedido;
			this.idFila = idFila;
		}

		public Id idPedido;
		public Id idFila;
	}

}
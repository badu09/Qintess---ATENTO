public with sharing class CtrlConsultaCliente {
	
	public String cnpjCpf {get; set;}
	public String contrato {get; set;}
	public String razaoSocial {get; set;}
	
	public Boolean pesquisou { get; set; }
	
	public List<Opportunity> listaPrincipal { get; set; } 
	
	public CtrlConsultaCliente() {
		init();
	} 
	
	private void init() {
		pesquisou = false;
		cnpjCpf = null;
		contrato = null;
		razaoSocial = null;
		listaPrincipal = null;
	}
	
	public void cancelar() {
		init();
	}
	
	public void consultar() {
		listaPrincipal = new List<Opportunity>();
		List<Produtos_Alelo__c> listaProdutos;
		Set<String> idOportunidades;
		cnpjCPF = cnpjCPF != null ? cnpjCPF.replaceAll(' |\\D', '') : null;
		if((contrato == null || contrato == '')
				&& (cnpjCPf == null || cnpjCPf == '')
				&& (razaoSocial == null || razaoSocial == '')) {
			ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Por favor, preencha ao menos um dos campos.'));
			return;
		}
		
		if(cnpjCPF != null && cnpjCPF != '') {
			if(!validarCNPJ(cnpjCPF)) {
				ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Dígito verificador do CNPJ inválido.'));
				return;
			}
		}
		
		if(contrato != null && contrato != '') {
			System.debug('contrato: ' + contrato);
			idOportunidades = new Set<String>();
			listaProdutos = DAOProdutosAlelo.getProductByContract(contrato);
			System.debug('listaProdutos: ' + JSON.serialize(listaProdutos));
			for(Produtos_Alelo__c prod : listaProdutos) {
				idOportunidades.add(prod.Oportunidade__c);
			}
			System.debug('idOportunidades: ' + JSON.serialize(idOportunidades));
			
			if(idOportunidades == null || idOportunidades.size() == 0)
				return;
		}
		
		this.listaPrincipal = DAOOpportunity.getOpportunityFromConsultaCliente(cnpjCPf, razaoSocial, idOportunidades);
		pesquisou = true;
	}
	
	public static Boolean validarCNPJ(String cnpj){
		cnpj = cnpj.replace('.','');
		cnpj = cnpj.replace('/','');
		cnpj = cnpj.replace('-','');
		cnpj = cnpj.leftPad(15).replace(' ', '0');
		String numeros = '';
		String digitos = '';
		Integer soma = 0;
		Integer resultado = 0;
		Integer pos = 0;
		Integer tamanho = 0;
		system.debug(cnpj);
		system.debug(cnpj.length());
		Boolean digitosIguais = Pattern.matches('00000000000000|11111111111111|22222222222222|33333333333333|'
			+'44444444444444|55555555555555|66666666666666|'
			+'77777777777777|88888888888888|99999999999999',cnpj);
		if (cnpj.length() < 15 && digitosIguais){
			return false;
		}
		tamanho = cnpj.length() - 2;
		numeros = cnpj.substring(0,tamanho);
		digitos = cnpj.substring(tamanho);
		soma = 0;
		pos = tamanho - 7;
		for (Integer i = tamanho; i >= 1; i--){
			soma += Integer.valueOf(numeros.substring(tamanho - i,tamanho - i + 1)) * pos--;
			if (pos < 2){
				pos = 9;
			}
		}
		resultado = Math.mod(soma, 11) < 2 ? 0 : 11 - Math.mod(soma, 11);
		if (resultado != Integer.valueOf(digitos.substring(0,1))){
			return false;
		}
		tamanho = tamanho + 1;
		numeros = cnpj.substring(0,tamanho);
		soma = 0;
		pos = tamanho - 7;
		for (Integer i = tamanho; i >= 1; i--){
			soma += Integer.valueOf(numeros.substring(tamanho - i, tamanho - i + 1)) * pos--;
			if (pos < 2){
				pos = 9;
			}
		}
		resultado = Math.mod(soma, 11)< 2 ? 0 : 11 - Math.mod(soma, 11);
		if (resultado != Integer.valueOf(digitos.substring(1))){
			return false;
		}
		return true;
	}
}
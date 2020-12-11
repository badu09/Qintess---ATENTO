public class CtrlDesdobramentoMetas {
	public String nomeDesdobramento { get; set; }
	public String area { get; set; }
	public List<DesdobramentoWrapper> desdobramentos { get; set; }
	public String mensagem { get; set; }
	public Id idDesdobramentoMeta { get; set; }

	public CtrlDesdobramentoMetas(ApexPages.StandardController standardController) {
		setDesdobramentos(DAODesdobramento.getAll());
	}

	public void setDesdobramentos(List<Desdobramento__c> lista) {
		desdobramentos = new List<DesdobramentoWrapper>();
		if (lista != null && !lista.isEmpty()) {
			for (Desdobramento__c d : lista) {
				desdobramentos.add(new DesdobramentoWrapper(d));
			}
		}
		desdobramentos.sort();
	}

	public List<SelectOption> getAreas() {
		List<SelectOption> retorno = new List<SelectOption>();
		retorno.add(new SelectOption('', 'Selecione uma área'));
		Schema.DescribeFieldResult fieldResult = Desdobramento__c.Area__c.getDescribe();
		List<Schema.PicklistEntry> areas = fieldResult.getPicklistValues();
		for (Schema.PicklistEntry p : areas) {
			retorno.add(new SelectOption(p.getValue(), p.getValue()));
		}
		return retorno;
	}

	public void salvar() {
		this.idDesdobramentoMeta = null;
		
		if (nomeDesdobramento != null && nomeDesdobramento != '' && area != null && area != '') {
			Desdobramento__c objDesdobramento =  new Desdobramento__c();
			objDesdobramento.Name = nomeDesdobramento;
			objDesdobramento.Area__c = area;
			objDesdobramento.Ativo__c = true;
			insert objDesdobramento;
			
			//insert new Desdobramento__c(Name = nomeDesdobramento, Area__c = area, Ativo__c = true);
			limpar();
			setDesdobramentos(DAODesdobramento.getAll());
			this.idDesdobramentoMeta = objDesdobramento.Id;
			//this.redirectVincularUsuario();
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Desdobramento salvo com sucesso.'));
		} else {
			ApexPages.addMessage(
			new ApexPages.Message(ApexPages.Severity.WARNING, 'Por favor, preencha todos os campos.'));
		}
	}

	public void limpar() {
		nomeDesdobramento = '';
		area = '';
	}
	
	public PageReference redirectVincularUsuario() {
    	
    	PageReference pageReference = Page.DesdobramentoMetaUsuario;
	    	
    	pageReference.getParameters().put('idDesdobramentoMeta', this.idDesdobramentoMeta);
    	pageReference.setRedirect(true);
    	
    	return pageReference;
    }

	public class DesdobramentoWrapper implements Comparable {
		public Desdobramento__c desdobramento { get; set; }

		public DesdobramentoWrapper(Desdobramento__c desdobramento) {
			this.desdobramento = desdobramento;
		}

		public void inativar() {
			this.desdobramento.Ativo__c = false;
			update this.desdobramento;
		}

		public void reativar() {
			this.desdobramento.Ativo__c = true;
			update this.desdobramento;
		}

		public Integer compareTo(Object o) {
			if (o instanceof Desdobramento__c) {
				if (this.desdobramento.CreatedDate > ((Desdobramento__c) o).CreatedDate) return 1;
				else if (this.desdobramento.CreatedDate < ((Desdobramento__c) o).CreatedDate) return -1;
				else return 0;
			} else if (o instanceof DesdobramentoWrapper) {
				if (this.desdobramento.CreatedDate > ((DesdobramentoWrapper) o).desdobramento.CreatedDate) return 1;
				else if (
				this.desdobramento.CreatedDate < ((DesdobramentoWrapper) o).desdobramento.CreatedDate) return -1;
				else return 0;
			} else {
				return 0;
			}
		}
	}
}
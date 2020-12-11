public class CtrlGlobalSearchOpportunity {
	private Opportunity oportunidade { get; set; }
	public Boolean ocorreuErro { get; set; }
	public CtrlProcessoPedido.RetornoModel model { get; set; }
	public Boolean bloqueiaAba { get; set; }
	public String toRedirect { get; set; }

	public CtrlGlobalSearchOpportunity(ApexPages.StandardController controller) {
		oportunidade = (Opportunity) controller.getRecord();
		ocorreuErro = false;
		model = new CtrlProcessoPedido.RetornoModel();
		bloqueiaAba = false;
		toRedirect = '';

	}

	public void encaminhar() {
		String url = ApexPages.currentPage().getURL();
		RecordType tipoRegistro = DAORecordType.obterPorId(oportunidade.RecordTypeId, 'Opportunity');
		if(tipoRegistro != null && tipoRegistro.DeveloperName.containsIgnoreCase('implantacao')) {
			Profile perfil = DAOProfile.getProfileById(UserInfo.getProfileId());
			if(perfil != null && (perfil.Name.containsIgnoreCase('implantacao') || perfil.Name.containsIgnoreCase('implantação'))) {
				List<Order> lPedido = DAOOrder.getOrderByOpportunityId(oportunidade.Id);
				if(lPedido != null && !lPedido.isEmpty()) {
					model = CtrlProcessoPedido.implantar(lPedido[0].Id, oportunidade.Id);
					if(!model.sucesso) {
						ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, model.mensagemErro));
						ocorreuErro = true;
					}
					else {
						bloqueiaAba = true;
						if(url.containsIgnoreCase('cancelURL') || url.containsIgnoreCase('retURL')) toRedirect = '/' + oportunidade.Id + '/e?nooverride=1';
						else toRedirect = '/' + oportunidade.Id + '?nooverride=1';
					}
				}
				else {
					ocorreuErro = true;
					model.mensagemErro = 'Não existe pedido para essa oportunidade';
				}
			}
			else {
				if(url.containsIgnoreCase('cancelURL') || url.containsIgnoreCase('retURL')) toRedirect = '/' + oportunidade.Id + '/e?nooverride=1';
				else toRedirect = '/' + oportunidade.Id + '?nooverride=1';
			}
		}
		else {
			if(url.containsIgnoreCase('cancelURL') || url.containsIgnoreCase('retURL')) toRedirect = '/' + oportunidade.Id + '/e?nooverride=1';
			else toRedirect = '/' + oportunidade.Id + '?nooverride=1';
		}
	}
}
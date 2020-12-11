public with sharing class ReverterImplantacaoProcCadastral
{

	@InvocableMethod(label='Reverter Implantacao Processo Cadastral' description='Reverter Implantação do Produto e Oportunidade Relacionada')
	public static void reverterImplantacao(List<Id> lId) 
    {
		if(lId != null) 
        {
			Set<Id> setId = new Set<Id>(lId);

			ReverterImplantacaoGeral.executar(setId, 'PROCESSO CADASTRAL');
		}
	}

}
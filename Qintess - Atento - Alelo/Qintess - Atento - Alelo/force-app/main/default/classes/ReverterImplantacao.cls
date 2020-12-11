public with sharing class ReverterImplantacao 
{

	@InvocableMethod(label='Reverter Implantacao' description='Reverter Implantação do Produto e Oportunidade Relacionada')
	public static void reverterImplantacao(List<Id> lId) 
    {
		if(lId != null) 
        {
			Set<Id> setId = new Set<Id>(lId);

			ReverterImplantacaoGeral.executar(setId, 'REALIZOU PEDIDO DE CARTÃO');
		}
	}

}
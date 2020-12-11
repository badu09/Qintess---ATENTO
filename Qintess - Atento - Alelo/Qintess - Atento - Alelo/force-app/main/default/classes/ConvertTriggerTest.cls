@isTest
private class ConvertTriggerTest {

	@isTest
	static void teste(){

		Lead l = new Lead();
		l.CNPJ__c = '00876514000105';
		l.Company = 'Teste';
		l.LastName = 'Teste';
		l.DDD__c = 11.0;
		l.Phone = '21212121';
		l.Codigo_Banco__c = '237';
		l.RecordTypeId = DAORecordType.obterPorDeveloperName('Banco','Lead').Id;

		insert l;

		l.Status = 'INDICAÇÃO ATUALIZADA (007)';
		l.LastName = 'Teste2';

		update l;

	}

}
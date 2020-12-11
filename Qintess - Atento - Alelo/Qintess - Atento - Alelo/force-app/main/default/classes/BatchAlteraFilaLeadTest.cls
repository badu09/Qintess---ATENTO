@IsTest
public class BatchAlteraFilaLeadTest {

	@TestSetup
	static void setup(){
		Lead l = new Lead();
		l.CNPJ__c = '00876514000105';
		l.Company = 'Teste';
		l.LastName = 'Teste';
		l.DDD__c = 11.0;
		l.Phone = '21212121';
		l.Codigo_Banco__c = '237';
		l.RecordTypeId = DAORecordType.obterPorDeveloperName('Banco','Lead').Id;

		insert l;
	}

	@IsTest
	static void test_method_one(){
		Test.startTest();
		BatchAlteraFilaLead batchAlteraFilaLead = new BatchAlteraFilaLead(0);
		Database.executeBatch(batchAlteraFilaLead);
		Test.stopTest();
	}
}
/**
 * Created by Leandro on 16/08/2018.
 */
@IsTest
public class TestScheduleExpurgoAtento {

	@IsTest
	static void test1_ScheduleExpurgoAtento() {

		String CRON_EXP = '0 0 0 * * ?';

		Test.startTest();

		String JobId = System.schedule('TestScheduleExpurgoAtento', CRON_EXP, new ScheduleExpurgoAtento());

		Test.stopTest();

	}

	@IsTest(SeeAllData=true)
	static void test2_Batch_TesteObjetoFilho() {

		String purgeModelStr = '{"Id":"m00W00000004QEqIAM","NomeAPI__c":"Account","NomeProcesso__c":"Expurgo de Contas TESTE","PeriodoExpurgo__c":0,"ExpurgarObjetoFilho__c":true,"NomeArquivoCSV__c":"Contas","DeveloperName":"ExpurgoContas","OrdemExecucao__c":1,"HorarioExecucao__c":5,"NomeAPIObjetoFilho__c":"Contact","NomeRelacionamento__c":"Contacts"}';

		Expurgo__mdt purge = (Expurgo__mdt) JSON.deserialize( purgeModelStr, Expurgo__mdt.class );

		Test.startTest();

				BatchExpurgoAtento batch = new BatchExpurgoAtento(purge);

				System.scheduleBatch(batch, purge.NomeProcesso__c, BOExpurgo.getInstance().getMinutesFromNow(purge.HorarioExecucao__c));

		Test.stopTest();

	}

	@IsTest(SeeAllData=true)
	static void test3_Batch_TesteArquivoDeErro() {

		List<Expurgo__mdt> dados = BOExpurgo.getInstance().getDataExpurgo();

		for (Expurgo__mdt purge : dados) {

			if(purge.DeveloperName == 'ExpurgoLead') {

				Test.startTest();

				BatchExpurgoAtento batch = new BatchExpurgoAtento(purge);

				System.scheduleBatch(batch, purge.NomeProcesso__c, 1);

				Test.stopTest();

			}
		}
	}

}
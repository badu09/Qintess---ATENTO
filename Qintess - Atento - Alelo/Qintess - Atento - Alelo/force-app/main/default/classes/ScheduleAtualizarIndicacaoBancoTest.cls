@isTest
public class ScheduleAtualizarIndicacaoBancoTest {
    
    @TestSetup
    static void setup(){
        Lead l = new Lead();
        l.CNPJ__c = '12075496000141';
        l.Company = 'Teste';
        l.LastName = 'Teste';
        l.DDD__c = 11.0;
        l.Phone = '21212121';
        l.Codigo_Banco__c = '237';
        l.Chave_Banco__c = 'TESTE_CHAVE';
        l.Status = 'TESTE';
        l.Atualizacao_Bancos__c = false;
        l.Isconverted = false;
        l.RecordTypeId = DAORecordType.obterPorDeveloperName('Banco','Lead').Id;
        insert l;
        
        Lead l1 = new Lead();
        l1.CNPJ__c = '95950993000179';
        l1.Company = 'Teste';
        l1.LastName = 'Teste';
        l1.DDD__c = 11.0;
        l1.Phone = '21212121';
        l1.Chave_Banco__c = 'TESTE_CHAVE1';
        l1.Codigo_Banco__c = '33';
        l1.Status = 'TESTE';
        l1.Atualizacao_Bancos__c = false;
        l1.Isconverted = false;
        l1.RecordTypeId = DAORecordType.obterPorDeveloperName('Banco','Lead').Id;
        insert l1;
        
        Lead l2 = new Lead();
        l2.CNPJ__c = '07150329000188';
        l2.Company = 'Teste';
        l2.LastName = 'Teste';
        l2.DDD__c = 11.0;
        l2.Phone = '21212121';
        l2.Chave_Banco__c = 'TESTE_CHAVE2';
        l2.Codigo_Banco__c = '1';
        l2.Status = 'TESTE';
        l2.Atualizacao_Bancos__c = false;
        l2.Isconverted = false;
        l2.RecordTypeId = DAORecordType.obterPorDeveloperName('Banco','Lead').Id;
        insert l2;
        
        Account acc = new Account();
        acc.Name = 'Conta teste';
        acc.CPF_CNPJ__c = '55384786000180';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opportunity';
        opp.StageName ='Teste';
        opp.CloseDate = date.valueOf(system.now());
        opp.Codigo_Indicacao__c = '1';
        opp.Status_Retorno_Banco__c = 201;
        opp.Atualizacao_Bancos__c = false;
        opp.Codigo_do_Banco__c = '33';
        opp.AccountId = acc.Id;
        insert opp;
		
        opp.Motivo_Retorno_Banco__c = 200;
		update opp;
        
        Opportunity opp2 = new Opportunity();
        opp2.Name = 'Test Opportunity1';
        opp2.StageName ='Teste1';
        opp2.CloseDate = date.valueOf(system.now());
        opp2.Codigo_Indicacao__c = '2';
        opp2.Status_Retorno_Banco__c = 201;
        opp2.Atualizacao_Bancos__c = false;
        opp2.Codigo_do_Banco__c = '1';
        opp2.AccountId = acc.Id;
        insert opp2;
		
        opp2.Motivo_Retorno_Banco__c = 200;
		update opp2;
        
        Opportunity opp3 = new Opportunity();
        opp3.Name = 'Test Opportunity2';
        opp3.StageName ='Teste2';
        opp3.CloseDate = date.valueOf(system.now());
        opp3.Codigo_Indicacao__c = '3';
        opp3.Status_Retorno_Banco__c = 201;
        opp3.Atualizacao_Bancos__c = false;
        opp3.Codigo_do_Banco__c = '237';
        opp3.AccountId = acc.Id;
        insert opp3;
		
        opp3.Motivo_Retorno_Banco__c = 200;
		update opp3;
        
        Produtos_Alelo__c produtoAlelo = new Produtos_Alelo__c(Codigo_de_Produtos__c = '300', Forma_de_Pagamento__c = 'CARTAO CREDITO', Oportunidade__c = opp.Id, Valor_Unitario__c = 100.0, Quantidade_de_Cartoes__c = 10.0);
        insert produtoAlelo;
        
        List<Opportunity> listOpp = [SELECT Id, Name, StageName, CloseDate, Codigo_Indicacao__c,
                                     Status_Retorno_Banco__c, Motivo_Retorno_Banco__c, Atualizacao_Bancos__c,
                                     Codigo_do_Banco__c, AccountId FROM Opportunity Limit 2];
        for(Opportunity oppt : listOpp){
            System.debug('Codigo_Indicacao__c: ' + oppt.Codigo_Indicacao__c);
            System.debug('Status_Retorno_Banco__c: ' + oppt.Status_Retorno_Banco__c);
            System.debug('Motivo_Retorno_Banco__c: ' +oppt.Motivo_Retorno_Banco__c);
            System.debug('Atualizacao_Bancos__c: ' +oppt.Atualizacao_Bancos__c);
            System.debug('Codigo_do_Banco__c: ' + oppt.Codigo_do_Banco__c);
        }
        System.debug('LISTAA: ' + listOpp);
    }
    
    @IsTest
    static void test_method_one(){
        Test.startTest();
        //Schedule
        //String jobId = System.schedule('ScheduleAtualizarIndicacaoBanco', ScheduleAtualizarIndicacaoBanco.CRON_EXP, new ScheduleAtualizarIndicacaoBanco());
        //CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        
        //System.assertEquals(ScheduleAtualizarIndicacaoBanco.CRON_EXP, ct.CronExpression);
        //System.assertEquals(0, ct.TimesTriggered);
        
        //BatchAtualizarIndicacaoLead
        //BatchAtualizarIndicacaoLead batch = new BatchAtualizarIndicacaoLead(1, 33, 237);
        //Database.executeBatch(batch);
        
        //BatchAtualizarIndicacaoOpportunity
        //BatchAtualizarIndicacaoOpportunity batchOpp = new BatchAtualizarIndicacaoOpportunity(1, 33, 237);
        //Database.executeBatch(batchOpp);
        //ScheduleAtualizarIndicacaoBanco.scheduleIt(30, 0);
        Test.stopTest();
    }
}
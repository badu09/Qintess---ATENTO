global class ScheduleAtualizarIndicacaoBanco Implements Schedulable {

    public static String CRON_EXP = '0 {0} {1} ? * *';
    private static Integer addMinutes {get; set;}
    
    global static String scheduleIt(Integer minutes, Integer minutesGap) {   
    	System.debug('Inicío: ScheduleAtualizarIndicacaoBanco');
    	
        ScheduleAtualizarIndicacaoBanco scheduleAtualizarIndicacaoBanco = new ScheduleAtualizarIndicacaoBanco();
        addMinutes = minutes;
        String jobName = 'Atualizar Indicação Bancos';
        Datetime nextScheduleTime = system.now().addMinutes(addMinutes + minutesGap);
    	string strMinutes = string.valueof(nextScheduleTime.minute());     
        string strHours = String.valueOf(nextScheduleTime.hour());
    	CRON_EXP = String.format(CRON_EXP, new List<String>{strMinutes,strHours});
    	
        return System.schedule(jobName, CRON_EXP, scheduleAtualizarIndicacaoBanco);
    }
    
    global void execute(SchedulableContext ctx){
       	atualizarIndicacao();
       	system.abortJob(ctx.getTriggerId());
       	System.debug('Fim: ScheduleAtualizarIndicacaoBanco');
       	scheduleIt(15, 0);
    }
    
    public static void atualizarIndicacao()
    {
    	try{    		
    		//Batches
    		Id idBatchAtualizarIndicacaoOpp = Database.executeBatch(new BatchAtualizarIndicacaoOpportunity(1, 33, 237), 50);
    		Id idBatchAtualizarIndicacaoLead = Database.executeBatch(new BatchAtualizarIndicacaoLead(1, 33, 237), 50);

			system.debug('idBatchAtualizarIndicacaoOpp: ' + idBatchAtualizarIndicacaoOpp);
			system.debug('idBatchAtualizarIndicacaoLead: ' + idBatchAtualizarIndicacaoLead);
			
    	}catch(Exception ex) {
			System.debug('Exception: ' + ex.getStackTraceString() + ' - Message: ' + ex.getMessage());
        }
    }
    
}
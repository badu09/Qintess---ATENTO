global class ScheduleAtualizarIndicacaoSantander Implements Schedulable {
    //public static String CRON_EXP = '0 24 18 * * ?';
    public static String CRON_EXP = '0 {0} {1} ? * *';
    private static Integer addMinutes {get; set;}
    
    global static String scheduleIt(Integer minutes, Integer minutesGap) {   
    	System.debug('Inicío: scheduleAtualizarIndicacaoSantander');
    	
        ScheduleAtualizarIndicacaoSantander scheduleAtualizarIndicacaoSantander = new ScheduleAtualizarIndicacaoSantander();
        addMinutes = minutes;
        String jobName = 'Atualizar Indicação Santander';
        Datetime nextScheduleTime = system.now().addMinutes(addMinutes + minutesGap);
    	string strMinutes = string.valueof(nextScheduleTime.minute());     
        string strHours = String.valueOf(nextScheduleTime.hour());
    	CRON_EXP = String.format(CRON_EXP, new List<String>{strMinutes,strHours});
    	
        return System.schedule(jobName, CRON_EXP, scheduleAtualizarIndicacaoSantander);
    }
    
    global void execute(SchedulableContext ctx){
       	atualizarIndicacao();
       	system.abortJob(ctx.getTriggerId());
       	System.debug('Fim: scheduleAtualizarIndicacaoSantander');
       	//scheduleIt(15, 0);
    }
    
    public static void atualizarIndicacao()
    {
    	try{
    		//BOLead.atualizarIndicacaoSantander();
    		/*Id idBatchAtualizarIndicacaoSantanderOpp = Database.executeBatch(new BatchAtualizarIndicacaoOpportunity(33), 50);
    		Id idBatchAtualizarIndicacaoSantanderLead = Database.executeBatch(new BatchAtualizarIndicacaoLead(33), 50);

			system.debug('idBatchAtualizarIndicacaoSantanderOpp: ' + idBatchAtualizarIndicacaoSantanderOpp);
			system.debug('idBatchAtualizarIndicacaoSantanderLead: ' + idBatchAtualizarIndicacaoSantanderLead);*/
			
    	}catch(Exception ex) {
			System.debug('Exception: ' + ex.getStackTraceString() + ' - Message: ' + ex.getMessage());
        }
    }
}
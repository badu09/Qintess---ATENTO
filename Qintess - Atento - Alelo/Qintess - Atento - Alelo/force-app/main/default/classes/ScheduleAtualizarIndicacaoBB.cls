global class ScheduleAtualizarIndicacaoBB Implements Schedulable {
    //public static String CRON_EXP = '0 24 18 * * ?';
    public static String CRON_EXP = '0 {0} {1} ? * *';
    private static Integer addMinutes {get; set;}
    
    global static String scheduleIt(Integer minutes, Integer minutesGap) {   
    	System.debug('Inicío: ScheduleAtualizarIndicacaoBB');
    	
        ScheduleAtualizarIndicacaoBB scheduleAtualizarIndicacaoBB = new ScheduleAtualizarIndicacaoBB();
        addMinutes = minutes;
        String jobName = 'Atualizar Indicação BB';
        Datetime nextScheduleTime = system.now().addMinutes(addMinutes + minutesGap);
    	string strMinutes = string.valueof(nextScheduleTime.minute());     
        string strHours = String.valueOf(nextScheduleTime.hour());
    	CRON_EXP = String.format(CRON_EXP, new List<String>{strMinutes,strHours});
    	
        return System.schedule(jobName, CRON_EXP, scheduleAtualizarIndicacaoBB);
    }
    
    global void execute(SchedulableContext ctx){
       	atualizarIndicacao();
       	system.abortJob(ctx.getTriggerId());
       	System.debug('Fim: ScheduleAtualizarIndicacaoBB');
       	scheduleIt(15, 0);
    }
    
    public static void atualizarIndicacao()
    {
    	try{
    		//BOLead.atualizarIndicacaoBB();
    		/*Id idBatchAtualizarIndicacaoBBOpp = Database.executeBatch(new BatchAtualizarIndicacaoOpportunity(1), 50);
    		Id idBatchAtualizarIndicacaoBBLead = Database.executeBatch(new BatchAtualizarIndicacaoLead(1), 50);

			system.debug('idBatchAtualizarIndicacaoBBOpp: ' + idBatchAtualizarIndicacaoBBOpp);
			system.debug('idBatchAtualizarIndicacaoBBLead: ' + idBatchAtualizarIndicacaoBBLead);*/
			
    	}catch(Exception ex) {
			System.debug('Exception: ' + ex.getStackTraceString() + ' - Message: ' + ex.getMessage());
        }
    }
}
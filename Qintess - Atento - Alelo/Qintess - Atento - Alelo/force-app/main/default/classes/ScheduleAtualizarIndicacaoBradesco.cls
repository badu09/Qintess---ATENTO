global class ScheduleAtualizarIndicacaoBradesco Implements Schedulable {
    //public static String CRON_EXP = '0 24 18 * * ?';
    public static String CRON_EXP = '0 {0} {1} ? * *';
    private static Integer addMinutes {get; set;}
    
    global static String scheduleIt(Integer minutes, Integer minutesGap) {   
    	System.debug('Inicío: ScheduleAtualizarIndicacaoBradesco');
    	
        ScheduleAtualizarIndicacaoBradesco scheduleAtualizarIndicacaoBradesco = new ScheduleAtualizarIndicacaoBradesco();
        addMinutes = minutes;
        String jobName = 'Atualizar Indicação Bradesco';
        Datetime nextScheduleTime = system.now().addMinutes(addMinutes + minutesGap);
    	string strMinutes = string.valueof(nextScheduleTime.minute());     
        string strHours = String.valueOf(nextScheduleTime.hour());
    	CRON_EXP = String.format(CRON_EXP, new List<String>{strMinutes,strHours});
    	
        return System.schedule(jobName, CRON_EXP, scheduleAtualizarIndicacaoBradesco);
    }
    
    global void execute(SchedulableContext ctx){
       	atualizarIndicacao();
       	system.abortJob(ctx.getTriggerId());
       	System.debug('Fim: ScheduleAtualizarIndicacaoBradesco');
       	//scheduleIt(15, 0);
    }
    
    public static void atualizarIndicacao()
    {
    	try{
    		//BOLead.atualizarIndicacaoBradesco();
    		//Id idBatchAtualizarIndicacaoBradescoOpp = Database.executeBatch(new BatchAtualizarIndicacaoOpportunity(237), 50);
    		//Id idBatchAtualizarIndicacaoBradescoLead = Database.executeBatch(new BatchAtualizarIndicacaoLead(237), 50);

			//system.debug('idBatchAtualizarIndicacaoBradescoOpp: ' + idBatchAtualizarIndicacaoBradescoOpp);
			//system.debug('idBatchAtualizarIndicacaoBradescoLead: ' + idBatchAtualizarIndicacaoBradescoLead);
			
    	}catch(Exception ex) {
			System.debug('Exception: ' + ex.getStackTraceString() + ' - Message: ' + ex.getMessage());
        }
    }
}
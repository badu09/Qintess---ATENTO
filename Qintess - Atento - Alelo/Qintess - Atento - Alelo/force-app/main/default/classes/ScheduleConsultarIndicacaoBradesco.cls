global class ScheduleConsultarIndicacaoBradesco Implements Schedulable {
    //public static String CRON_EXP = '0 22 18 * * ?';
    public static String CRON_EXP = '0 {0} {1} ? * *';
    private static Integer addMinutes {get; set;}
    
    global static String scheduleIt(Integer minutes, Integer minutesGap) {  
    	System.debug('Inicío: ScheduleConsultarIndicacaoBradeco');
    	
    	ScheduleConsultarIndicacaoBradesco scheduleConsultarIndicacaoBradesco = new ScheduleConsultarIndicacaoBradesco();
        String jobName = 'Consultar Indicação Bradesco';
    	addMinutes = minutes;
        Datetime nextScheduleTime = system.now().addMinutes(addMinutes + minutesGap);
    	string strMinutes = string.valueof(nextScheduleTime.minute());     
        string strHours = String.valueOf(nextScheduleTime.hour());
    	CRON_EXP = String.format(CRON_EXP, new List<String>{strMinutes,strHours});

        return System.schedule(jobName, CRON_EXP, scheduleConsultarIndicacaoBradesco);
    }
    
    global void execute(SchedulableContext ctx){
       	consultarIndicacao();
       	system.abortJob(ctx.getTriggerId());
       	System.debug('Fim: ScheduleConsultarIndicacaoBradeco');
       	scheduleIt(15, 0);
    }
    
    @future(callout=true)
    public static void consultarIndicacao()
    {
    	try{
    		BOLead.consultarIndicacaoBradesco();
    	}catch(Exception ex) {
			System.debug('Exception: ' + ex.getStackTraceString() + ' - Message: ' + ex.getMessage());
        }
    }
}
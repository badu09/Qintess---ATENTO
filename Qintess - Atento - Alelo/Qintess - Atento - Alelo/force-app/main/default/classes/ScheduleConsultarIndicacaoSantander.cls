global class ScheduleConsultarIndicacaoSantander Implements Schedulable {
    //public static String CRON_EXP = '0 24 18 * * ?';
    public static String CRON_EXP = '0 {0} {1} ? * *';
    private static Integer addMinutes {get; set;}
    
    global static String scheduleIt(Integer minutes, Integer minutesGap) {   
    	System.debug('Inicío: scheduleConsultarIndicacaoSantander'); 
    	
        ScheduleConsultarIndicacaoSantander scheduleConsultarIndicacaoSantander = new ScheduleConsultarIndicacaoSantander();
        String jobName = 'Consultar Indicação Santander';
        addMinutes = minutes;
        Datetime nextScheduleTime = system.now().addMinutes(addMinutes + minutesGap);
    	string strMinutes = string.valueof(nextScheduleTime.minute());     
        string strHours = String.valueOf(nextScheduleTime.hour());
    	CRON_EXP = String.format(CRON_EXP, new List<String>{strMinutes,strHours});
    	
        return System.schedule(jobName, CRON_EXP, scheduleConsultarIndicacaoSantander);
    }
    
    global void execute(SchedulableContext ctx){
       	consultarIndicacao();
       	system.abortJob(ctx.getTriggerId());
       	System.debug('Fim: scheduleConsultarIndicacaoSantander');
       	scheduleIt(15, 0);
    }
    
    @future(callout=true)
    public static void consultarIndicacao()
    {
    	try{
    		BOLead.consultarIndicacaoSantander();
    	}catch(Exception ex) {
			System.debug('Exception: ' + ex.getStackTraceString() + ' - Message: ' + ex.getMessage());
        }
    }
}
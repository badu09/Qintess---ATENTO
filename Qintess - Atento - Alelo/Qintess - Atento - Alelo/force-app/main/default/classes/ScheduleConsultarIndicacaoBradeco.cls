global class ScheduleConsultarIndicacaoBradeco Implements Schedulable {
    public static String CRON_EXP = '0 22 18 * * ?';
    
    global static String scheduleIt() {   
    	System.debug('Inicío: ScheduleConsultarIndicacaoBradeco'); 
        ScheduleConsultarIndicacaoBradeco scheduleConsultarIndicacaoBradesco = new ScheduleConsultarIndicacaoBradeco();
        String jobName = 'Consultar Indicação Bradesco'; 
        
        return System.schedule(jobName, CRON_EXP, scheduleConsultarIndicacaoBradesco);
    }
    
    global void execute(SchedulableContext ctx){
       	consultarIndicacao();
       	system.abortJob(ctx.getTriggerId());
       	System.debug('Fim: ScheduleConsultarIndicacaoBradeco'); 
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
global class ScheduleConsultarIndicacao Implements Schedulable {
    
    public static String CRON_EXP = '0 1 * * * ?';
    private static Integer minuto = 0;
    
    global static void scheduleIt() {   
    	System.debug('Passou 1'); 
        ScheduleConsultarIndicacao scheduleConsultarIndicacao = new ScheduleConsultarIndicacao();
        System.debug('Passou 2');
        
        for(Integer i = 0; i <= 11; i++){
        	minuto = (i*5);
        	System.debug('Lead Consultar Indicação ' + minuto);
        	System.schedule('Lead Consultar Indicação ' + minuto, '0 ' + minuto + ' * * * ?', scheduleConsultarIndicacao);
        }
    }
    
    global static String scheduleIt_OK() {   
    	System.debug('Passou 1'); 
        ScheduleConsultarIndicacao scheduleConsultarIndicacao = new ScheduleConsultarIndicacao();
        System.debug('Passou 2');
        
        return System.schedule('Lead Consultar Indicação', CRON_EXP, scheduleConsultarIndicacao);
    }
    
    global void execute(SchedulableContext ctx){
      	System.debug('Passou 4');
       	gerarLead(); 
       	System.debug('Passou 5');
    }
    
    public static void gerarLead()
    {
    	
    }
}
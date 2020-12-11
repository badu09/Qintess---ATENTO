global class ScheduleEstrategiaVencidas Implements Schedulable
{

    //Agendado de 1 em 1 hora (no intervalo entre 22h e 6h)
    public static String CRON_EXP = '0 0 22-06 ? * *';
     
    global static String scheduleIt() {  
    	 
        ScheduleEstrategiaVencidas scheduleEstrategiaVencidas = new ScheduleEstrategiaVencidas();
        
        string jobName = 'Estratégias Vencidas';
        if (Test.isRunningTest())
        {
            jobName = 'Estratégias Vencidas - Test';
        }
        
    	return System.schedule(jobName, CRON_EXP, scheduleEstrategiaVencidas);
    }  
     
    global void execute(SchedulableContext ctx){
        sincronizar();
    }
    
    public static void sincronizar() {  
        Id idBatchEstrategiaVencidas = Database.executeBatch(new BatchEstrategiaVencidas(), 20);

		system.debug('idBatchEstrategiaVencidas: ' + idBatchEstrategiaVencidas);
    }
    
}
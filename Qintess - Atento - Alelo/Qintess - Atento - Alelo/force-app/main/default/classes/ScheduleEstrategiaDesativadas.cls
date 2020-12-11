global class ScheduleEstrategiaDesativadas Implements Schedulable
{

    //Agendado de 1 em 1 hora (no intervalo entre 22h e 6h)
    public static String CRON_EXP = '0 0 22-06 ? * *';
     
    global static String scheduleIt() {  
    	 
        ScheduleEstrategiaDesativadas scheduleEstrategiaDesativadas = new ScheduleEstrategiaDesativadas();
        
        string jobName = 'Estratégias Desativadas';
        if (Test.isRunningTest())
        {
            jobName = 'Estratégias Desativadas - Test';
        }
        
    	return System.schedule(jobName, CRON_EXP, scheduleEstrategiaDesativadas);
    }  
     
    global void execute(SchedulableContext ctx){
        sincronizar();
    }
    
    public static void sincronizar() {  
        Id idBatchEstrategiaDesativadas = Database.executeBatch(new BatchEstrategiaDesativadas(), 20);

		system.debug('idBatchEstrategiaDesativadas: ' + idBatchEstrategiaDesativadas);
    }
    
}
global class ScheduleEstrategiaRenitencia implements Schedulable
{
    
    //Agendado de 1 em 1 hora (no intervalo entre 22h e 6h)
    public static String CRON_EXP = '0 0 22-06 ? * *';
     
    global static String scheduleIt() {  
    	 
        ScheduleEstrategiaRenitencia ScheduleEstrategiaRenitencia = new ScheduleEstrategiaRenitencia();
        
        string jobName = 'Estratégias Renitência';
        if (Test.isRunningTest())
        {
            jobName = 'Estratégias Renitência - Test';
        }
        
    	return System.schedule(jobName, CRON_EXP, ScheduleEstrategiaRenitencia);
    }  
     
    global void execute(SchedulableContext ctx){
        sincronizar();
    }
    
    public static void sincronizar() {  
        Id idBatchEstrategiaRenitencia = Database.executeBatch(new BatchEstrategiaRenitencia(), 20);

		system.debug('idBatchEstrategiaRenitencia: ' + idBatchEstrategiaRenitencia);
    }

}
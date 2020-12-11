global class ScheduleEstrategiaNaoProcessadas Implements Schedulable
{

    //Agendado de 1 em 1 hora
    public static String CRON_EXP = '0 0 22-06 ? * *';
     
    global static String scheduleIt() {  
    	 
        ScheduleEstrategiaNaoProcessadas scheduleEstrategiaNaoProcessadas = new ScheduleEstrategiaNaoProcessadas();
        
        string jobName = 'Estratégias Não Processadas';
        if (Test.isRunningTest())
        {
            jobName = 'Estratégias Não Processadas - Test';
        }
        
    	return System.schedule(jobName, CRON_EXP, scheduleEstrategiaNaoProcessadas);
    }  
     
    global void execute(SchedulableContext ctx){
        sincronizar();
    }
    
    public static void sincronizar() {  
        Id idBatchEstrategiaNaoProcessadas = Database.executeBatch(new BatchEstrategiaNaoProcessadas(), 20);

		system.debug('idBatchEstrategiaNaoProcessadas: ' + idBatchEstrategiaNaoProcessadas);
    }
    
}
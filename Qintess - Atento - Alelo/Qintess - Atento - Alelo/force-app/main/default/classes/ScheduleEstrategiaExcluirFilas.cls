global class ScheduleEstrategiaExcluirFilas Implements Schedulable
{

    //Agendado de 1 em 1 hora (no intervalo entre 22h e 6h)
    public static String CRON_EXP = '0 0 22-06 ? * *';
     
    global static String scheduleIt() {  
    	 
        ScheduleEstrategiaExcluirFilas scheduleEstrategiaExcluirFilas = new ScheduleEstrategiaExcluirFilas();
        
        string jobName = 'Estratégias Excluir Filas';
        if (Test.isRunningTest())
        {
            jobName = 'Estratégias Excluir Filas - Test';
        }
        
    	return System.schedule(jobName, CRON_EXP, scheduleEstrategiaExcluirFilas);
    }  
     
    global void execute(SchedulableContext ctx){
        sincronizar();
    }
    
    public static void sincronizar() {  
        Id idBatchEstrategiaExcluirFilas = Database.executeBatch(new BatchEstrategiaExcluirFilas(), 1);

		system.debug('idBatchEstrategiaExcluirFilas: ' + idBatchEstrategiaExcluirFilas);
    }
    
}
global class ScheduleCargaTarifaAlelo Implements Schedulable {
	
    public static String CRON_EXP = '0 0 1 * * ?';
     
    global static String scheduleIt() {  
    	 
        ScheduleCargaTarifaAlelo scheduleCargaTarifaAlelo = new ScheduleCargaTarifaAlelo();
        
        string jobName = 'Carga_Tarifa_Alelo';
        
    	return System.schedule(jobName, CRON_EXP, scheduleCargaTarifaAlelo);
    }  
     
    global void execute(SchedulableContext ctx){
        sincronizar();
    }
    
    public static void sincronizar() {  
        Id idBatchCargaTarifaAlelo = Database.executeBatch(new BatchCargaTarifaAlelo());

		system.debug('idBatchCargaTarifaAlelo: ' + idBatchCargaTarifaAlelo);
    }
}
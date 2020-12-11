global class ScheduleAtualizaCasoExpirado Implements Schedulable {
  
    public static String CRON_EXP = '0 0 1 * * ?';
     
    global static String scheduleIt() {  
       
        ScheduleAtualizaCasoExpirado scheduleAtualizaCasoExpirado = new ScheduleAtualizaCasoExpirado();
        
        string jobName = 'Atualziar_Pedidos_Expirados';
        
      return System.schedule(jobName, CRON_EXP, scheduleAtualizaCasoExpirado );
    }  
     
    global void execute(SchedulableContext ctx){
        sincronizar();
    }
    
    public static void sincronizar() {  
        Flow.Interview.AtualizaCasoExpirou atualizaCasoExpirou = new Flow.Interview.AtualizaCasoExpirou(new Map<String, Object>());
        atualizaCasoExpirou.start();
    }
}
public class QueueCarregarTarifas implements Queueable, Database.AllowsCallouts {

 //public Map<String, TOTarifa> mTarifa { get; set; }

 public QueueCarregarTarifas(String mTarifaJSON) {
   //this.mTarifa = (Map<String, TOTarifa>) JSON.deserialize(mTarifaJSON, Map<String, TOTarifa>.class);
  }

  public void execute(QueueableContext context) {

   /*try {

        if(!mTarifa.isEmpty()) {
          List<String> tarifas = new List<String>();
          tarifas.addAll(mTarifa.keySet());
          String key = tarifas[0];
          System.debug('Antes Carregar Tarifa');
          BOTarifa.carregarTarifa(mTarifa.get(key));
          System.debug('Depois Carregar Tarifa');

          mTarifa.remove(key);

          executarQueueCarregarTarifas(JSON.serialize(mTarifa));
        }

      }
      catch(Exception ex) {
       system.debug('Erro: ' + ex.getLineNumber());
       system.debug('Erro: ' + ex.getStackTraceString());
       system.debug('Erro: ' + ex.getTypeName());
       system.debug('Erro: ' + ex.getCause());
       system.debug('Erro: ' + ex.getMessage());
      }*/
 }
/*
 @Future(callout=true)
  private static void executarQueueCarregarTarifas(String toTarifasId)
  {
    System.debug('executarQueueCarregarTarifas');
    Map<String, TOTarifa> mapTarifa = (Map<String, TOTarifa>) JSON.deserialize(toTarifasId, Map<String, TOTarifa>.class);
    if(!mapTarifa.isEmpty()){
    ID jobID = System.enqueueJob(new QueueCarregarTarifas(toTarifasId));

    system.debug('jobID: ' + jobID);
   }
  }
  */
}
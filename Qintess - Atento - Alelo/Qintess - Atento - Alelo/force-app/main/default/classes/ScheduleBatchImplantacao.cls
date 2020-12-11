public class ScheduleBatchImplantacao implements Schedulable{

    BatchImplantacaoConfig__c config = BatchImplantacaoConfig__c.getOrgDefaults();

    public void execute(SchedulableContext ctx) {
        System.abortJob(ctx.getTriggerId());
        if(config.Ativo__c) {
            Integer limite = config.Limites__c != null ? (Integer) config.Limites__c : 200;
            Database.executeBatch(new BatchImplantacao(), limite);
        }
    }

}
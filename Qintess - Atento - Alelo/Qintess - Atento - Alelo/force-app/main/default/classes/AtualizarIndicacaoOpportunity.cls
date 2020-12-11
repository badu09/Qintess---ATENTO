public class AtualizarIndicacaoOpportunity implements Queueable, Database.AllowsCallouts {

    private Integer codigoBanco;
    private List<Opportunity> listOpp;
    
    public AtualizarIndicacaoOpportunity(Integer codigoBanco, List<Opportunity> listOpp) {
        this.codigoBanco = codigoBanco;
        this.listOpp = listOpp;
    }
    
    public void execute(QueueableContext context) {
        if(!Test.IsRunningTest()){
    		BOLead.atualizarIndicacao(this.codigoBanco, null, this.listOpp);
        }
    }
    
}
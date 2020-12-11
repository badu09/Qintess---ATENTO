public class AtualizarIndicacaoLead implements Queueable, Database.AllowsCallouts {

    private Integer codigoBanco;
    private List<Lead> listLead;
    
    public AtualizarIndicacaoLead(Integer codigoBanco, List<Lead> listLead) {
        this.codigoBanco = codigoBanco;
        this.listLead = listLead;
    }
    
    public void execute(QueueableContext context) {
        if(!Test.IsRunningTest()){
    		BOLead.atualizarIndicacao(this.codigoBanco, this.listLead, null);
        }
    }
    
}
@IsTest
public class DAOLeadTest {
    
    @IsTest
    static void test(){
        Test.startTest();
        DAOLead.getLeadByCampanha(null);
        DAOLead.salvarlead(new List<Lead>{new Lead(Phone='11999999999', LastName='Test',Company='Test',CNPJ__c='66567704000159')});
        DAOLead.getLeads();
        DAOLead.getLeadBySetId(null);
        DAOLead.getLead(null);
        DAOLead.getLeadIndicacaoBanco(null);
        DAOLead.getQueryIndicacaoBanco(null);
        Test.stopTest();
    }

}
public class DAOExpurgo 
{
	private static final DAOExpurgo instance = new DAOExpurgo();
    
    private DAOExpurgo(){}
    
    public static DAOExpurgo getInstance()
    {
        return instance;
    }
    
    public List<Expurgo__mdt> getData()
    {
        return [SELECT Id, NomeAPI__c, NomeProcesso__c, PeriodoExpurgo__c, ExpurgarObjetoFilho__c, NomeAPIObjetoFilho__c, NomeRelacionamento__c, NomeArquivoCSV__c, NomeArquivoCSVFilho__c, 
                		DeveloperName, OrdemExecucao__c, HorarioExecucao__c
                FROM Expurgo__mdt
                ORDER BY OrdemExecucao__c ASC];
    }
}
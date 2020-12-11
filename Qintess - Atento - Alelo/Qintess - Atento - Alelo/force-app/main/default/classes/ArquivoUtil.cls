public class ArquivoUtil 
{

    private static final String NOME_PASTA_EXPURGO = 'Arquivos_Expurgo';
    
    private ArquivoUtil()
    {
    }
    
    public static Id criarArquivoCSV(String nomeArquivo, StringBuilder conteudoArquivo, Id JobId)
    {
        Document arquivo = new Document();
        arquivo.Name = nomeArquivo + DateTime.now().format('_YYYYMMdd_HHmmss') + '_JobId_' + JobId;
        arquivo.DeveloperName = arquivo.Name; 
        arquivo.Body = Blob.valueOf(conteudoArquivo.getStringPorLinha());
        system.debug('arquivo.Body: ' +arquivo.Body);
        arquivo.FolderId = getIdFolderByName(NOME_PASTA_EXPURGO);
        arquivo.ContentType = 'text/csv;charset=utf-8';
        arquivo.Type = 'csv';       
        arquivo.IsPublic = false;      
        Database.insert(arquivo);
        
        return arquivo.Id;
    }

    public static void criarArquivoDeErros(String nomeArquivo, Database.DeleteResult[] delResult, Id JobId)
	{
		String texto = '';
		for(Database.DeleteResult dr : delResult) {
			if (!dr.isSuccess())
				texto += 'Id: ' + dr.getId() + ' - ERROS: ' + dr.getErrors() + '\n ';
		}

		if(String.isNotBlank(texto)) {

			Document arquivo = new Document();
			arquivo.Name = nomeArquivo + DateTime.now().format('_YYYYMMdd_HHmmss') + '_ERROS' + '_JobId_' + JobId;
			arquivo.DeveloperName = arquivo.Name;
			arquivo.Body = Blob.valueOf(texto);
			arquivo.FolderId = getIdFolderByName(NOME_PASTA_EXPURGO);
			arquivo.ContentType = 'text/plain;charset=utf-8';
			arquivo.Type = 'text/plain';
			arquivo.IsPublic = false;
			Database.insert(arquivo);
		}

	}
    
    public static Id getIdFolderByName(String DeveloperName)
	{
		Folder pastaPadrao = [SELECT Id from Folder WHERE DeveloperName =: DeveloperName];
		return pastaPadrao.Id;
	}


}
global without sharing class BatchExpurgoAtento implements Database.Batchable<sObject>
{
    private Expurgo__mdt objetoExpurgo;
    private StringBuilder conteudoArquivo;
    private StringBuilder conteudoArquivoObjetoFilho;
    //Atributos usado na query dinâmica
    private final String ligacao = '%Ligação%';
    private final String[] fases = new String[]{'Fechado e perdido', 'Venda confirmada'};
	private final String[] leadStatus = new String[]{'NÃO TEM INTERESSE (005)', 'ALTERAR TELEFONE (009)', 'SEM CONTATO (008)'};
	private final String leadOwnerName = 'Descartados';
        
    
    public BatchExpurgoAtento(Expurgo__mdt objeto)
    {
        this.objetoExpurgo = objeto;
        this.conteudoArquivo = new StringBuilder();
        this.conteudoArquivoObjetoFilho = new StringBuilder(); //Leandro: estava comentado...
    }

    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query = BOExpurgo.getInstance().getQueryForExpurgo(this.objetoExpurgo);
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> records)
    {
        Map<Id, sObject> mapRecords = new Map<Id, sObject>(records);
        
        //Bloco para formar a string csv dos registros do objeto filho.
        if(this.objetoExpurgo.ExpurgarObjetoFilho__c)
        {
            BOExpurgo.objetoPai = false;
        	BOExpurgo.objetoFilho = true;
            List<SObject> recordChilds = new List<SObject>();
			Map<Id, sObject> mapRecordsChilds = new Map<Id, sObject>();

            for(SObject record : records)
				{
					if(record.getSObjects(this.objetoExpurgo.NomeRelacionamento__c) != null)
						recordChilds.addAll(record.getSObjects(this.objetoExpurgo.NomeRelacionamento__c));
				}

                System.debug('# recordChilds : ' + recordChilds);

				mapRecordsChilds = new Map<Id, sObject>(recordChilds);

				Database.DeleteResult[] delResult = Database.delete(recordChilds, false);

				mapRecordsChilds = BOExpurgo.getInstance().removeRecordsWithErrors(delResult, mapRecordsChilds);

				ArquivoUtil.criarArquivoDeErros(objetoExpurgo.NomeArquivoCSV__c, delResult, bc.getJobId());
                
                if(!mapRecordsChilds.isEmpty())
            	{
                    for(SObject recordChild : mapRecordsChilds.values())
                    {
                        if(this.conteudoArquivoObjetoFilho.isVazio())
                        {
                            this.conteudoArquivoObjetoFilho.adicionar(BOExpurgo.getInstance().gerarCabecalhoArquivoCSV(this.objetoExpurgo.NomeAPIObjetoFilho__c));
                        }
                        
                        this.conteudoArquivoObjetoFilho.adicionar(BOExpurgo.getInstance().gerarLinhaArquivoCSV(recordChild, this.objetoExpurgo));
                    }
            	}

            
            //Criar o arquivo csv do objeto filho.
            if(!this.conteudoArquivoObjetoFilho.isVazio())
            {
                ArquivoUtil.criarArquivoCSV(objetoExpurgo.NomeArquivoCSVFilho__c, this.conteudoArquivoObjetoFilho, bc.getJobId());
            }
            
            //Deletar os registros filhos do contexto.
            //delete recordChilds;
            Database.emptyRecycleBin(mapRecordsChilds.values());

        }

		//Deletar os registros pai do contexto.
		Database.DeleteResult[] delResult = Database.delete(records, false);

		mapRecords = BOExpurgo.getInstance().removeRecordsWithErrors(delResult, mapRecords);

		ArquivoUtil.criarArquivoDeErros(objetoExpurgo.NomeArquivoCSV__c, delResult, bc.getJobId());

		//Bloco para formar a string csv dos registros.
		BOExpurgo.objetoPai = true;

		for(Object record : mapRecords.values())
			{
				if(this.conteudoArquivo.isVazio())
				{
					this.conteudoArquivo.adicionar(BOExpurgo.getInstance().gerarCabecalhoArquivoCSV(this.objetoExpurgo.NomeAPI__c));
				}

				this.conteudoArquivo.adicionar(BOExpurgo.getInstance().gerarLinhaArquivoCSV(record, this.objetoExpurgo));
			}

		//Criar o arquivo csv do objeto pai.
		if(!this.conteudoArquivo.isVazio())
		{
			ArquivoUtil.criarArquivoCSV(objetoExpurgo.NomeArquivoCSV__c, this.conteudoArquivo, bc.getJobId());
		}

		Database.emptyRecycleBin(mapRecords.values());
    }
    
    global void finish(Database.BatchableContext bc)
    {
        System.debug('# this.conteudoArquivo > ' + this.conteudoArquivo);
    }
}
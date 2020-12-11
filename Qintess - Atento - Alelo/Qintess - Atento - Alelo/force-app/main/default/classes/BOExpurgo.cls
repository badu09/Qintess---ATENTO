public without sharing class BOExpurgo 
{
    private static final BOExpurgo instance = new BOExpurgo();
    private static Set<String> fieldsObjectExpurgo = new Set<String>();
    public static Boolean objetoPai = false;
    public static Boolean objetoFilho = false;
  
    private BOExpurgo(){}
    
    public static BOExpurgo getInstance()
    {
        return instance;
    }

    public void scheduleExpurgo()
    {
        List<Expurgo__mdt> dadosExpurgo = this.getDataExpurgo();
        
        for(Expurgo__mdt dado : dadosExpurgo)
        {
            BatchExpurgoAtento batch = new BatchExpurgoAtento(dado);

            System.scheduleBatch(batch, dado.NomeProcesso__c, getMinutesFromNow(dado.HorarioExecucao__c));
        }
    }
    
    public String getQueryForExpurgo(Expurgo__mdt objeto)
    {
        String query = '';
        
        if(objeto != null)
        {   
			query = this.getFieldsSOQL(objeto.NomeAPI__c);
     		
            //SOQL objeto filho - subquery
            if(objeto.ExpurgarObjetoFilho__c)
            {
               query += + ',(' + this.getFieldsSOQL(objeto.NomeAPIObjetoFilho__c) + ' FROM '+ objeto.NomeRelacionamento__c + ')';
            }
            
            query += ' FROM ' + objeto.NomeAPI__c;
        }
        else
        {
            throw new ExpurgoException('Ocorreu um erro. Referência a um objeto nullo. Classe BOExpurgo: método getQueryForExpurgo().');
        }
        
        //Quantidade de dias parametrizados até a data atual.
        String filtrosSOQL = this.getFiltroSOQL(objeto); 
    	
        System.debug('# query + filtro : ' + query + filtrosSOQL);
        return query + filtrosSOQL;
    }
           
    private static Set<String> getFieldsObject(String nomeObjeto)
    {
        if(nomeObjeto != null)
        {
            return SchemaDescribeSObject.getInstance().getAllFieldsObject(nomeObjeto);
        }
        else
        {
            throw new ExpurgoException('Ocorreu um erro. Referência a um objeto nullo. Classe BOExpurgo: método getFieldsObject().');
        }
    }
    
    private String getFieldsSOQL(String nomeObjeto)
    {
		String query = '';
        fieldsObjectExpurgo = getFieldsObject(nomeObjeto);
        List<String> fields = new List<String>();
        
        for(String field : fieldsObjectExpurgo)
        {
            fields.add(field);
        }
        
        for(integer i=0; i < fields.size(); i++)
        {
            if(i == 0)
            {
                query = 'SELECT ' + fields.get(i);
            }
            else
            {
                query += ',' + fields.get(i);
            }
        }
        
        return query;
    }
    
    private String getFiltroSOQL(Expurgo__mdt objetoExpurgo)
    {
        String filtro = ' WHERE LastModifiedDate < LAST_N_DAYS: ' + String.valueOf(objetoExpurgo.PeriodoExpurgo__c);
        if(Test.isRunningTest()) filtro = ' WHERE Id != null '; //Não da pra modificar o campo LastModifiedDate em teste.
        
        if(objetoExpurgo.DeveloperName == 'ExpurgoTarefasLigacao')
        {
            filtro += ' AND Subject LIKE : ligacao';
        }
        else if(objetoExpurgo.DeveloperName == 'ExpurgoTarefas')
        {
            filtro += ' AND Subject !=: ligacao';
        }
        else if(objetoExpurgo.DeveloperName == 'ExpurgoTarifasCarrinho')
        {
            filtro += ' AND Produtos_Alelo__r.Oportunidade__r.StageName IN : fases';
        }
        else if(objetoExpurgo.DeveloperName == 'ExpurgoLead')
        {
            filtro += ' AND Status IN :leadStatus';
			filtro += ' AND Owner.Name = :leadOwnerName';
        }

        if(Test.isRunningTest()) filtro += ' LIMIT 200'; //Evita criar vários lotes em teste, o que da erro.
		else filtro += ' LIMIT 200000'; //Sem esse limite estava dando erro de tempo de acesso no SOQL [REQUEST_RUNNING_TOO_LONG].

		return filtro;
    }
    
    public List<Expurgo__mdt> getDataExpurgo()
    {
        return DAOExpurgo.getInstance().getData();
    }

    public String gerarCabecalhoArquivoCSV(String nomeObjetoExpurgo)
    {
        CSVExpurgo csv = new CSVExpurgo();
        String cabecalho;
        
        fieldsObjectExpurgo = getFieldsObject(nomeObjetoExpurgo);
        
        if(fieldsObjectExpurgo != null)
        {
            return cabecalho = csv.getCabecalhoCSV(fieldsObjectExpurgo);
        }
        else
        {
            throw new ExpurgoException('Ocorreu um erro. Referência a um objeto nullo. BOExpurgo: método gerarCabecalhoArquivoCSV().');
        }
        
    }
    
    public String gerarLinhaArquivoCSV(Object record, Expurgo__mdt objetoExpurgo)
    {
        CSVExpurgo csv = new CSVExpurgo();
        String linha; 
        
        fieldsObjectExpurgo = fieldsObjectExpurgo.isEmpty() ? this.getFieldsObjectExpurgo(objetoExpurgo) : fieldsObjectExpurgo;
        
        if(fieldsObjectExpurgo != null)
        {
            return linha = csv.getLinhaCSV(record, fieldsObjectExpurgo);
        }
        else
        {
            throw new ExpurgoException('Ocorreu um erro. Referência a um objeto nullo. BOExpurgo: método gerarCabecalhoArquivoCSV().');
        }
    }
    
    private Set<String> getFieldsObjectExpurgo(Expurgo__mdt objetoExpurgo)
    {
       Set<String> fields;
        
       if(objetoPai)
       {
           fields = getFieldsObject(objetoExpurgo.NomeAPI__c);
       }
       else if(objetoFilho)
       {
           fields = getFieldsObject(objetoExpurgo.NomeAPIObjetoFilho__c);
       }
        
       return fields;
    }

	public integer getMinutesFromNow(decimal hourExecution)
		{
			Time timeNow = system.now().time();
			integer result = (((hourExecution.intValue() - timeNow.hour()) * 60) - timeNow.minute());
			if(result > 0) {
				return result;
			} else {
				return 1; //Se caso alguem agende a classe depois da hora de execução.
			}
		}

	public Map<Id, sObject> removeRecordsWithErrors(Database.DeleteResult[] drList,  Map<Id, sObject> mapRecords)
		{
			for(Database.DeleteResult dr : drList) {
				if (!dr.isSuccess()) {
					mapRecords.remove(dr.getId());
				}
			}
			return mapRecords;

		}

}
/*
 * Classe responsável por gerar as linhas e colunas do arquivo csv dos objetos que são expurgados.
*/
public class CSVExpurgo 
{
	public String getCabecalhoCSV(Set<String> fields)
    {
        CSVBuilder csv = new CSVBuilder();

        for(String field : fields)
        {
            csv.adicionarColuna(field);
        }
        
        return csv.getLinhaCSV();
    }
    
    public String getLinhaCSV(Object record, Set<String> fields)
    {
        CSVBuilder csv = new CSVBuilder();
        
        SObject sobjectExpurgo = (SObject) record;
        
        for(String field : fields)
        {
            csv.adicionarColuna(sobjectExpurgo.get(field));
        }
        
        return csv.getLinhaCSV();
    }
}
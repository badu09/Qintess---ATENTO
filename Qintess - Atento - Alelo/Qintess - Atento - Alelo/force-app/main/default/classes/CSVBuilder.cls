/**
 * Classe responsável pela construção de um registro em formato CSV.
 * Esta classe não gera um arquivo CSV propriamente dito, mas sim a linha neste formato.
 */ 
public class CSVBuilder 
{
	private static final String DELIMITADOR_COLUNA = '"';
    private static final String SEPARADOR_COLUNA = ',';
    private static final String PADRAO_COLUNA = DELIMITADOR_COLUNA + '{0}' + DELIMITADOR_COLUNA;  
    private List<String> colunas;
    
    public CSVBuilder()
    {
        this.colunas = new List<String>();
    }
    
    public void adicionarColuna(Object conteudo)
    {
        String conteudoFormatado = this.formatar(conteudo);
        this.colunas.add(conteudoFormatado);
    }
    
    private String formatar(Object conteudo)
    {
        String conteudoString = this.getString(conteudo);
        String conteudoFormatado = String.format(PADRAO_COLUNA, new String[]{conteudoString});
        
        return conteudoFormatado;
    }
    
    private String getString(Object conteudo)
    {
        String conteudoString = '';
        
        if(conteudo != null)
        {
            conteudoString = String.valueOf(conteudo).trim();
            conteudoString = conteudoString.replaceAll(';', '');
            conteudoString = conteudoString.replaceAll(DELIMITADOR_COLUNA, '');
            conteudoString = conteudoString.normalizeSpace();
        }
        
        return conteudoString;
    }
    
    public String getLinhaCSV()
    {
        String linhaCSV = String.join(this.colunas, SEPARADOR_COLUNA);
        
        return linhaCSV;
    }
    
}
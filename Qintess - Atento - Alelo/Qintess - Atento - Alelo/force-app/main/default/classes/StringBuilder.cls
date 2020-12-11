/*
 * Classe responsável pela construção de Strings.
 */ 
public class StringBuilder 
{
    private static final String CARACTER_FIM_DE_LINHA = '\n';
    private List<String> strings;
    
    public StringBuilder()
    {
        this.strings = new List<String>();
    }
    
    public void adicionar(Object conteudo)
    {
        String conteudoString = this.getString(conteudo);
        this.strings.add(conteudoString);
    }
    
    private String getString(Object conteudo)
    {
    	String conteudoString = (conteudo == null ? '' : String.valueOf(conteudo).trim());
        
        return conteudoString;
    }
    
    public String getString()
    {
    	String conteudoString = String.join(this.strings, ''); 
        
        return conteudoString;
    }
    
    public String getStringPorLinha()
    {
    	String conteudoString = String.join(this.strings, CARACTER_FIM_DE_LINHA);
        
        return conteudoString;
    }
    
    public Boolean isVazio()
    {
        return this.strings.isEmpty();
    }
    
}
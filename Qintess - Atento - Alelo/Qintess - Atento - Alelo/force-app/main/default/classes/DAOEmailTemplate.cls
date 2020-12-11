public with sharing class DAOEmailTemplate {
	
	public static EmailTemplate obterTemplatePorNome(string nmModelo) {
		EmailTemplate template;
		try {
			template = [select 
						          	id, 
						          	name,
						          	HtmlValue
						         from 
						          	EmailTemplate 
						         where 
						          developername = : nmModelo];
		}
		catch(Exception e) {
			System.debug('Exception: ' + e + '\n' + e.getStackTraceString());
		}
		return template;
	}
}
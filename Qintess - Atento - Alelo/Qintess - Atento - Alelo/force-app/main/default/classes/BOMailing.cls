public class BOMailing {
  public static void ImportMailing(String nomeCampanha) {
    Map<String, List<Lead>> mapLead = new Map<String, List<Lead>>();

    WSMailingCommand.WSMailingCommandSoap service = new WSMailingCommand.WSMailingCommandSoap();
    
    for(Lead lead : [SELECT Id, Phone, Telefone2__c, Telefone3__c, Telefone4__c, Telefone5__c, Nome_da_Campanha__c, Sub_Campanha__c, CNPJ__c, Name, Id_da_Campanha__c FROM Lead WHERE Id_da_Campanha__c = :nomeCampanha AND IsConverted = false]) {
    	
      List<Lead> listaLead;	
    	  
      if(mapLead.containsKey(lead.Id_da_Campanha__c)) {
        listaLead = mapLead.get(lead.Id_da_Campanha__c);
      }
      else {
        listaLead = new List<Lead>();
      }
      
      listaLead.add(lead);
      
      mapLead.put(lead.Id_da_Campanha__c, listaLead);
    }

    for(String idCampanha : mapLead.keySet()) { 
      String mailingName;
      List<String> mailing = new List<String>();
      WSMailingCommand.ArrayOfString mailingString = new WSMailingCommand.ArrayOfString();
      Boolean partialMailing = false;
      Lead lead = mapLead.get(idCampanha)[0];
      mailingName = lead.Id_da_Campanha__c;
      for(Lead item: mapLead.get(idCampanha)) {
        mailing.add(item.Id + ';' +
                    Util.StringValueOf(item.CNPJ__c) + ';' +
                    Util.StringValueOf(item.Id_da_Campanha__c) + ';' +
                    Util.StringValueOf(item.Name) + ';' +
                    Util.StringValueOf(item.Phone).replace(' ', '') + ';' +
                    Util.StringValueOf(item.Telefone2__c).replace(' ', '') + ';' +
                    Util.StringValueOf(item.Telefone3__c).replace(' ', '') + ';' +
                    Util.StringValueOf(item.Telefone4__c).replace(' ', '') + ';' +
                    Util.StringValueOf(item.Telefone5__c).replace(' ', '') + ';');
      }
      
      //enviar(mailing, mailingName);
      
      /*mailingString.string_x = mailing;
      
      service.timeout_x = 120000;      
      
      String retorno = service.ImportMailing(mailingName,mailingString,partialMailing);
      System.debug('Mailing: ' + mailingName + '\nretorno: ' + retorno);
		
		String email = 'danilo.saule@bsitecnologia.com.br';
		
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
	
		mail.setToAddresses(new String[] {email});

		mail.setReplyTo(email);

		mail.setSenderDisplayName('Campanha atualizada');

		mail.setSubject(mailingName + ' enviado p/ Olos');

		mail.setPlainTextBody('Retorno Olos: ' + retorno);

	 	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });*/
	
    }
  }
  
  @future(callout=true) 
  public static void enviar(List<String> mailing, Id idMailingDistribution) {
  	
  	Mailing_Distribution__c mailingDistribution = DAOMailingDistribution.obterMailingDistribution(idMailingDistribution);
  	
  	String mailingName = mailingDistribution.Id_Campanha__c;
  	
  	Boolean partialMailing = false; 
  	
  	WSMailingCommand.WSMailingCommandSoap service = new WSMailingCommand.WSMailingCommandSoap();
  	
  	WSMailingCommand.ArrayOfString mailingString = new WSMailingCommand.ArrayOfString();
  	
  	mailingString.string_x = mailing; 
      
    service.timeout_x = 120000;      
      
    String retorno = service.ImportMailing(mailingName,mailingString,partialMailing);
    
    mailingDistribution.Retorno_Discador__c = retorno; 
    mailingDistribution.Status_Discador__c = 'Finalizado';
		
	update mailingDistribution;
  }
}
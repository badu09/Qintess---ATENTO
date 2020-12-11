public class DAOContact {
    public static List<Contact> getContactByAccountId(Id id) {
    	List<Contact> listContact = null;
    	
		listContact = [SELECT
						    Id,
						    Name,
						    Email
						FROM 
						 	Contact
						WHERE
							Email != null
						AND
							Name != null
						AND
						  	AccountId = :id];
						  	
		return listContact;
    }
    
    public static Contact getContactById(String Id) {
	    return [SELECT
	              Id,
	              Name,
	              CPF__c,
	              Data_de_Nascimento__c,
	              Sexo__c,
	              Email,
	              Nivel_Hierarquico__c,
	              Numero_de_Matricula__c,
	              Department,
	              Localizacao_Interna__c,
	              DDD__c,
	              Telefone_Comercial__c,
	              Ramal__c,
	              DDDCelular__c,
	              Telefone_Celular__c,
	              DDDFax__c,
	              Telefone_Fax__c
	            FROM
	            	Contact
	            WHERE
	            	Id = :Id];
  	}
}
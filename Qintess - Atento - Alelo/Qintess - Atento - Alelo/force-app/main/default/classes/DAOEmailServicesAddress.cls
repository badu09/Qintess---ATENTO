public with sharing class DAOEmailServicesAddress {
    public static EmailServicesAddress getByLocalPart(String localPart) {
	    List<EmailServicesAddress> listEmailServicesAddress = [SELECT
																	Id,
																	EmailDomainName
														        FROM
														        	EmailServicesAddress
														        WHERE
														        	IsActive = true
														        And
														        	LocalPart =: localPart];
		
		return listEmailServicesAddress.isEmpty() ? null : listEmailServicesAddress[0];
	}
}
/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestUser {

    static testMethod void myUnitTest() {
    	
    	User u = new User(
		     ProfileId = UserInfo.getProfileId(),
		     LastName = 'last',
		     Email = 'puser000@amamama.com',
		     Username = 'puser000@amamama.com' + System.currentTimeMillis(),
		     CompanyName = 'TEST',
		     Title = 'title',
		     Alias = 'alias',
		     TimeZoneSidKey = 'America/Los_Angeles',
		     EmailEncodingKey = 'UTF-8',
		     LanguageLocaleKey = 'en_US',
		     LocaleSidKey = 'en_US',
		     UserRoleId = UserInfo.getUserRoleId(),
		     Equipe__c = 'ATIVO'
		);
        
        insert u;
        
        update u;
    }
}
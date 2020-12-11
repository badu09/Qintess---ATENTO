@isTest
public class DAOAccountTest {

    @isTest
    public static void testGetAccountByCNPJ(){
        Account acct_test = TestData.getAccount();
        Account acct = DAOAccount.getAccountByCNPJ(acct_test.CPF_CNPJ__c);
        System.assert(acct != null, 'O método "getAccountByCNPJ" não retornou o registro de conta esperado.');
        System.assertEquals(acct_test.CPF_CNPJ__c, acct.CPF_CNPJ__c, 'O método "getAccountByCNPJ" não retornou o registro com o CPF/CNPJ certo.');
    }
    
    @isTest
    public static void testGetAccountById(){
        Account acct_test = TestData.getAccount();
        Account acct = DAOAccount.getAccountById(acct_test.Id);
        System.assert(acct != null, 'O método "getAccountByCNPJ" não retornou o registro de conta esperado.');
        System.assertEquals(acct_test.Id, acct.Id, 'O método "getAccountByCNPJ" não retornou o registro com o Id certo.');
    }
    
}
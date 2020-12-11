public class DAODeParaTabulacao {
 public static List<De_Para_Tabulacao__c> getTabulacao() {
 	return [SELECT Id, DispositionId__c, Status__c, Tabulacao__c FROM De_Para_Tabulacao__c];
 }
}
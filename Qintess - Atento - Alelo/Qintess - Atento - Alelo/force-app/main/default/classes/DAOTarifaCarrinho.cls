public class DAOTarifaCarrinho {
  public static void limparTarifas(String idProduto) {
  	delete [Select Id FROM Tarifas_Carrinho__c WHERE Produtos_Alelo__c = :idProduto];
  }

}
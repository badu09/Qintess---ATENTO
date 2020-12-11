public class TOTarifa {
    
    public static final String FORMA_PAGAMENTO_BOLETO = 'BOLETO';
    public static final String FORMA_PAGAMENTO_CREDITO = 'CARTAO CREDITO';
    
	public String Id { get; set; }
	public String ProductCode { get; set; }
	public String ProductName { get; set; }
	public String FeeCode { get; set; }
	public String FeeName { get; set; }
	public String CommunicationProduct { get; set; }
	public String formaPagamento { get; set; }

	public TOTarifa(String ProductCode, String ProductName, String FeeCode, String FeeName, String CommunicationProduct) {
		this.ProductCode = ProductCode;
		this.FeeCode = FeeCode;
		this.CommunicationProduct = CommunicationProduct;
		this.FeeName = FeeName;
		this.ProductName = ProductName;

		this.Id = ProductCode + '|' + FeeCode;
	}

	public TOTarifa(String ProductCode, String ProductName, String FeeCode, String FeeName, String CommunicationProduct, String formaPagamento) {
		this(ProductCode, ProductName, FeeCode, FeeName, CommunicationProduct);
		this.formaPagamento = formaPagamento;
	}
}
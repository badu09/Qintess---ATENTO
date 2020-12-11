@isTest
public class HttpAcessoExternoMock implements HttpCalloutMock {

  protected Integer code;
  protected String status;
  protected String body;
  protected Map<String, String> responseHeaders;
  private Map<String,String> mockResponses;

  public HttpAcessoExternoMock(Integer code, String status, String body, Map<String, String> responseHeaders) {
      this.code = code;
      this.status = status;
      this.body = body;
      this.responseHeaders = responseHeaders;
      setMocks(new Map<String,String>());
  }

  public void setMocks(Map<String,String> mocks){
    mockResponses = mocks;
  }

  public void setMockResponse(String servico, String response){
    mockResponses.put(servico,response);
  }

  public String getMockResponse(String serviceId){
    return mockResponses.get(serviceId);
  }

  public HttpAcessoExternoMock(Integer code, String body) {
      this(code,'',body,null);
  }

  public HTTPResponse respond(HTTPRequest req) {
	System.debug('mockResponses: ' + JSON.serialize(mockResponses));
      HttpResponse res = new HttpResponse();

      DOM.Document xml = new DOM.Document();
      xml.load(req.getBody());

      DOM.XmlNode envelope = xml.getRootElement();

      DOM.XmlNode[] nos = envelope.getChildElements();
      DOM.XmlNode header = nos[0];
      DOM.XmlNode body = nos[1];
      
      DOM.XmlNode[] servicos = body.getChildElements();

      res.setHeader('Content-type','text/xml');
      if(mockResponses.keySet().size() == 0){
          res.setBody(this.body);
      }else{
      	System.debug('servicos[0].getName(): ' + servicos[0].getName());
      	if(servicos[0].getName() == 'acessarMaintainContractIS')
        	res.setBody(getMockResponse('acessarMaintainContractIS'));
        else if(servicos[0].getName() == 'acessarGetPricePolicyIS')
        	res.setBody(getMockResponse('acessarGetPricePolicyIS'));
      }
      res.setStatusCode(this.code);

      return res;
  }

}
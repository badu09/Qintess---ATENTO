public class HttpGeneric {
    public static HttpResponse executarHttpAcessoExterno(String metodo, String body) {
      Http http = new Http();

      HttpRequest httpRequest = new HttpRequest();

      httpRequest.setEndPoint('http://bsi.atento.com.br:8080/WebServiceAlelo/AcessoExternoAleloWS');
      //httpRequest.setEndPoint('http://bsi.atento.com.br:8181/WebServiceAlelo/AcessoExternoAleloWS'); // AMBIENTE DE HOMOLOGAÇÂO
      httpRequest.setMethod(metodo);
      httpRequest.setTimeout(20000);
      httpRequest.setHeader('Content-Type', 'text/xml');

      httpRequest.setBody(body);

      System.debug('Request: '+ httpRequest);
      System.debug('Request Body: '+ httpRequest.getBody());

      HttpResponse httpResponse = new HttpResponse();

      try
      {
          httpResponse = http.send(httpRequest);

          System.debug('Response: ' + 'Sucesso');
          System.debug('Response: ' + httpResponse.getStatusCode());
          System.debug('Response: ' + httpResponse.getBody());

          return HttpResponse;
      }
      catch(Exception e)
      {
          System.debug('Response: ' + 'Erro');
          System.debug('Response: ' + e + '\n' + e.getMessage());
      }
      return null;
    }

    public static String validarResponseGetPricePolicy(HttpResponse httpResponse)
       {
			String retorno = null;
            if(httpResponse != null) {
             
				DOM.Document doc = new DOM.Document();
	
				dom.Document resDoc = httpResponse.getBodyDocument();
	
				dom.XmlNode envelope = resDoc.getRootElement();
				
				String S = 'http://schemas.xmlsoap.org/soap/envelope/';
	      		String ns4 = 'http://www.w3.org/2003/05/soap-envelope';
				String ns2 = 'http://impl.middleware.alelo.atento.com.br/';
	
				dom.XmlNode body = envelope.getChildElement('Body', S);
				System.debug('body: ' + body);
				dom.XmlNode fault = body.getChildElement('Fault', S);
	
	      		dom.XmlNode acessarMaintainContractISResponse = body.getChildElement('acessarMaintainContractISResponse', ns2);
				System.debug('acessarMaintainContractISResponse: ' + acessarMaintainContractISResponse);
				if(fault != null)
				{
					retorno = '\n' + fault.getChildElement('faultcode', null).getText();
					retorno += ' - ' + fault.getChildElement('faultstring', null).getText();
				}
				else if(acessarMaintainContractISResponse != null) {
					if(acessarMaintainContractISResponse.getChildElement('return', null) != null)
						if(acessarMaintainContractISResponse.getChildElement('return', null).getChildElement('responseData', null) != null) {
							dom.xmlNode success = acessarMaintainContractISResponse.getChildElement('return', null).getChildElement('responseData', null).getChildElement('success', null);
							System.debug('success: ' + success);
							if(success != null && success.getText() == 'false') {
								dom.XmlNode errorList = acessarMaintainContractISResponse.getChildElement('return', null).getChildElement('responseData', null).getChildElement('errorList', null);
								System.debug('errorList: ' + errorList);
								if(errorList != null && errorList.getChildElement('errorData', null) != null) {
									dom.XmlNode errorCode = errorList.getChildElement('errorData', null).getChildElement('errorCode', null);
									dom.XmlNode errorMessage = errorList.getChildElement('errorData', null).getChildElement('errorMessage', null);
									retorno = '';
									if(errorCode != null)
										retorno += '\n' + errorCode.getText();
	
									if(errorMessage != null)
										retorno += ' - ' + errorMessage.getText();
								}
							}
						}
		      		}
            }

			return retorno;
       }

}
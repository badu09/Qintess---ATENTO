@isTest
public class WSMailingCommandMockImpl implements WebServiceMock {
	public void doInvoke(
			Object stub,
			Object request,
			Map<String, Object> response,
			String endpoint,
			String soapAction,
			String requestName,
			String responseNS,
			String responseName,
			String responseType) {
       
		System.debug(LoggingLevel.INFO, 'WSMailingCommandMockImpl.doInvoke() - ' +
			'\n request: ' + request +
			'\n response: ' + response +
			'\n endpoint: ' + endpoint +
			'\n soapAction: ' + soapAction +
			'\n requestName: ' + requestName +
			'\n responseNS: ' + responseNS +
			'\n responseName: ' + responseName +
			'\n responseType: ' + responseType);

		if(request instanceOf WSMailingCommand.FinalizeClientByDispositionCode_element) {
			response.put( 'response_x', new WSMailingCommand.FinalizeClientByDispositionCodeResponse_element());
		}
		else if(request instanceOf WSMailingCommand.InsertPhoneNumberJSON_element) {
			response.put( 'response_x', new WSMailingCommand.InsertPhoneNumberJSONResponse_element());
		}
		else if(request instanceOf WSMailingCommand.UpdateMailingData_element) {
			response.put( 'response_x', new WSMailingCommand.UpdateMailingDataResponse_element());
		}
		else if(request instanceOf WSMailingCommand.CustomerCallback_element) {
			response.put( 'response_x', new WSMailingCommand.CustomerCallbackResponse_element());
		}
		else if(request instanceOf WSMailingCommand.FinalizeClientByPhoneNumberJSON_element) {
			response.put( 'response_x', new WSMailingCommand.FinalizeClientByPhoneNumberJSONResponse_element());
		}
		else if(request instanceOf WSMailingCommand.GetMailingView_element) {
			response.put( 'response_x', new WSMailingCommand.GetMailingViewResponse_element());
		}
		else if(request instanceOf WSMailingCommand.InsertPhoneNumber_element) {
			response.put( 'response_x', new WSMailingCommand.InsertPhoneNumberResponse_element());
		}
		else if(request instanceOf WSMailingCommand.ListMailingsJSON_element) {
			response.put( 'response_x', new WSMailingCommand.ListMailingsJSONResponse_element());
		}
		else if(request instanceOf WSMailingCommand.ImportMailing_element) {
			response.put( 'response_x', new WSMailingCommand.ImportMailingResponse_element());
		}
		else if(request instanceOf WSMailingCommand.ListMailings_element) {
			response.put( 'response_x', new WSMailingCommand.ListMailingsResponse_element());
		}
		else if(request instanceOf WSMailingCommand.ChangeMailingStatusByName_element) {
			response.put( 'response_x', new WSMailingCommand.ChangeMailingStatusByNameResponse_element());
		}
		else if(request instanceOf WSMailingCommand.SetCallDataProcessed_element) {
			response.put( 'response_x', new WSMailingCommand.SetCallDataProcessedResponse_element());
		}
		else if(request instanceOf WSMailingCommand.FinalizeClient_element) {
			response.put( 'response_x', new WSMailingCommand.FinalizeClientResponse_element());
		}
		else if(request instanceOf WSMailingCommand.InsertNewReferral_element) {
			response.put( 'response_x', new WSMailingCommand.InsertNewReferralResponse_element());
		}
		else if(request instanceOf WSMailingCommand.GetCallData_element) {
			response.put( 'response_x', new WSMailingCommand.GetCallDataResponse_element());
		}
		else if(request instanceOf WSMailingCommand.GetMailingRawView_element) {
			response.put( 'response_x', new WSMailingCommand.GetMailingRawViewResponse_element());
		}
		else if(request instanceOf WSMailingCommand.ListMailingsByCompanyId_element) {
			response.put( 'response_x', new WSMailingCommand.ListMailingsByCompanyIdResponse_element());
		}
		else if(request instanceOf WSMailingCommand.FinalizeClientJSON_element) {
			response.put( 'response_x', new WSMailingCommand.FinalizeClientJSONResponse_element());
		}
		else if(request instanceOf WSMailingCommand.FinalizeClientByPhoneNumber_element) {
			response.put( 'response_x', new WSMailingCommand.FinalizeClientByPhoneNumberResponse_element());
		}
		else if(request instanceOf WSMailingCommand.ChangeMailingStatus_element) {
			response.put( 'response_x', new WSMailingCommand.ChangeMailingStatusResponse_element());
		}
		else if(request instanceOf WSMailingCommand.FinalizeClientByDispositionCodeJSON_element) {
			response.put( 'response_x', new WSMailingCommand.FinalizeClientByDispositionCodeJSONResponse_element());
		}
		else if(request instanceOf WSMailingCommand.ListCustomerMailings_element) {
			response.put( 'response_x', new WSMailingCommand.ListCustomerMailingsResponse_element());
		}
	}
}
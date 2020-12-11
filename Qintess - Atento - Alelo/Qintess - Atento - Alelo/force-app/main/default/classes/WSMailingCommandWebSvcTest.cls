@isTest
private class WSMailingCommandWebSvcTest {
	
	@isTest static void coverGeneratedCodeTypes() {
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand parentObject = new WSMailingCommand();
		new WSMailingCommand.FinalizeClientByDispositionCode_element();
		new WSMailingCommand.ListMailingsResponse_element();
		new WSMailingCommand.InsertPhoneNumberJSON_element();
		new WSMailingCommand.InsertPhoneNumberJSONResponse_element();
		new WSMailingCommand.UpdateMailingData_element();
		new WSMailingCommand.CustomerCallback_element();
		new WSMailingCommand.ListMailingsJSONResponse_element();
		new WSMailingCommand.ArrayOfCallDataSummary();
		new WSMailingCommand.FinalizeClientByPhoneNumberJSON_element();
		new WSMailingCommand.GetMailingView_element();
		new WSMailingCommand.ListCustomerMailingsResponse_element();
		new WSMailingCommand.InsertPhoneNumber_element();
		new WSMailingCommand.ListMailingsJSON_element();
		new WSMailingCommand.ImportMailing_element();
		new WSMailingCommand.FinalizeClientByDispositionCodeJSONResponse_element();
		new WSMailingCommand.GetCallDataResponse_element();
		new WSMailingCommand.MailingSummary();
		new WSMailingCommand.CallDataSummary();
		new WSMailingCommand.ListMailings_element();
		new WSMailingCommand.ChangeMailingStatusByName_element();
		new WSMailingCommand.SetCallDataProcessedResponse_element();
		new WSMailingCommand.FinalizeClientByPhoneNumberResponse_element();
		new WSMailingCommand.SetCallDataProcessed_element();
		new WSMailingCommand.ListMailingsByCompanyIdResponse_element();
		new WSMailingCommand.CustomerCallbackResponse_element();
		new WSMailingCommand.FinalizeClient_element();
		new WSMailingCommand.FinalizeClientByPhoneNumberJSONResponse_element();
		new WSMailingCommand.UpdateMailingDataResponse_element();
		new WSMailingCommand.ImportMailingResponse_element();
		new WSMailingCommand.InsertNewReferralResponse_element();
		new WSMailingCommand.InsertNewReferral_element();
		new WSMailingCommand.FinalizeClientResponse_element();
		new WSMailingCommand.GetCallData_element();
		new WSMailingCommand.GetMailingRawView_element();
		new WSMailingCommand.ListMailingsByCompanyId_element();
		new WSMailingCommand.InsertPhoneNumberResponse_element();
		new WSMailingCommand.FinalizeClientByDispositionCodeResponse_element();
		new WSMailingCommand.FinalizeClientJSON_element();
		new WSMailingCommand.FinalizeClientByPhoneNumber_element();
		new WSMailingCommand.ChangeMailingStatus_element();
		new WSMailingCommand.ChangeMailingStatusByNameResponse_element();
		new WSMailingCommand.FinalizeClientByDispositionCodeJSON_element();
		new WSMailingCommand.ChangeMailingStatusResponse_element();
		new WSMailingCommand.ListCustomerMailings_element();
		new WSMailingCommand.ArrayOfMailingSummary();
		new WSMailingCommand.MailingSummaryView();
		new WSMailingCommand.GetMailingViewResponse_element();
		new WSMailingCommand.ArrayOfString();
		new WSMailingCommand.FinalizeClientJSONResponse_element();
		new WSMailingCommand.GetMailingRawViewResponse_element();
	}

	@isTest static void coverCodeForInsertPhoneNumberJSON(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		testObject.InsertPhoneNumberJSON(null, null, null, null);
		// System.assertEquals(null, testObject.InsertPhoneNumberJSON(null, null, null, null));
	}


	@isTest static void coverCodeForChangeMailingStatusByName(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.ChangeMailingStatusByName(null, null));
	}


	@isTest static void coverCodeForListMailings(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.ListMailings(null));
	}


	@isTest static void coverCodeForInsertGetMailingRawView(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.GetMailingRawView(null, null));
	}


	@isTest static void coverCodeForChangeMailingStatus(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.ChangeMailingStatus(null, null, null));
	}


	
	@isTest static void coverCodeForGetCallData(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.GetCallData(null, null, null, null));
	}


	
	@isTest static void coverCodeForFinalizeClientByPhoneNumber(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.FinalizeClientByPhoneNumber(null, null, null, null));
	}


	@isTest static void coverCodeForImportMailing(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.ImportMailing(null, null, null));
	}


	@isTest static void coverCodeForFinalizeClientByDispositionCodeJSON(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		testObject.FinalizeClientByDispositionCodeJSON(null, null, null, null);
	}


	
	@isTest static void coverCodeForSetCallDataProcessed(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.SetCallDataProcessed(null));
	}


	
	@isTest static void coverCodeForListMailingsByCompanyId(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.ListMailingsByCompanyId(null));
	}


	
	@isTest static void coverCodeForInsertPhoneNumber(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.InsertPhoneNumber(null, null, null, null));
	}


	
	@isTest static void coverCodeForListMailingsJSON(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		testObject.ListMailingsJSON(null);
	}


	
	@isTest static void coverCodeForFinalizeClientJSON(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		testObject.FinalizeClientJSON(null, null, null);
	}


	
	@isTest static void coverCodeForUpdateMailingData(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.UpdateMailingData(null, null, null, null));
	}


	
	@isTest static void coverCodeForFinalizeClientByPhoneNumberJSON(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		testObject.FinalizeClientByPhoneNumberJSON(null, null, null, null);
	}


	
	@isTest static void coverCodeForCustomerCallback(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.CustomerCallback(null, null, null, null, null, null, null, null, null));
	}


	
	@isTest static void coverCodeForFinalizeClient(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.FinalizeClient(null, null, null));
	}


	
	@isTest static void coverCodeForListCustomerMailings(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.ListCustomerMailings(null));
	}


	
	@isTest static void coverCodeForGetMailingView(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.GetMailingView(null, null, null));
	}


	
	@isTest static void coverCodeForInsertNewReferral(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.InsertNewReferral(null, null, null, null, null, null, null, null, null, null, null));
	}


	
	@isTest static void coverCodeForFinalizeClientByDispositionCode(){
		Test.setMock(WebServiceMock.class, new WSMailingCommandMockImpl());
		WSMailingCommand.WSMailingCommandSoap testObject = new WSMailingCommand.WSMailingCommandSoap();
		System.assertEquals(null, testObject.FinalizeClientByDispositionCode(null, null, null, null));
	}
}
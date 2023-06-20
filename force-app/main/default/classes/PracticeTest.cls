@isTest(seeAllData=false)
private class RestApiTest {
	static testMethod void SuccessAccessTokenTest() {
		System.Test.setMock(HttpCalloutMock.class, new MockHttpTest(200, 'OK'));
		user u = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
		AxasClientAPI4 api4 = new AxasClientAPI4();

		System.Test.startTest();
		System.runAs(u) {
			api4.setAccessToken();
			System.debug(api4);
		}
		System.Test.stopTest();
		System.assertEquals(api4.tokenId, 'dics_accToken');
	}

	static testMethod void ErrorAccessTokenTest() {
		System.Test.setMock(HttpCalloutMock.class, new MockHttpTest(400, 'NG'));
		user u = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
		AxasClientAPI4 api4 = new AxasClientAPI4();
		System.Test.startTest();
		System.runAs(u) {
			api4.setAccessToken();
		}
		System.Test.stopTest();
		System.debug(api4.errMsgList);
		System.assertEquals(api4.tokenId, null);
		System.assert(api4.errMsgList.size() == 2);
	}

	// Mock
	//////////////////////////////////////////////////////
	public class MockHttpTest implements HttpCalloutMock {
		protected Integer code;
		protected String status;

		public MockHttpTest(Integer c, String s) {
			code = c;
			status = s;
		}

		public HttpResponse respond(HttpRequest req) {
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setStatusCode(code);
			res.setStatus(status);
			res.setBody(this.getResObj());
			return res;
		}
		private String getResObj() {
			Map<String, String> resMap = new Map<String, Stirng>();
			resMap.put('access_token', 'dics_accToken');
			return JSON.serialize(resMap);
		}
	}
}

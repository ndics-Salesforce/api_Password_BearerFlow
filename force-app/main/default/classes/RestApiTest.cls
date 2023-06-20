// 組織のすべてのデータにはアクセスできない
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

		// System.Test.setMock(HttpCalloutMock.class, new MockAccountTest(200, 'OK'));

		// System.Test.startTest();
		// System.runAs(u) {
		// 	api4.getRequestObj();
		// 	System.debug(api4);
		// }
		// System.Test.stopTest();
		// List<Account> accList = [SELECT Id, Name, ExternalId__c FROM Account];
		// System.assertEquals(accList.size(), 1);
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

	static testMethod void accountCalloutTest() {
		System.Test.setMock(HttpCalloutMock.class, new MockAccountTest(200, 'OK'));
		user u = [SELECT Id, Name FROM User WHERE Id = :UserInfo.getUserId()];
		AxasClientAPI4 api4 = new AxasClientAPI4();
		api4.tokenId = '00DN0000000VzHH!AR';
		System.Test.startTest();
		System.runAs(u) {
			api4.getRequestObj();
			System.debug(api4);
		}
		System.Test.stopTest();
		List<Account> accList = [SELECT Id, Name, ExternalId__c FROM Account];
		Account acc = accList[0];
		System.assertEquals(accList.size(), 1);
		System.assertEquals(acc.ExternalId__c, '001O000002JmsCrIAJ');
	}

	public class MockHttpTest implements HttpCalloutMock {
		protected Integer code;
		protected String status;
		// get access token request
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
			Map<String, String> resMap = new Map<String, String>();
			resMap.put('access_token', 'dics_accToken');
			return JSON.serialize(resMap);
		}
	}

	public class MockAccountTest implements HttpCalloutMock {
		protected Integer code;
		protected String status;

		// get access token request
		public MockAccountTest(Integer c, String s) {
			code = c;
			status = s;
		}

		public HttpResponse respond(HttpRequest req) {
			HttpResponse res = new HttpResponse();
			res.setHeader('Content-Type', 'application/json');
			res.setStatusCode(code);
			res.setStatus(status);
			res.setBody(this.getAccObj());
			return res;
		}
		private String getAccObj() {
			Account acc = new Account(id = '001O000002JmsCrIAJ');
			acc.name = 'Account Test';
			//insert acc;
			List<Account> accs = new List<Account>();
			accs.add(acc);
			Map<String, list<Object>> aMap = new Map<String, list<Object>>();
			amap.put('records', accs);
			return JSON.serialize(amap);
		}
	}
}

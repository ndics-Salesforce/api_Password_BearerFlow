@isTest
global class AxasClientAPI4Test {
	@isTest
	global AxasClientAPI4Test() {
		Test.setMock(HttpCalloutMock.class, new setAccessTokenMock());

		// getRequestObj() のテスト
		// query_resのgetBodyが想定されているものと同じか
		// エラー時に表示されるメッセージが想定されているものと同じか
	}
}

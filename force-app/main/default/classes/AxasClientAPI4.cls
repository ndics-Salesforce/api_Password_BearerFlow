public class AxasClientAPI4 extends RestApi {
	public HttpResponse query_res;
	// AccountDBAのメソッドを呼び出すとき、インスタンス化しなければならない
	public AccountDBA accDBA;

	public AxasClientAPI4() {
		//	super();
	}

	public void axasGetTest() {
		String url = 'callout:OldAxas01/axas/test1';
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod(HTTP_METHOD_GET);
		// req.setHeader(HEADER_AUTHORIZATION, authHeader);
		System.debug(req);
		HttpResponse res = sendHttpResponse(req);
		System.debug(res);
	}

	public void getRequestObj() {
		if (this.tokenId == null) {
			setAccessToken();
		}
		if (this.tokenId != null) {
			String authHeader = HEADER_BEARER + this.tokenId;
			HttpRequest query_req = new HttpRequest();
			query_req.setMethod(HTTP_METHOD_GET);
			query_req.setHeader(HEADER_AUTHORIZATION, authHeader);

			String u = getEndPoint();
			query_req.setEndpoint(u);

			// メソッドで返されたものを受け取る変数を設定、値を格納。新しく作成したリクエストを引数として渡す
			this.query_res = sendHttpResponse(query_req);

			System.debug('query res : ' + query_res);
			System.debug('query res body : ' + query_res.getBody());
			upsertTargetAccounts();
		}
	}

	public void upsertTargetAccounts() {
		if (query_res.getStatusCode() == 200) {
			try {
				System.debug('ここまで' + query_res.getBody());
				Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(
					query_res.getBody()
				);
				System.debug(results);
				System.debug('ここまで' + results.get(PROPERTY_RECORDS));
				List<Object> records = (List<Object>) results.get(PROPERTY_RECORDS);
				System.debug('records : ' + records);
				accDBA = new AccountDBA();
				accDBA.upsertAccounts(records);
			} catch (Exception e) {
				System.debug(
					'The following exception has occurred while get account records : ' +
					e.getMessage()
				);
			}
		} else {
			System.debug(
				'An error occurred while request to get account records. Error code:' +
				query_res.getStatusCode()
			);
		}
	}

	public String getEndPoint() {
		String u = 'https://ndics--axas01.sandbox.my.salesforce.com/services/data/v57.0/query/?' + getQuery();
		return u;
	}

	public String getQuery() {
		String q = 'SELECT%20Id,%20Name%20FROM%20Account%20LIMIT%202';
		String body = 'q=' + q;
		return body;
	}
}

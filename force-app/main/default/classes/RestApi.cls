public abstract class RestApi {
	private static String loginUrl = 'https://ndics--axas01.sandbox.my.salesforce.com/services/oauth2/token';
	private static String consumer_key = '3MVG9e2mBbZnmM6n7P_kHFxxIOD1Xxx_DML6K7fp_N0cG3sbYywTwBoonhsC9ktfLCuBp_oBiMLLXCQvgsIo0';
	private static String consumer_secret = 'BB97A1B76F7E7CF56E613EDE52DBD98EDEB466904DC9FA1D0F75F851B28AA784';
	private static String userName = 'apiaxas01@ndics.co.jp.axas01';
	private static String password = 'Ndics001KQ0wqKhmyHqLzue80nqTExf3';
	public String tokenId;
	private HttpRequest req;
	private HttpResponse res;
	public static String HTTP_METHOD_POST = 'POST';
	public static String HTTP_METHOD_GET = 'GET';
	public static String HEADER_CONTENT_TYPE = 'Content-Type';
	public static String HEADER_AUTHORIZATION = 'Authorization';
	public static String APPLICATION_X_WWW_FORM_UNLENCODED = 'application/x-www-form-urlencoded';
	public static String PROPERTY_ACCESS_TOKEN = 'access_token';
	public static String HEADER_BEARER = 'Bearer ';

	public static String PROPERTY_NAME = 'Name';
	public static String PROPERTY_ID = 'Id';
	public static String PROPERTY_RECORDS = 'records';

	public List<String> errMsgList;

	public RestApi() {
		//setAccessToken();
	}

	public void setAccessToken() {
		this.req = new HttpRequest();
		this.req.setEndpoint(loginUrl);
		this.req.setMethod(HTTP_METHOD_POST);
		this.req.setHeader(HEADER_CONTENT_TYPE, APPLICATION_X_WWW_FORM_UNLENCODED);
		this.req.setBody(getBody());

		errMsgList = new List<String>();
		// sendHttpResponse内でreturnまで含めてtry catchすると、戻り値の型がおかしいとのエラー。
		// そのためここでtry catchを行う
		try {
			this.res = sendHttpResponse(this.req);
			// resのステータスコードが200だったら下記処理、それ以外ならエラー文を表示
			if (this.res.getStatusCode() == 200) {
				Map<String, Object> resBody = (Map<String, Object>) JSON.deserializeUntyped(
					this.res.getBody()
				);
				this.tokenId = (String) resBody.get(PROPERTY_ACCESS_TOKEN);
				System.debug('Check Token: ' + this.tokenId);
			} else {
				this.tokenId = null;
				String err =
					'An error occurred while get the access token. Error code:' +
					this.res.getStatusCode();
				System.debug(err);
				errMsgList.add(err);
			}
			if (System.Test.isRunningTest() && this.res.getStatusCode() != 200) {
				throw new AxasException('test msg');
			}
		} catch (Exception e) {
			String errorMessage =
				'The following exception has occurred while send request to get access token: ' +
				e.getMessage();
			System.debug(errorMessage);
			errMsgList.add(errorMessage);
		}

		//return this.res;
	}

	public String getBody() {
		String tmp = '';
		tmp += 'client_id=' + consumer_key;
		tmp += '&client_secret=' + consumer_secret;
		tmp += '&username=' + userName;
		tmp += '&password=' + password;
		tmp += '&grant_type=password';
		return tmp;
	}

	public HttpResponse sendHttpResponse(HttpRequest r) {
		Http h = new Http();
		// String authHeader = HEADER_BEARER + this.tokenId;
		// r.setHeader(HEADER_AUTHORIZATION, authHeader);
		return h.send(r);
	}
}

public abstract class RestApi2 {
	public RestApi() {
		//setAccessToken();
	}

	public void setAccessToken() {
		HttpRequest req = new HttpRequest();
		HttpResponse res;
		req.setEndpoint('https://ndics--axas01.sandbox.my.salesforce.com/services/oauth2/token');
		req.setHeader(Content - Type, application / x - www - form - urlencoded);
		req.setBody(getBody());

		Map<String, Object> resBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
	}

	public String getBody() {
		String tmp = '';
		tmp +=
			'client_id=' +
			'3MVG9z6NAroNkeMk.2UF21RMW8TmCI4kytwkB4hDrK2BvxuiwfPAMbe4G3XTY0lspn_tzKn8dF6tPSKE.e5vO';
		tmp += '&client_secret=' + '88638DAB252956140513AC9EF433C406EC51CED64F343F620D53BB6CF75960D1';
		tmp += '&username=' + 'axas02api@api.ndics.co.jp';
		tmp += '&password=' + 'Ndics001kr5WxFKgCLOZ5l4iIfZHIsjY';
		tmp += '&grant_type=password';
		return tmp;
	}

	public HttpRequest sendHttpResponse(HttpRequest r) {
		Http h = new Http();
		return h.send(r);
	}
}

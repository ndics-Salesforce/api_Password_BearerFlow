public with sharing class AxasDesignatedLogin {
	public AxasDesignatedLogin() {
	}
	// ヘッダーが必要かも。
	public void axasGetTest() {
		String url = 'callout:OldAxas01/test1';
		HttpRequest req = new HttpRequest();
		req.setEndpoint(url);
		req.setMethod('GET');
		// req.setHeader(HEADER_AUTHORIZATION, authHeader);
		System.debug(req);
		HttpResponse res = sendHttpResponse(req);
		System.debug(res);
	}
	public HttpResponse sendHttpResponse(HttpRequest r) {
		Http h = new Http();
		return h.send(r);
	}
}

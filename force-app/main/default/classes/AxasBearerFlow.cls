public with sharing class AxasBearerFlow {
	public AxasBearerFlow() {
	}
	public void getAccounts() {
		HttpRequest req = new HttpRequest();
		req.setEndpoint('callout:JwtBearerTokenFlow/services/data/v57.0/query/?q=SELECT+name+from+Account');
		req.setMethod('GET');
		Http http = new Http();
		HTTPResponse res = http.send(req);
		System.debug(res.getBody());
		Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
		System.debug(results);
		List<Object> records = (List<Object>) results.get('records');
		System.debug('records : ' + records);
	}
}

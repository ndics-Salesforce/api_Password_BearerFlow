public with sharing class AxasClientAPIAX03 {
    // カスタム設定で登録しておく
    String loginUrl = 'https://axas-si--ax03.sandbox.my.salesforce.com/services/oauth2/token';
    String consumer_key = '3MVG9iLRabl2Tf4jUa3WiI_X.YhB2n5tfbr7B2KcaNhkpITU3ZaPZF9HXgom3Y6ZGeuzLKxv3iTarHBD4__RM';
    String consumer_secret = 'C2F6BC46F228BBE6F7E22EB317965B82E3B546ADC463C36BD1EFC641F22AF8FA';
    String userName = 'apitest@ax03.ndics.co.jp';
    String tokenId;
    HttpRequest req;
    public AxasClientAPIAX03() {
        setAccessToken();
    }
    public void setLoginInfo(String url, String c_key, String c_secret, String uName) {
        this.loginUrl = url;
        this.consumer_key = c_key;
        this.consumer_secret = c_secret;
        this.userName = uName;
    }

    public String getBody() {
        String tmp ='';
        tmp += 'client_id='+this.consumer_key;
        tmp += '&client_secret='+this.consumer_secret;
        tmp += '&username='+this.userName;
        tmp += '&password=Ndics001Qr1ZYGOTrgluiL7EgXxIsAyb';
        tmp += '&grant_type=password';
        System.debug('hosonuma'+tmp);
        return tmp;
    }

    public void setAccessToken() {
        this.req = new HttpRequest();
        req.setEndpoint(this.loginUrl);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(getBody());
        Http h = new Http();
        HttpResponse res = h.send(req);
        Map<String,Object> resBody = (Map<String,Object>) JSON.deserializeUntyped(res.getBody());
        // System.debug('hosonuma:'+resBody.get('access_token'));
        this.tokenId = (String) resBody.get('access_token');
        // User u = [SELECT Id, Name, AboutMe FROM User WHERE Id = :UserInfo.getUserId()];
        // System.debug(u);
        // u.AboutMe = tokenId;
        // Update u;
        System.debug(tokenId);
        // getRequestObjの呼び出し
        // HttpResponse record = getRequestObj();
    }

    public void getRequestObj() {
        String authHeader = 'Bearer '+tokenId;
        this.req = new HttpRequest();
        req.setHeader('Authorization', authHeader);
        req.setHeader('Content-Type', 'application/json;charset=utf-8');
        String u = 'https://axas-si--ax03.sandbox.my.salesforce.com/services/data/v57.0/query/';
        // String u = 'https://ndics--axas01.sandbox.my.salesforce.com/services/data/v56.0/query/?'+getAccounts();
        // String url = EncodingUtil.urlEncode(u, 'UTF-8');
        // req.setEndpoint('callout:Test/services/data/v57.0/');
        // System.debug(u);
        req.setEndpoint(u);
        req.setBody(getAccounts());
        // req.setEndpoint(url);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.debug(res);
        // List<Account> acc = new List<Account>();
        // acc.add(res);
    }

    public String getAccounts() {
        String q = 'SELECT%20Id,%20Name%20FROM%20Account%20LIMIT%202';
        String body = 'q='+q;
        return body;
    }
}
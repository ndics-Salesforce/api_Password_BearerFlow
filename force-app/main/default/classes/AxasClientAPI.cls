public with sharing class AxasClientAPI {
    // カスタム設定で登録しておく
    String loginUrl = 'https://ndics--axas01.sandbox.my.salesforce.com/services/oauth2/token';
    String consumer_key = '3MVG9e2mBbZnmM6n7P_kHFxxIOD1Xxx_DML6K7fp_N0cG3sbYywTwBoonhsC9ktfLCuBp_oBiMLLXCQvgsIo0';
    String consumer_secret = 'BB97A1B76F7E7CF56E613EDE52DBD98EDEB466904DC9FA1D0F75F851B28AA784';
    String userName = 'apiaxas01@ndics.co.jp.axas01';
    String authorizationHeader = 'Bearer ';
    String tokenId;
    HttpRequest req;
    public AxasClientAPI() {
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
        tmp += '&password=Ndics001KQ0wqKhmyHqLzue80nqTExf3';
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
        System.debug(tokenId);
        // getRequestObjの呼び出し
        // HttpResponse record = getRequestObj();
    }

    public void getRequestObj() {
        String authHeader = 'Bearer '+tokenId;
        System.debug(authHeader);
        this.req = new HttpRequest();
        // URLをエンコードして送信してみる
        String u = 'https://ndics--axas01.sandbox.my.salesforce.com/services/data/v56.0/query/?'+getAccounts();
        String url = EncodingUtil.urlEncode(u, 'UTF-8');
        req.setBody(getAccounts());
        req.setHeader('Authorization', authHeader);
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setEndpoint(url);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.debug(res);
        // return res;
    }

    public String getAccounts() {
        String q = 'SELECT Id, Name FROM Account LIMIT 2';
        String body = 'q='+q;
        return body;
    }

}
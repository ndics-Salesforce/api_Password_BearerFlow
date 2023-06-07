public with sharing class AxasClientAPI2 {
    // カスタム表示ラベルにて変数は設定
    String loginUrl = System.label.loginUrl;
    String consumer_key = System.label.consumer_key;
    String consumer_secret = System.label.consumer_secret;
    String userName = System.label.userName;
    String tokenId;
    HttpRequest req;

    public AxasClientAPI2() {
        setAccessToken();
    }

    public void setLoginInfo(String url, String c_key, String c_secret, String uName) {
        this.loginUrl = url;
        this.consumer_key = c_key;
        this.consumer_secret = c_secret;
        this.userName = uName;
    }

    public String getBody() {
        String tmp = '';
        tmp += 'client_id='+this.consumer_key;
        tmp += '&client_secret='+this.consumer_secret;
        tmp += '&username='+this.userName;
        tmp += '&password=Ndics001KQ0wqKhmyHqLzue80nqTExf3';
        tmp += '&grant_type=password';
        System.debug('bodyテキストテスト'+tmp);
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
        Map<String, Object> resBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
        this.tokenId = (String) resBody.get('access_token');
    }

    public void getRequestObj() {
        String authHeader = 'Bearer '+tokenId;
        System.debug(tokenId);
        this.req = new HttpRequest();
        req.setHeader('Authorization', authHeader);
        req.setHeader('Content-Type', 'application/json;charset=utf-8');
        String url = 'https://ndics--axas01.sandbox.my.salesforce.com/services/data/v56.0/';
        req.setEndpoint(url);
        System.debug(url);
        req.setBody(getAccounts());
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse res = h.send(req);
        System.debug(res);
        System.debug(res.getBody());
    }
    // public void getRequestObj() {
    //     String authHeader = 'Bearer '+tokenId;
    //     System.debug(tokenId);
    //     this.req = new HttpRequest();
    //     req.setHeader('Authorization', authHeader);
    //     req.setHeader('Content-Type', 'application/json;charset=utf-8');
    //     String url = 'https://ndics--axas01.sandbox.my.salesforce.com/services/data/v56.0/query/?'+getAccounts();
    //     req.setEndpoint(url);
    //     System.debug(url);
    //     req.setBody(getAccounts());
    //     req.setMethod('GET');
    //     Http h = new Http();
    //     HttpResponse res = h.send(req);
    //     System.debug(res);
    //     System.debug(res.getBody());
    // }

    public String getAccounts() {
        String q = 'SELECT Id, Name FROM Account LIMIT 2';
        // String q = 'SELECT%20Id,%20Name%20FROM%20Account%20LIMIT%202';
        String body = 'q='+q;
        return body;
    }
}
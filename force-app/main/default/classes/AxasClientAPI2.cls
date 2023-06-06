public with sharing class AxasClientAPI2 {
    // カスタム表示ラベルにて変数は設定
    String loginUrl = System.label.loginUrl;
    String consumer_key = System.label.consumer_key;
    String consumer_secret = System.label.consumer_secret;
    String userName = System.label.userName;
    HttpRequest req;

    public AxasClientAPI2() {
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
        System.debug('hosonuma:'+resBody.get('access_token'));
    }

    // public void getRequestObj() {
    //     String authHeader = 'Bearer ';
    //     this.req = new HttpRequest();
    //     req.setHeader('Authorization', authHeader);
    // }
}
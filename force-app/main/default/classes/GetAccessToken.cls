public with sharing class GetAccessToken {
    public GetToken() {

        // 下記のクライアントIDなどは、tedev01のものなので変更して使用すること
        String client_id = '3MVG9Nvmjd9lcjRnfjshOzKilRpiXgTq4Z..emV9WjjVtYoyoJHrRQVsQiU196Zoo8GfCk0cAsM368ix7VVWA';
        String client_secret = 'D75CAC8CE1E9CBCE5446440EFB24A29DF420E57E70EDC238EB4F64784284313B';
        String username = 'apitest@ndics.co.jp.tedev01';
        String password = 'Ndics001MVoTxPg7mk9JEvjAgRfMtzR3';
        String Endpoint = 'https://test.salesforce.com/services/oauth2/token';
        String grant_type = 'password';

        /**
        Map<String, String> param = new Map<String, String>();
        param.put('client_id', client_id);
        param.put('client_secret', client_secret);
        param.put('username', username);
        param.put('password', password);
        param.put('grant_type', grant_type);
        */


        // 下記はエンコードする方法
        /**
        Map<String, String> param = new Map<String, String>();
        param.put('client_id', EncodingUtil.urlEncode(client_id, 'UTF-8'));
        param.put('client_secret', EncodingUtil.urlEncode(client_secret, 'UTF-8'));
        param.put('username', EncodingUtil.urlEncode(username, 'UTF-8'));
        param.put('password', EncodingUtil.urlEncode(password, 'UTF-8'));
        param.put('grant_type', EncodingUtil.urlEncode(grant_type, 'UTF-8'));
        **/

        Integer httpStatusCode = 0;

        String paramToString = JSON.serialize(param);

        system.debug(paramToString);

        HttpRequest req = new HttpRequest();
            req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            req.setMethod('POST');
            req.setEndpoint(Endpoint);
            req.setCompressed(false);
            req.setHeader('Connection', 'close');
            // req.setBody(paramToString);

            // 下記はbodyの中で直書きする方法。
            req.setBody(
            'grant_type=password' +
            '&client_id=3MVG9Nvmjd9lcjRnfjshOzKilRpiXgTq4Z..emV9WjjVtYoyoJHrRQVsQiU196Zoo8GfCk0cAsM368ix7VVWA' +
            '&client_secret=D75CAC8CE1E9CBCE5446440EFB24A29DF420E57E70EDC238EB4F64784284313B' +
            '&username=apitest@ndics.co.jp.tedev01' +
            '&password=Ndics001MVoTxPg7mk9JEvjAgRfMtzR3'
            );

            system.debug(req);

        Http h = new Http();
            req.setTimeout(120000);
            Datetime callBeginDt = Datetime.now();
            HttpResponse res = h.send(req);
            Datetime callFinishDt = Datetime.now();
            httpStatusCode = res.getStatusCode();
            System.debug(Logginglevel.INFO, '[API-Tiger][REQ]URL:' + req.getEndpoint());
            System.debug(Logginglevel.INFO, '[API-Tiger][REQ]BODY:' + req.getBody());
            System.debug( Logginglevel.INFO, '[API-][RES]HTTPSTATUS:' + String.valueOf(httpStatusCode));
            System.debug(Logginglevel.INFO, '[API-][RES]BODY:' + res.getBody());
            System.debug( Logginglevel.INFO, '[API-][TIME]:' +
            String.valueOf(callFinishDt.getTime() - callBeginDt.getTime()) + ' ' +
            callBeginDt.format('yyyy-MM-dd HH:mm:ss.SSS', 'Japan') + ' ' +
            callFinishDt.format('yyyy-MM-dd HH:mm:ss.SSS', 'Japan'));

    }
}
/**
 *  TigerEye 接続 API
 *
 *
 * ーーー以下プロセスーーー
1.認可リクエストを送ると、顔認証画面に遷移します。

2.認証後、任意のリダイレクトURLにリダイレクトされます(これは管理画面から設定します)

3.リダイレクトURLについた、認可コードで、トークンリクエストを発行します

4.取得したトークンをヘッダにいれて、リクエストします。(ここで、person_idがかえされます。

client_id=${発行されたクライアントID}
code_challenge=${BASE64URL-ENCODE(SHA256(ASCII(code_verifier)))}
state=${任意のトークン}

# ユーザ情報取得リクエスト
https://dev2.tigerbalance.singularitytech.ai/ex/v1/person/info
"Authorization","Bearer " + ${アクセストークン}
 */
public with sharing class TigerEyeAPI {
	// token url
    //# トークンエンドポイントへのリクエスト
    //method: POST / Content-Type: multipart/form-data;
    //code_verifier=${code_challengeに使用した文字列}
    //grant_type="authorization_code"
    //client_id=${発行されたクライアントID}
    //client_secret=${発行されたシークレットID}
    //code=${認可コード} // 3217  

    private static final String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz';
    private static final String TIGER_URL = 'https://dev2.tigerbalance.singularitytech.ai';
    //private static final String TIGER_URL = 'TygerEye';
	private static final String apiBaseUrl = TIGER_URL + '/ex/v1/oauth';
    private static final String token_Url = TIGER_URL + '/ex/v1/oauth/token';
	// HTTP Method for this type REST API
    // method: GET
	private static final String HTTP_METHOD_TYPE_GET = 'GET';
    // method: POST
	private static final String HTTP_METHOD_TYPE_POST = 'POST';
	private static final String client_id = 'FilFhycIx2utQ30TMnfRHtbx6vr9rAt78WVeCrw48VPEaRkilzRhCqwcS45aUkYQ';
	private static final String client_secret = 'LanawoAreGRI6bzXFaFgCmvJoXh35IwY7Wt4z1fOsoPUquHJBhXwK7EjBw1MrF1AHl-WisYrhLnpCn1cIgG3YQ';
	public String url ='';
	private String code_verifier ='';
	private String code_challenge ='';
	// HTTP Request
	public HttpRequest req;
	public String requestBody;
	// HTTP Response
	private HttpResponse res;
	public Integer httpStatusCode;
	//constractor
    public TigerEyeAPI() {
		//set  code_verifier code_challenge
		setCodeDetails();
	}
	/**
	 * Build GET Request string
	 * # 認可エンドポイントへのリクエスト https://dev2.tigerbalance.singularitytech.ai/ex/v1/oauth
	 */
	public void buildRequest1() {
		Map<String, String> paramMap = new Map<String,String>();
		setCodeRequest(paramMap);
		sendHttpRequest();
	}

    public void buildToken (){
		Map<String, String> paramMap = new Map<String,String>();
		setTokenRequest(paramMap);
		sendHttpRequest();
    }
	/**
	 * Call API
	 */
	public void callApi() {
	}
	/**
	 * Build GET Request string
	 * @param Map<String, String> Map of parameters (Key:Value)
	 *	method: GET
	 *	response_type=code
	 *	client_id=${発行されたクライアントID}
	 * 	code_challenge=${BASE64URL-ENCODE(SHA256(ASCII(code_verifier)))}
	 * 	state=${任意のトークン}
	 */
	public void setCodeRequest(Map<String, String> paramMap) {
		paramMap.put('response_type','code');
		paramMap.put('client_id', client_id);
		paramMap.put('code_challenge', code_challenge);
		paramMap.put('state',code_challenge);
		Set<String> paramsKey = paramMap.keySet();

		list<String> tmp = new list<String>();
		Map<String, String> paramString = new Map<String, String>();
		for (String key : paramsKey) {
			//paramString.add(key + '=' + EncodingUtil.urlEncode(paramMap.get(key), 'UTF-8'));
			paramString.put(key, EncodingUtil.urlEncode(paramMap.get(key), 'UTF-8'));
			tmp.add(key+'='+ EncodingUtil.urlEncode(paramMap.get(key), 'UTF-8'));
		}

		String param2 =  String.join(tmp, '&');
		//String param =  String.join(paramString, '&');
		String param = Json.serialize(paramString);
		String requestUrl = apiBaseUrl + '?' + param2;
		System.debug('[REQ]URL:' + requestUrl);
		this.req = new HttpRequest();
		this.req.setHeader('Content-Type', 'application/json; charset=utf-8');
		this.req.setMethod(HTTP_METHOD_TYPE_GET);
		this.req.setEndpoint(requestUrl);
		this.req.setCompressed(false);
		this.req.setHeader('Connection', 'close');
		this.req.setBody(param);
		system.debug(param);
		this.res = null;
	}
	/**
	 * Send Http Request Informations
	 */
	@TestVisible
	private void sendHttpRequest() {
		try {
			Http h = new Http();
			this.req.setTimeout(120000);
			Datetime callBeginDt = Datetime.now();
			this.res = h.send(this.req);
			Datetime callFinishDt = Datetime.now();
			this.httpStatusCode = this.res.getStatusCode();
			System.debug(Logginglevel.INFO, '[API-Tiger][REQ]URL:' + req.getEndpoint());
			System.debug(Logginglevel.INFO, '[API-Tiger][REQ]BODY:' + req.getBody());
			System.debug( Logginglevel.INFO, '[API-][RES]HTTPSTATUS:' + String.valueOf(this.httpStatusCode));
			System.debug(Logginglevel.INFO, '[API-][RES]BODY:' + this.res.getBody());
			System.debug( Logginglevel.INFO, '[API-][TIME]:' +
			String.valueOf(callFinishDt.getTime() - callBeginDt.getTime()) + ' ' +
			callBeginDt.format('yyyy-MM-dd HH:mm:ss.SSS', 'Japan') + ' ' +
			callFinishDt.format('yyyy-MM-dd HH:mm:ss.SSS', 'Japan'));
		} catch (Exception e) {
			system.debug(e.getMessage());
			throw e;
		}
	}
	/**
	 * Check Response data
	 * @throws  If API Response has Error Information
	 */
	@TestVisible
	private void checkResponseError() {
		String errorMsg = '';
		try {
			if (200 != this.httpStatusCode) {

			}
		} catch (Exception e) {
			throw e;
		}
	}
	/**
	 * Parse Http Response(JSON string) to Response Object
	 */
	@TestVisible
	private void parseHttpResponse() {
		try {
			if (200 == this.httpStatusCode) {
				//this.responseData = parseJSON(this.res.getBody());
			} else {
				//this.errorResponseData = parseJSON(this.res.getBody());
			}
		} catch (Exception e) {
			throw e;
		}
	}
	/**
	 * 2.トークンリクエスト
	 */
	public void setTokenRequest(Map<String, String> paramMap){
	// API Endpoint URL  認可エンドポイ	paramMap.put('response_type','code');
		paramMap.put('client_id', client_id);
		paramMap.put('client_secret', client_secret);
		code_challenge = 'NS5xUJUzZgmPUZ-MY8-cgaS7F20LCfXzq-jpnLbvIT0';
		String ncode = 'dfimxRkPmWTy2j-9yUR0S_pxidcclI8ao7rDGcAL8DlMOT390XifSw';
		if(!String.isBlank(url)){
			Map<String,String> urlMap = getParamMap();
			ncode = urlMap.get('code');
			code_challenge = urlMap.get('state');
		}
		paramMap.put('code_verifier', code_challenge);
		paramMap.put('grant_type','authorization_code');
		//code=QNhiH1ESUXzFAWo8rfsjgzPKCRdxY0oADwPIOwHNhP7CFMvU50_spw&state=OUGpXCTt9SIGNu0f3JM4dg4UqNmaN0GZjpEDxqBclLM
		paramMap.put('code',ncode);

		Set<String> paramsKey = paramMap.keySet();

		Map<String, String> paramString = new Map<String, String>();
		for (String key : paramsKey) {
			paramString.put(key, EncodingUtil.urlEncode(paramMap.get(key), 'UTF-8'));
			//paramString.put(key, paramMap.get(key));
		}

		String param = Json.serialize(paramString);
		String apiEndpointUrl = token_Url ;
		apiEndpointUrl += '?client_id='+client_id + '&client_secret=' + client_secret;
		apiEndpointUrl += '&grant_type=authorization_code'+'&code='+ncode;
		apiEndpointUrl += '&code_verifier=' + code_challenge;
		this.req = new HttpRequest();
		//req.setHeader('Content-Type', 'multipart/form-data');
		req.setMethod('POST');
		req.setEndpoint(apiEndpointUrl);
		req.setCompressed(false);
		req.setHeader('Connection', 'close');
		req.setBody(param);
		system.debug(param);
		//this.res = null;
	}
	/**
	 * code_challenge=${BASE64URL-ENCODE(SHA256(ASCII(code_verifier)))}
	 */
    public void setCodeDetails(){
        code_verifier  = generateRandomString(34);
    	Blob sha256    = Crypto.generateDigest('SHA-256', Blob.valueOf(code_verifier));
        code_challenge = base64URLencode(sha256);
    }
	/**
	 * base64
	 */
    private String base64URLencode(Blob input){
        String output = EncodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while ( output.endsWith('=')){
            output = output.subString(0,output.length()-1);
        }
        return output;
    }
	/**
	 * Create Rndom  Str
	 */
    private String generateRandomString(Integer len) {
        String randStr = '';
        while (randStr.length() < len) {
            Integer idx = Math.mod(Math.abs(Crypto.getRandomInteger()), chars.length());
            randStr += chars.substring(idx, idx+1);
        }
        return randStr;
    }
	public Map<String,String> getParamMap(){
	    list<String> stls = url.split('\\?');
		list<String> params = stls[1].split('&');
		Map<String,String> pMap = new Map<String,String>();
		for(String s : params){
 		   list<String> ps = s.split('=');
	  	  pMap.put(ps[0],ps[1]);
		}
		system.debug(pMap);
		return pMap;
	}

}


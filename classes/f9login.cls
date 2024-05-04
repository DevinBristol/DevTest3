public class f9login {
    public String F9LoginReq(){
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://app.five9.com/supsvcs/rs/svc/auth/login');
        req.setHeader('Content-Type','application/json');
        req.setBody('{"passwordCredentials":{"username":"syncerfn@gmail.com","password":"Alpha10Gas!"},"policy":"ForceIn"}');
        String reqString = JSON.serialize(req);
        return reqString;
    }
    @future(Callout=true)
    public static void f9loginCallout(reqString){
        insert
        HttpRequest LoginReq = new HttpRequest();
    }
    public static HttpResponse makePostCallout(){
    	Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint('https://app.five9.com/supsvcs/rs/svc/auth/login');
    	request.setMethod('POST');
    	request.setHeader('Content-Type', 'application/json');
    	request.setBody('{"passwordCredentials":{"username":"syncerfn@gmail.com","password":"Alpha10Gas!"},"policy":"ForceIn"}');
    	HttpResponse response = http.send(request);
    //check for responsecode==200
    	if(response.getStatusCode() == 200){
        //deserialize full JSON response into primitivedatatype collections
            system.debug(response.getBody());
        } else {
            system.debug('Status Code '+ response.getStatusCode()+ ' '+ response.getStatus());
        }
        return response;
    }
    
}
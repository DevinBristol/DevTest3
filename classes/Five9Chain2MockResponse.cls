/**
 * Created by Devin on 5/1/2024.
 */
@IsTest
global class Five9Chain2MockResponse implements HttpCalloutMock{

    // Implement the HttpCalloutMock interface
    global HttpResponse respond(HttpRequest req) {

        String jsonData;
        String Headerkey = 'Content-Type';
        String Headervalue = 'application/json';
        String endPoint = req.getEndpoint();
        Integer responseCode;
        if(endPoint.endsWith('voicecalls')){ //post Voicecall to SF
            responseCode = 201;
            jsonData = '{ "calls": [ { "errorMsg": null, "externalId": "163099", "isSuccess": true, "uploadUrl": "https://bristolnebraska.my.salesforce.com/services/data/v60.0/voicecalls/0LQR7000000p27p/audio_upload", "voiceCallId": "0LQR7000000p27p" } ] }';

        }
        else if(endPoint.endsWith('/auth/login')){ //five9Login
            jsonData = '{ "tokenId": "a2ef69b0-07f1-11ef-e662-df316d04618c", "sessionId": "1e234ad6cd7843c15abd51905db26b935b3222a796cb378f5938272a8adb976a", "orgId": "138083", "userId": "4764534", "context": { "cloudClientUrl": "https://api.prod.us.five9.net/", "pwdExpiryDays": "269", "cloudTokenUrl": "https://api.prod.us.five9.net/", "farmId": "71" }, "metadata": { "freedomUrl": "https://app.five9.com", "dataCenters": [ { "name": "Santa Clara Data Center", "uiUrls": [ { "host": "app-scl.five9.com", "port": "443", "routeKey": "SCLUI2zOFh", "version": "13.0.247" } ], "apiUrls": [ { "host": "app-scl.five9.com", "port": "443", "routeKey": "SCLAPIPXB6", "version": "13.0.247" } ], "loginUrls": [ { "host": "app-scl.five9.com", "port": "443", "routeKey": "SCLLGNYoI4", "version": "13.0.244" } ], "active": true } ] } }';
            responseCode = 200;
        }
        else if(endPoint.endsWith('session_start?force=true')){ //five9sessionstart
            responseCode = 204;
            jsonData = '0';
        }
        else if(endPoint.endsWith('login_state')){ //five9checksession
            responseCode = 200;
            jsonData = '"WORKING"';
        }
        else if(endPoint.endsWith('recording_views')){ //five9checksession
            responseCode = 200;
            jsonData = '{"id":"9f690627-f36d-4a02-a780-a1b4d6c7e0a8","records":[{"id":"163835","campaignId":"20","created":1714609393938,"number":"7128802900","name":"","length":449620,"status":"WAITING_FOR_UPLOAD","callSessionId":"69A2ABFB220B4D37825480B109C72F54"}],"recordsTotal":3739,"hasMore":true,"currentPage":0}';
        }
        else if(endPoint.endsWith('?download=true')){ //five9GetRecording
            responseCode = 200;

            jsonData = '{"id":"9f690627-f36d-4a02-a780-a1b4d6c7e0a8","records":[{"id":"163835","campaignId":"20","created":1714609393938,"number":"7128802900","name":"","length":449620,"status":"WAITING_FOR_UPLOAD","callSessionId":"69A2ABFB220B4D37825480B109C72F54"}],"recordsTotal":3739,"hasMore":true,"currentPage":0}';


        }

        else if(endPoint.endsWith('audio_upload')){ //post recording to SF
            responseCode = 204;
            jsonData = '{"id":"9f690627-f36d-4a02-a780-a1b4d6c7e0a8","records":[{"id":"163835","campaignId":"20","created":1714609393938,"number":"7128802900","name":"","length":449620,"status":"WAITING_FOR_UPLOAD","callSessionId":"69A2ABFB220B4D37825480B109C72F54"}],"recordsTotal":3739,"hasMore":true,"currentPage":0}';

        }

        HttpResponse res = new HttpResponse();
        res.setHeader(Headerkey,Headervalue);
        res.setBody(jsonData);
        res.setStatusCode(responseCode);
        return res;

    }

}
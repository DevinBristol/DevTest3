/**
 * Created by Devin on 5/2/2024.
 */

public with sharing class PostVoiceCallChain {


    public static void PostVCtoSF(String taskId) {
        String JsonInput;
        String uploadUrl;
        String sessionIdpar1 = UserInfo.getOrganizationId().substring(0, 15);
        String sessionIdpar2 = UserInfo.getSessionId().substring(15);


        Task task = [SELECT Id, OwnerId, Five9DNIS__c, Five9TalkAndHoldTimeInSeconds__c, CreatedDate, Five9ANI__c, CallType, Five9__Five9SessionId__c, WhoId, Five9AgentId__c FROM Task WHERE Id = :taskId LIMIT 1];
        System.debug(task.Five9TalkAndHoldTimeInSeconds__c);
        Datetime EndTime = task.CreatedDate;
        Integer minusSeconds = (Integer) task.Five9TalkAndHoldTimeInSeconds__c;

        Datetime startTime = EndTime.addSeconds(-minusSeconds);

        String StartDate = startTime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        System.debug(StartDate);

        String EndDate = EndTime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        System.debug(EndDate);

        JsonInput = '{"calls":[{"mediaProviderId":"0hnSu00000000ODIAY","userId":"' + task.OwnerId + '","toPhoneNumber":"' + task.Five9DNIS__c + '","fromPhoneNumber": "' + task.Five9ANI__c + '","startDateTime": "' + StartDate + '","endDateTime":"' + EndDate + '","callType": "' + task.CallType + '","recordingDuration":"' + task.Five9TalkAndHoldTimeInSeconds__c + '","externalId": "' + task.Five9__Five9SessionId__c + '","recordingFormat": "mp3","activityId":"' + task.Id + '","recordId":"' + task.WhoId + '"}]}';

        // First Http
        // Post VoiceCall to Salesforce Sandbox DevTest
        Http http = new Http();
        HttpRequest req = settupPostVCToSF(sessionIdpar1, sessionIdpar2, JsonInput);
        HttpResponse res = Http.send(req);
        System.debug(res.getBody());

        uploadUrl = HandlePostVCToSFBody(res);

        String Five9AgentId = task.Five9AgentId__c;
        String Five9CallSessionId = task.Five9__Five9SessionId__c;

        // Second Http
        // Login to Five9
        Http http1 = new Http();
        HttpRequest req1 = settupLoginToFive9();
        HttpResponse res1 = Http.send(req1);
        System.debug(res1.getBody());

        List<Object> Strings = handleLoginToFive9Body(res1);

    }


    // PostVCToSF Handlers
    //
    public static HttpRequest settupPostVCToSF(String sessionIdpar1, String sessionIdpar2, String JsonInput) {

        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint('https://bristolnebraska--testingdev.sandbox.my.salesforce.com/services/data/v60.0/voicecalls');
        req.setHeader('Authorization', 'Bearer ' + sessionIdpar1 + '' + sessionIdpar2);
        req.setBody(JsonInput);
        return req;
    }

    private static String HandlePostVCToSFBody(HttpResponse res) {
        String uploadUrl;
        JSONParser parser = JSON.createParser(res.getBody());
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'uploadUrl') {
                parser.nextToken();
                uploadUrl = parser.getText();
            }
        }
        System.debug(uploadUrl);
        Return uploadUrl;
    }

    // Five9 Login Handlers
    //
    private static HttpRequest settupLoginToFive9() {

        HttpRequest req1 = new HttpRequest();
        req1.setHeader('Content-Type', 'application/json');
        req1.setMethod('POST');
        req1.setEndpoint('https://app-scl.five9.com/supsvcs/rs/svc/auth/login');
        req1.setBody('{"passwordCredentials":{"username":"syncerfn@gmail.com","password":"Alpha10Gas!"},"policy":"ForceIn"}');
        return req1;
    }

    private static List<Object> handleLoginToFive9Body(HttpResponse res1) {

        String tokenId;
        String sessionId;
        String farmId;
        List<Object> LoginResponseF9 = (List<Object>)JSON.deserializeUntyped(res1.getBody());

        JSONParser parser = JSON.createParser(res1.getBody());
        while (parser.nextToken() != null) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'tokenId') {
                parser.nextToken();
                tokenId = parser.getText();
            } else if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'sessionId') {
                parser.nextToken();
                sessionId = parser.getText();
            } else if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'farmId') {
                parser.nextToken();
                farmId = parser.getText();
            }

        }
        return LoginResponseF9;
    }
}
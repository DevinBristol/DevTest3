/**
 * Created by Devin on 4/29/2024.
 */

public with sharing class Five9Chain2 {


        @Future(Callout=true)
    public static void PostVoiceCalltoSF(String taskId)
    {
        String JsonInput;
        String uploadUrl;
        String sessionIdpar1 = UserInfo.getOrganizationId().substring(0,15);
        String sessionIdpar2 = UserInfo.getSessionId().substring(15);

        Task task = [SELECT Id, OwnerId, Five9DNIS__c,Five9TalkAndHoldTimeInSeconds__c, CreatedDate, Five9ANI__c,CallType, Five9__Five9SessionId__c, WhoId, Five9AgentId__c FROM Task WHERE Id = :taskId LIMIT 1];
        System.debug(task.Five9TalkAndHoldTimeInSeconds__c);
        Datetime EndTime = task.CreatedDate;
        Integer minusSeconds = (Integer)task.Five9TalkAndHoldTimeInSeconds__c;

        Datetime startTime = EndTime.addSeconds(-minusSeconds);

        String StartDate = startTime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        System.debug(StartDate);

        String EndDate = EndTime.formatGmt('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        System.debug(EndDate);
        JsonInput = '{"calls":[{"mediaProviderId":"0hnSu00000000ODIAY","userId":"'+task.OwnerId+'","toPhoneNumber":"'+task.Five9DNIS__c+'","fromPhoneNumber": "'+task.Five9ANI__c+'","startDateTime": "'+StartDate+'","endDateTime":"'+EndDate+'","callType": "'+task.CallType+'","recordingDuration":"'+task.Five9TalkAndHoldTimeInSeconds__c+'","externalId": "'+task.Five9__Five9SessionId__c+'","recordingFormat": "mp3","activityId":"'+task.Id+'","recordId":"'+task.WhoId+'"}]}';

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setEndpoint('https://bristolnebraska--testingdev.sandbox.my.salesforce.com/services/data/v60.0/voicecalls');
        req.setHeader('Authorization', 'Bearer '+sessionIdpar1+''+sessionIdpar2);
        req.setBody(JsonInput);
        HttpResponse res = http.send(req);
        System.debug(res.getBody());

        JSONParser parser = JSON.createParser(res.getBody());
        while(parser.nextToken() != null){
            if(parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'uploadUrl'){
                parser.nextToken();
                uploadUrl = parser.getText();
            }
        }
        System.debug(uploadUrl);

        String Five9AgentId = task.Five9AgentId__c;
        String Five9CallSessionId = task.Five9__Five9SessionId__c;
        Five9Login1(Five9CallSessionId,(String)uploadUrl, (String)Five9AgentId);
    }
    public static void Five9Login1(String Five9CallSessionId, String uploadUrl, String Five9AgentId)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setMethod('POST');
        req.setEndpoint('https://app-scl.five9.com/supsvcs/rs/svc/auth/login');
        req.setBody('{"passwordCredentials":{"username":"syncerfn@gmail.com","password":"Alpha10Gas!"},"policy":"ForceIn"}');
        HttpResponse res = http.send(req);

        System.debug(res.getBody());
        String tokenId;
        String sessionId;
        String farmId;
        JSONParser parser = JSON.createParser(res.getBody());
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
        System.debug(tokenId + ' ' + sessionId);
        Five9Put((String) tokenId, (String) sessionId, (String) farmId, (String) Five9CallSessionId,(String)uploadUrl, (String) Five9AgentId);
    }


    public static void Five9Put(String tokenId, String SessionId, String farmId, String Five9CallSessionId, String uploadUrl, String Five9AgentId)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('PUT');
        req.setEndpoint('https://app-scl.five9.com/supsvcs/rs/svc/supervisors/4764534/session_start?force=true');
        req.setBody('{"stationId":null,"stationType":"EMPTY"}');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', tokenId);
        req.setHeader('Session-Id', SessionId);
        req.setHeader('farmId', farmId);
        HttpResponse res = http.send(req);
        System.debug(res.getBody());

        Five9GetSes((String) tokenId, (String) SessionId, (String) farmId, (String) Five9CallSessionId,(String)uploadUrl, (String) Five9AgentId);
    }

    public static void Five9GetSes(String tokenId, String SessionId, String farmId, String Five9CallSessionId, String uploadUrl, String Five9AgentId)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://app-scl.five9.com/supsvcs/rs/svc/supervisors/4764534/login_state');
        req.setHeader('Authorization', tokenId);
        req.setHeader('Session-Id', SessionId);
        req.setHeader('farmId', farmId);
        HttpResponse res = http.send(req);
        System.debug(res.getBody());

        Five9DisplayRecordings((String) tokenId, (String) SessionId, (String) farmId, (String) Five9CallSessionId, (String)uploadUrl, (String) Five9AgentId);
    }

    public static void Five9DisplayRecordings(String tokenId, String SessionId, String farmId, String Five9CallSessionId, String uploadUrl, String Five9AgentId)
    {

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://app-scl.five9.com/supsvcs/rs/svc/supervisors/4764534/agents/'+Five9AgentId+'/recording_views');
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', tokenId);
        req.setHeader('Session-Id', SessionId);
        req.setHeader('farmId', farmId);
        req.setBody('{"limit":5,"sortField":"CREATED","ascending":false,"showUploaded":true}');
        HttpResponse res = http.send(req);
        System.debug(res.getBody());
        String five9session = Five9CallSessionId;
        JSONParser parser = JSON.createParser(res.getBody());
        String recordingId;
        while (parser.nextToken() != null && parser.getText() != five9session) {
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'id'){
                parser.nextToken();
                recordingId = parser.getText();
            }

        }
        System.debug(recordingId);
        Five9GetRecordingFile((String)tokenId,(String)SessionId,(String)recordingId, (String) farmId, (String) Five9CallSessionId, (String)uploadUrl, (String) Five9AgentId);
    }


    public static void Five9GetRecordingFile(String tokenId, String SessionId, String recordingId, String farmId, String Five9CallSessionId, String uploadUrl, String Five9AgentId)
    {
        Blob responseFile;
        String sessionIdpar1;
        String sessionIdpar2;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint('https://app-scl.five9.com/strsvcs/rs/svc/agents/'+Five9AgentId+'/recordings/'+ recordingId +'?download=true');
        req.setHeader('Authorization', tokenId);
        req.setHeader('Session-Id', SessionId);
        req.setHeader('farmId', farmId);
        HttpResponse res = http.send(req);
        responseFile = res.getBodyAsBlob();

        sessionIdpar1 = UserInfo.getOrganizationId().substring(0,15);
        sessionIdpar2 = UserInfo.getSessionId().substring(15);


        String fileName = recordingId+'.mp3';


        uploadFile((String)uploadUrl,(String) fileName,(Blob) responseFile, (String)sessionIdpar1,(String) sessionIdpar2, (String) Five9CallSessionId);
    }

    public static void uploadFile(String uploadUrl, String fileName,Blob responseFile, String sessionIdpar1, String sessionIdpar2, String Five9CallSessionId){
        // Repost of code  with fix for file corruption issue
        // Orignal code postings and explanations
        // http://enreeco.blogspot.in/2013/01/salesforce-apex-post-mutipartform-data.html
        // http://salesforce.stackexchange.com/questions/24108/post-multipart-without-base64-encoding-the-body
        // Additional changes commented GW: that fix issue with occasional corruption of files
        String boundary = '----------------------------741e90d31eff';
        String header = '--'+boundary+'\nContent-Disposition: form-data; name="audioFileData"; filename="'+fileName+'";\nContent-Type: application/octet-stream';
        // GW: Do not prepend footer with \r\n, you'll see why in a moment
        // String footer = '\r\n--'+boundary+'--';
        String footer = '--'+boundary+'--';
        String headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        while(headerEncoded.endsWith('='))
        {
            header+=' ';
            headerEncoded = EncodingUtil.base64Encode(Blob.valueOf(header+'\r\n\r\n'));
        }
        String bodyEncoded = EncodingUtil.base64Encode(responseFile);
        // GW: Do not encode footer yet
        // String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));

        Blob bodyBlob = null;
        String last4Bytes = bodyEncoded.substring(bodyEncoded.length()-4,bodyEncoded.length());

        // GW: Replacing this entire section
        /*
        if(last4Bytes.endsWith('='))
        {
             Blob decoded4Bytes = EncodingUtil.base64Decode(last4Bytes);
             HttpRequest tmp = new HttpRequest();
             tmp.setBodyAsBlob(decoded4Bytes);
             String last4BytesFooter = tmp.getBody()+footer;
             bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded.substring(0,bodyEncoded.length()-4)+EncodingUtil.base64Encode(Blob.valueOf(last4BytesFooter)));
        }
        else
        {
              bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        }
        */
        // GW: replacement section to get rid of padding without corrupting data
        if(last4Bytes.endsWith('==')) {
            // The '==' sequence indicates that the last group contained only one 8 bit byte
            // 8 digit binary representation of CR is 00001101
            // 8 digit binary representation of LF is 00001010
            // Stitch them together and then from the right split them into 6 bit chunks
            // 0000110100001010 becomes 0000 110100 001010
            // Note the first 4 bits 0000 are identical to the padding used to encode the
            // second original 6 bit chunk, this is handy it means we can hard code the response in
            // The decimal values of 110100 001010 are 52 10
            // The base64 mapping values of 52 10 are 0 K
            // See http://en.wikipedia.org/wiki/Base64 for base64 mapping table
            // Therefore, we replace == with 0K
            // Note: if using \n\n instead of \r\n replace == with 'oK'
            last4Bytes = last4Bytes.substring(0,2) + '0K';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            // We have appended the \r\n to the Blob, so leave footer as it is.
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else if(last4Bytes.endsWith('=')) {
            // '=' indicates that encoded data already contained two out of 3x 8 bit bytes
            // We replace final 8 bit byte with a CR e.g. \r
            // 8 digit binary representation of CR is 00001101
            // Ignore the first 2 bits of 00 001101 they have already been used up as padding
            // for the existing data.
            // The Decimal value of 001101 is 13
            // The base64 value of 13 is N
            // Therefore, we replace = with N
            // Note: if using \n instead of \r replace = with 'K'
            last4Bytes = last4Bytes.substring(0,3) + 'N';
            bodyEncoded = bodyEncoded.substring(0,bodyEncoded.length()-4) + last4Bytes;
            // We have appended the CR e.g. \r, still need to prepend the line feed to the footer
            footer = '\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        } else {
            // Prepend the CR LF to the footer
            footer = '\r\n' + footer;
            String footerEncoded = EncodingUtil.base64Encode(Blob.valueOf(footer));
            bodyBlob = EncodingUtil.base64Decode(headerEncoded+bodyEncoded+footerEncoded);
        }

        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type','multipart/form-data; boundary='+boundary);
        req.setHeader('Authorization', 'Bearer ' + sessionIdpar1 + '' + sessionIdpar2);
        req.setMethod('POST');
        req.setEndpoint(uploadUrl);
        req.setBodyAsBlob(bodyBlob);
        req.setTimeout(120000);

        //System.debug(req.getBody());
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug(res.getStatusCode());

        Task task = [SELECT id, WhoId FROM Task WHERE Five9__Five9SessionId__c = :Five9CallSessionId];
        Lead lead = [SELECT id FROM Lead WHERE Id = :task.WhoId];
        lead.Description = 'updated';
        update lead;

        System.debug(lead.Description);
    }

}
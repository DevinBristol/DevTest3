/**
 * Created by Devin on 5/3/2024.
 */

Global with sharing class Five9Helper {

    public String VCjsonString(List<Task> tasks) {
        //list of task objects from taskTrigger.triggernew()

        final String CALL_COACHING_PROVIDER_ID = '0hnSu00000000ODIAY';

        List<Map<String, Object>> Calls = new List<Map<String, Object>>();
        for (Task t : tasks) {
            Map<String, Object> call = new Map<String, Object>{
                    'mediaProviderId' => CALL_COACHING_PROVIDER_ID,
                    'userId' => t.OwnerId,
                    'toPhoneNumber' => t.Five9DNIS__c,
                    'fromPhoneNumber' => t.Five9ANI__c,
                    'endDateTime' => t.CreatedDate.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''),
                    'startDateTime' => t.CreatedDate.addSeconds(-t.Five9TalkAndHoldTimeInSeconds__c.intValue()).format('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''),
                    'callType' => t.Five9__Five9TaskType__c,
                    'recordingDuration' => t.Five9TalkAndHoldTimeInSeconds__c,
                    'externalId' => t.Five9__Five9SessionId__c,
                    'recordingFormat' => 'mp3'
            };
            Calls.add(call);
        }
        Map<String, Object> requestBodyObj = new Map<String, Object>();  //  {  Calls:{ [{call0},{call1},{call2}. . .{call(n)}] }  }

        requestBodyObj.put('Calls', Calls);
        String reqBodyJSON = JSON.serialize(requestBodyObj);
        System.debug(reqBodyJSON);
        return reqBodyJSON;
    }
}
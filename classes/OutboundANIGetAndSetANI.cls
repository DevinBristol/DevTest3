/**
 * Created by Devin on 4/18/2024.
 */

public with sharing class OutboundANIGetAndSetANI {
    @Future(Callout=true)
    public static void GetANI(String phone, Id whoId)
    {
        String newAni;
        Http OutboundAniCall = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://app.outboundani.com/4a77d41d-47cf-4f82-8016-ae717dbb3af2/f762d9f9-a07f-46c3-a228-4b68bffe55dd.php?api_key=A2889ED0-265A-D9F8-14F4-BDCEFE0610E0&phone='+phone);
        req.setMethod('GET');
        HttpResponse res = OutboundAniCall.send(req);
        JSONParser parser =  JSON.createParser(res.getBody());
        System.debug(res.getBody());
        while(parser.nextToken() != null){
            if (parser.getCurrentToken() == JSONToken.FIELD_NAME && parser.getText() == 'ba685ce4-2c28-433a-a4c6-cac18b40f436'){
                parser.nextToken();
                newAni = parser.getText();
            }
        }
        Lead curlead = [SELECT Id FROM Lead WHERE Id = :whoId];
            curlead.ba685ce4_2c28_433a_a4c6_cac18b40f436__c = newAni;
            update curlead;
            System.debug(curlead.ba685ce4_2c28_433a_a4c6_cac18b40f436__c);
    }
}
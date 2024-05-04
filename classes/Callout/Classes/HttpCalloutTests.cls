/**
 * Created by Devin on 5/3/2024.
 */
@IsTest
Global with sharing class HttpCalloutTests {
    @IsTest
    static void it_should_properly_stub_response() {
        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, 'Success', '{}'));
        HttpResponse res = HttpCallout.makeRequest(new HttpRequest());
        System.assertEquals(200, res.getStatusCode());
    }

    @IsTest
    static void it_should_callout_successfully() {
        Callout fakeCallout = new Callout('{parameter1: perhaps a serialized list or id!}',
                new String('https://api.com'), new String('POST'));
        String jsonString = JSON.serialize(fakeCallout);

        Test.setMock(HttpCalloutMock.class, new MockHttpResponse(200, 'Success', '{}'));

        Test.startTest();
        HttpCallout.process(jsonString);
        Test.stopTest();

        System.assert(true, 'should make it here!');
    }
}
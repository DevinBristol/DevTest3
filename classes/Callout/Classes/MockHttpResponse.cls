/**
 * Created by Devin on 5/3/2024.
 */

Global class MockHttpResponse implements HttpCalloutMock {
    private final Integer code;
    private final String status;
    private final String body;

    public MockHttpResponse(Integer code, String status, String body) {
        this.code = code;
        this.status = status;
        this.body = body;
    }

    public HTTPResponse respond(HTTPRequest req) {
        System.assertEquals(1, Limits.getCallouts());
        HttpResponse res = new HttpResponse();

        if(this.body != null) {
            res.setBody(this.body);
        }
        res.setStatusCode(this.code);
        res.setStatus(this.status);

        return res;
    }
}
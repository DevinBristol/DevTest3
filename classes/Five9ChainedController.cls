/**
 * Created by Devin on 4/23/2024.
 */

public with sharing class Five9ChainedController {

    // Unique label for the initial callout request
    public String requestLabel1;
    // Unique label for the chained callout request
    public String requestLabel2;
    // Result of initial callout
    public String result1 {get;set;}
    // Result of chained callout
    public String result2 {get;set;}
    // Endpoint of long-running service
    private static final String LONG_RUNNING_SERVICE_URL1 =
            'https://app-scl.five9.com/supsvcs/rs/svc/auth/login';
    private static final String LONG_RUNNING_SERVICE_URL2 =
            '<https://app-scl.five9.com/supsvcs/rs/svc/supervisors/4764534/session_start?force=true>';

    // Action method
    public Object invokeInitialRequest() {
        // Create continuation with a timeout
        Continuation con = new Continuation(120);
        // Set callback method
        con.continuationMethod='processInitialResponse';

        // Create first callout request
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint(LONG_RUNNING_SERVICE_URL1);
        req.setBody('{"passwordCredentials":{"username":"syncerfn@gmail.com","password":"Alpha10Gas!"},"policy":"ForceIn"}');

        // Add initial callout request to continuation
        this.requestLabel1 = con.addHttpRequest(req);

        // Return the continuation
        System.debug(con);
        return con;
    }

    // Callback method for initial request
    public Object processInitialResponse() {
        // Get the response by using the unique label
        HttpResponse response = Continuation.getResponse(this.requestLabel1);
        // Set the result variable
        System.debug(requestLabel1);
        this.result1 = response.getBody();

        Continuation chainedContinuation = null;
        // Chain continuation if some condition is met
        if (response.getBody().toLowerCase().contains(':')) {
            // Create a second continuation
            chainedContinuation = new Continuation(60);
            // Set callback method
            chainedContinuation.continuationMethod='processChainedResponse';

            // Create callout request
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(LONG_RUNNING_SERVICE_URL2);
            req.setBody('{"stationId":null,"stationType":"EMPTY"}');

            // Add callout request to continuation
            this.requestLabel2 = chainedContinuation.addHttpRequest(req);
        }

        // Start another continuation
        return chainedContinuation;
    }

    // Callback method for chained request
    public Object processChainedResponse() {
        // Get the response for the chained request
        HttpResponse response = Continuation.getResponse(this.requestLabel2);
        // Set the result variable that is displayed on the Visualforce page
        this.result2 = response.getBody();

        // Return null to re-render the original Visualforce page
        return null;
    }

}
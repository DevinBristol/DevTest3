/**
 * Created by Devin on 4/18/2024.
 */

global class MockOutBoundAniResponse implements HttpCalloutMock {

    global HttpResponse respond(HttpRequest request){
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"phone":"4022174741"},{"ba685ce4-2c28-433a-a4c6-cac18b40f436":"5312520846"},{"21d697a0-a81a-4bab-b635-5f7be11181a7":"2024-04-18 22:45:29"},{"b7ef8429-9f35-4102-b1ea-44d3453a5086":"3121eda2-d12e-4c34-bb0d-b31541fa9f57"}]');
        res.setStatusCode(200);
        return res;
    }

}
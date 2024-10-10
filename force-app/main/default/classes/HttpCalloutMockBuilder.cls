public with sharing class HttpCalloutMockBuilder implements HttpCalloutMock{
    public String body;
    public Integer statusCode;
    public HttpCalloutMockBuilder(Integer statusCode, String body) {
        this.statusCode = statusCode;
        this.body = body;
    }

    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setBody(body);
        response.setStatusCode(statusCode);
        return response;
    }
}
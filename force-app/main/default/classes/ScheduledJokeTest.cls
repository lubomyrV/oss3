@isTest
public with sharing class ScheduledJokeTest {
    
    @isTest
    public static void requestData_pos() {
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockBuilder(200, '{"id":"ljqzkVKJtrc","joke":"How do you get two whales in a car? Start in England and drive West."}'));
        Test.startTest();
        HTTPResponse response = ScheduledJoke.requestData();
        Test.stopTest();
        System.debug(response);
        System.debug(response.getBody());
        Assert.areEqual(200, response.getStatusCode(), 'HttpRequest failed');
        Assert.areEqual('ljqzkVKJtrc', ((Map<String, Object>)JSON.deserializeUntyped(response.getBody())).get('id'), 'Id is wrong');
    }
}
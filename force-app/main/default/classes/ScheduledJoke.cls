public class ScheduledJoke implements Schedulable, Database.AllowsCallouts {

    public static String CRON_EXP = '0 15 * * * ?';

    public void execute(SchedulableContext SC) {
        requestData();
   	}
    
    public static HTTPResponse requestData(){
        HttpRequest request = new HttpRequest();
        // get this value from Setup -> Named Credentials
        request.setEndpoint('callout:icanhazdadjoke');
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        HTTPResponse response = new HTTPResponse();
        try {
            response = new Http().send(request);
            String body = response.getBody();
            System.debug(body);
            Map<String, Object> mapResp = (Map<String, Object>)JSON.deserializeUntyped(body);
            String jokeId = null;
            if (mapResp.containsKey('id')){
                jokeId = (String)mapResp.get('id');
                List<Joke__c> oldJokes = [SELECT Id FROM Joke__c WHERE Joke_Id__c  = :jokeId];
                if (oldJokes.isEmpty()){
                    insert new Joke__c(Joke_Id__c = (String)mapResp.get('id'), Joke__c = (String)mapResp.get('joke'));
                }
            }
        } catch(Exception e){
            response.setStatusCode(000);
            response.setStatus('Exception');
            response.setBody('{"Error":"'+e.getMessage()+'"}');
            System.debug(e.getMessage());
            new Logger().log(e).saveLogs();
        }
        return response;
    }
    
}
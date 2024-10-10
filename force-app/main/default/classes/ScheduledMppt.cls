global class ScheduledMppt implements Schedulable, Database.AllowsCallouts {
    /**
     * new ScheduledMppt().execute(null);
     */
    public ScheduledMppt() {

    }

    global void execute(SchedulableContext SC) {
        requestData();
   	}
    
    public static void requestData(){
        HttpRequest request = new HttpRequest();
        // get this value from Setup -> Named Credentials
        String endpoint = 'callout:solarController' + '/mppt';
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');

        try {
            HTTPResponse response = new Http().send(request);
            System.debug(response.getStatus());
            System.debug(response.getStatusCode());
            System.debug(response.getHeaderKeys());
            String body = response.getBody();
            System.debug(body);

            if (response.getStatusCode() > 399) {
                new Logger().log('ScheduledMppt: An exception occurred in request from ' + endpoint + ', ' + JSON.serialize(body)).saveLogs();
            }

            Mppt mpptData = Mppt.parse(body);
            System.debug(mpptData);
            System.debug(mpptData.getBatteryVoltage());
        } catch(Exception e){
            System.debug(System.LoggingLevel.ERROR, 'Callout exception:' + e.getMessage());
        }
    }
}
global class ScheduledCryptocurrency implements Schedulable, Database.AllowsCallouts {
    
	public static String CRON_EXP = '0 15 * * * ?';
    public static Decimal value = 1000000;

    global void execute(SchedulableContext SC) {
        requestData();
   	}
    
    @future(callout=true)
    public static void requestData(){
        HttpRequest request = new HttpRequest();
        // get this value from Setup -> Named Credentials
        request.setEndpoint('callout:Blockchain_info');
        request.setMethod('GET');
        try {
            HTTPResponse response = new Http().send(request);//need to handle exeption
            Decimal price = value / Decimal.valueOf(response.getBody());
            insert new Cryptocurrency__c(Tether_Price__c = price);
        } catch(Exception e){
            new Logger().log(e).saveLogs();
        }
    }
}
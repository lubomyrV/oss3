global class ScheduledBooks implements Schedulable, Database.AllowsCallouts {

    global void execute(SchedulableContext sc) {
        
        //execute this job code
        requestData();
        
        //run next job
        ScheduleManager.continueExecute(sc, new ScheduledBooks(), 5);

   	}

    @future(callout=true)
    public static void requestData(){
        HttpRequest request = new HttpRequest();
        // get this value from Setup -> Named Credentials
        request.setEndpoint('callout:fakerapi');
        request.setMethod('GET');
        request.setHeader('Accept', 'application/json');
        try {
            HTTPResponse response = new Http().send(request);
            String body = response.getBody();
            Map<String, Object> mapResp = (Map<String, Object>)JSON.deserializeUntyped(body);
            if (mapResp.containsKey('data')){
                List<Object> dataList = (List<Object>)mapResp.get('data');
                List<Book__c> books = new List<Book__c>();
                for (Object dataObj: dataList) {
                    Map<String,Object> dataMap = (Map<String,Object>)dataObj;
                    Book__c newBook = new Book__c();
                    newBook.Title__c = (String)dataMap.get('title');
                    newBook.Author__c = (String)dataMap.get('author');
                    newBook.Description__c = (String)dataMap.get('description');
                    newBook.Genre__c = (String)dataMap.get('genre');
                    newBook.Image__c = (String)dataMap.get('image');
                    newBook.ISBN__c = Long.valueOf((String)dataMap.get('isbn'));
                    String publishedStr = (String)dataMap.get('published');
                    List<String> parts = publishedStr.split('-');
                    newBook.Published__c = Date.newinstance(
                        Integer.valueOf(parts.get(0)), 
                        Integer.valueOf(parts.get(1)), 
                        Integer.valueOf(parts.get(2)));
                    newBook.Publisher__c = (String)dataMap.get('publisher');
                    books.add(newBook);
                }
                
                insert books;
            }
        } catch(Exception e){
            new Logger().log(e).saveLogs();
        }
    }
}
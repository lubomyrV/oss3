global class Response {
	@AuraEnabled
    global Boolean isSuccess  { get; set; }
    @AuraEnabled
    global String message     { get; set; }
    @AuraEnabled
    global Object responseObj { get; set; }

    public Response() {
        isSuccess = true;
        message = '';
        responseObj = new Map<String,Object>();
    }

    public Response(Exception e){
        isSuccess = false;
        message = e.getMessage();
        if (e instanceof DmlException){
            DmlException dmlEx = (DmlException)e;
            message += '; DmlMessage:'+dmlEx.getDmlMessage(0);
            List<String> fields = dmlEx.getDmlFieldNames(0);
            if (!fields.isEmpty()) {
                message += '; Fields:' + String.join(fields, ',');
            }
        }
    }
}
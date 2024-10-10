public with sharing class WelcomeController {
    @AuraEnabled
    public static Map<String,Object> getInfo(String data) {
        data = System.UserInfo.getName() +' '+ data;
        return new Map<String,Object>{'data' => data};
    }
}
public with sharing class DemoAuraController {
    @AuraEnabled
    public static String serverEchoOne(String str) {
        DateTime now = DateTime.now();
        return 'serverEchoOne: ' + str +' - '+now+' - '+now.millisecond();
    }
    
    @AuraEnabled
    public static String serverEchoTwo() {
        DateTime now = DateTime.now();
        return 'serverEchoTwo: '+now+' - '+now.millisecond();
    }
    
    @AuraEnabled
    public static String serverEchoThree() {
        DateTime now = DateTime.now();
        return 'serverEchoThree: '+now+' - '+now.millisecond();
    }
}
public with sharing class DemoLwcController {

    @TestVisible
    private static DemoClass demoClass = new DemoClass();

    @AuraEnabled
    public static List<Contact> getContactList(String accountId) {
        System.debug('getContactList->accountId: '+accountId);
        List<Contact> contacts = [
            SELECT Id, Name, Phone, Fax, Email, Birthdate
            FROM Contact
            WHERE AccountId = :accountId
            WITH SECURITY_ENFORCED
        ];
        System.debug('getContactList->contacts: '+contacts);
        return contacts;
    }

    @AuraEnabled
    public static String getContactInfo(String contactId) {
        System.debug('getContactInfo->contactId: '+contactId);
        if (String.isBlank(contactId)) {
            return '';
        }
        List<Contact> contacts = [
            SELECT Id, Name, Phone, Fax, Email, Birthdate
            FROM Contact
            WHERE Id = :contactId
            WITH SECURITY_ENFORCED
        ];
        return JSON.serialize(contacts);
    }
    
    @AuraEnabled
    public static String saveContacts(List<SObject> contacts) {
        System.debug('contacts: '+contacts);
        List<Database.SaveResult> saveResult = Database.update(contacts);
        return JSON.serialize(saveResult);
    }

    @AuraEnabled
    public static String deleteRecord(Id recordId) {
        System.debug('recordId: '+recordId);
        Datetime runDatetime = Datetime.now().addMinutes(1);
        String hour = String.valueOf(runDatetime.hour());
        String min = String.valueOf(runDatetime.minute()); 
        String ss = String.valueOf(runDatetime.second());
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        String jobID = '';
        // jobID = System.schedule('Delete Job', nextFireTime, new ScheduledBatchJob(recordId));
        // DemoClass.method3(recordId);
        // insert new Object_A__c(Text_A__c = 'test a', Name = 'name a');
        return JSON.serialize(jobID);
    }

    @AuraEnabled
    public static List<Account> updateAccountPhone(String accountName, String phone) {
        try {
            return demoClass.updateAccountPhone(accountName, phone);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getError() {
        try {
            insert new Account();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return 'ok';
    }
}
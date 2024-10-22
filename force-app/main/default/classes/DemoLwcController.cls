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
        return contacts;
    }

    @AuraEnabled
    public static List<Contact> getAllContacts() {
        List<Contact> contacts = [
            SELECT FIELDS(STANDARD)
            FROM Contact
            LIMIT 200
        ];
        return contacts;
    }

    @AuraEnabled
    public static String getAllContactsJSON() {
        List<Contact> contacts = [
            SELECT FIELDS(STANDARD)
            FROM Contact
            LIMIT 200
        ];
        return JSON.serialize(contacts);
    }

    @AuraEnabled
    public static List<Contact> getContactInfo(String contactId) {
        if (String.isBlank(contactId)) {
            throw new AuraHandledException('Contact Id in null');
        }
        List<Contact> contacts = [
            SELECT Id, Name, Phone, Fax, Email, Birthdate
            FROM Contact
            WHERE Id = :contactId
            WITH SECURITY_ENFORCED
        ];
        return contacts;
    }
    
    @AuraEnabled
    public static String saveContacts(List<SObject> contacts) {
        try {
            return JSON.serialize(Database.update(contacts));
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String deleteRecord(Id recordId) {
        System.debug('deleteRecord: '+recordId);
        Datetime runDatetime = Datetime.now().addMinutes(1);
        String hour = String.valueOf(runDatetime.hour());
        String min = String.valueOf(runDatetime.minute()); 
        String ss = String.valueOf(runDatetime.second());
        String nextFireTime = ss + ' ' + min + ' ' + hour + ' * * ?';
        String jobID = '';
        // jobID = System.schedule('Delete Job', nextFireTime, new ScheduledBatchJob(recordId));
        return jobID;
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
            Integer i = 1/0;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return 'ok';
    }
}
public with sharing class LogDecryptDataController {
    /*
    @AuraEnabled
    public static String decryptData(Id recordId) {
        Log__c record = [
            SELECT Id, Data__c, Key__c, Hash__c 
            FROM Log__c 
            WHERE Id =:recordId
        ];
        Logger logger = new Logger();
        Blob decrypted = null;
        if (record.Key__c != null){
            try {
                decrypted = logger.decryptData(record.Key__c, record.Data__c);
            } catch (Exception e) {
                logger.log(e);
            }
        }
        return decrypted?.toString();
    }

    @AuraEnabled
    public static Boolean verifyHash(Id recordId) {
        Log__c record = [
            SELECT Id, Data__c, Key__c, Hash__c 
            FROM Log__c 
            WHERE Id =:recordId
        ];
        Logger logger = new Logger();
        String hash = null;
        if (record.Key__c != null){
            Blob decrypted = logger.decryptData(record.Key__c, record.Data__c);//
            hash = logger.getHash(decrypted.toString());
        } else {
            hash = logger.getHash(record.Data__c);
        }
        return (record.Hash__c == hash);
    }

    @AuraEnabled
    public static String init(Id recordId) {
        Map<String, String> result = new Map<String, String>();
        Id userId = UserInfo.getUserId();
        List<PermissionSetAssignment> psa = [
            SELECT Id, PermissionSet.Name, AssigneeId 
            FROM PermissionSetAssignment
            WHERE AssigneeId =:userId AND PermissionSet.Name = 'Logs_crypt_viewer'
        ];
        result.put('hasPermission', String.valueOf(!psa.isEmpty()));

        Log__c record = [
            SELECT Id, Key__c, Hash__c
            FROM Log__c 
            WHERE Id =:recordId
        ];
        result.put('hasEncryprion',  String.valueOf(record.Key__c != null));
        result.put('hasData',  String.valueOf(record.Hash__c != null));
        
        return JSON.serialize(result);
    }
    */
}
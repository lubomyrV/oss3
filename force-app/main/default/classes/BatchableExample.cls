public with sharing class BatchableExample implements Database.Batchable<sObject> {
    public BatchableExample() {

    }
    //Database.QueryLocator
    public System.Iterable<SObject> start(Database.BatchableContext bc) {
        // return Database.getQueryLocator('SELECT Id FROM Account');
        return Database.query('SELECT Id FROM Account FOR UPDATE ');
    }

    public void execute(Database.BatchableContext bc, List<Account> scope){
        Map<Id,SObject> accountById = new Map<Id,SObject>(scope);
        List<Contact> contacts = [SELECT Id FROM Contact WHERE AccountId IN :accountById.keySet() FOR UPDATE];
        Map<Id,Contact> contactById = new Map<Id,Contact>(contacts);
        // for(Account acc : scope){
        //     System.debug('Account: ' + acc);
        //     for(Id AccountId : contactById.keySet()) {
        //         Contact contact = contactById.get(AccountId);
        //         System.debug('Contact: ' + contact);
        //     }
        // }
        try {
            //works fine even before LimitException
            EventBus.publish(new Log_Event__e(Message__c = 'BatchableExample message before LimitException'));
            throw new LimitException('Throwing this LimitException from BatchableExample');
        } catch (Exception e) {
            // it is not able to catch the LimitException, use Database.RaisesPlatformEvents or Finalizer instead
            EventBus.publish(new Log_Event__e(Message__c = e.getMessage(), StackTrace__c = e.getStackTraceString(), Type__c = e.getTypeName()));
        }
        try {
            // insert new Account();
        } catch (Exception e) {
            // it works even if transaction fails when Publish Behavior is 'Publish Immediately'
            EventBus.publish(new Log_Event__e(Message__c = e.getMessage(), StackTrace__c = e.getStackTraceString(), Type__c = e.getTypeName()));
            insert new Contact();
            throw new AsyncException(e.getMessage());
        }
    }

    public void finish(Database.BatchableContext bc){
    }
}
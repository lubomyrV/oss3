public with sharing class BatchableExample implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.RaisesPlatformEvents{
    // System.attachFinalizer(Finalizer) is not allowed in this context
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
        for(Account acc : scope){
            System.debug('Account: ' + acc);
            for(Id AccountId : contactById.keySet()) {
                Contact contact = contactById.get(AccountId);
                System.debug('Contact: ' + contact);
            }
            // while(Limits.getCpuTime() < 12000) {// wait for 12 sec
            // }
        }
        // for (Integer i = 0; i < 201; i++) {
        //     List<SObject> res = [SELECT Id FROM Account];
        // }
        try {
            // insert new Account();
        } catch (Exception e) {
            throw new AsyncException(e.getMessage());
        }
    }

    public void finish(Database.BatchableContext bc){
    }
}
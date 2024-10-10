public with sharing class QueueableExample implements Queueable, Database.AllowsCallouts, Finalizer {
    public QueueableExample(String message) {
        System.debug('QueueableExample ' + message);
        insert new Log__c(Type__c = 'Queueable', Message__c = message);
    }
    //System.enqueueJob(new QueueableExample());
    public void execute(QueueableContext context) {
        System.attachFinalizer(this);
        System.debug('JobId ' + context.getJobId());
        insert new Account();
        try {
        } catch (Exception exp) {
            System.debug('Exception ' + exp.getMessage());
            insert new Log__c(Type__c = 'Queueable', Message__c = exp.getMessage());
        }
    }

    public void execute(FinalizerContext context) {
        System.debug('AsyncApexJobId ' + context.getAsyncApexJobId());
        System.debug('RequestId ' + context.getRequestId());
        System.debug('Result ' + context.getResult());
        System.debug('Exception ' + context.getException());
        insert new Log__c(Type__c = 'Finalizer-' + context.getResult(), Message__c =  '' + context?.getException());
    }
}
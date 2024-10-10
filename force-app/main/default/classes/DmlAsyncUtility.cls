public with sharing class DmlAsyncUtility implements Queueable, Finalizer {

    public enum DmlType { INSERT_TYPE, UPDATE_TYPE, UPSERT_TYPE, DELETE_TYPE, UNDELETE_TYPE, MERGE_TYPE }


    DmlType dmpType;
    List<SObject> sobjects;

    public DmlAsyncUtility(List<SObject> sobjects, DmlType dmpType) {
        this.sobjects = sobjects;
        this.dmpType = dmpType;
    }

    public void execute(QueueableContext context) {
        System.attachFinalizer(this);
        try {
            switch on dmpType {
                when INSERT_TYPE {
                    new DmlUtility().insertSobjects(sobjects);
                }
                when UPDATE_TYPE {
                }
                when UPSERT_TYPE {
                }
                when DELETE_TYPE {
                }
                when UNDELETE_TYPE {
                }
                when MERGE_TYPE {
                }
            }
        } catch (Exception exp) {
            System.debug('Exception ' + exp.getMessage());
            insert new Log__c(Type__c = 'DmlAsyncUtility', Message__c = exp.getMessage());
        }
    }

    public void execute(FinalizerContext context) {
        if (context.getResult() != ParentJobResult.SUCCESS) {
            insert new Log__c(Type__c = 'DmlAsyncUtility-Finalizer-' + context.getResult(), Message__c =  '' + context?.getException());
        }
    }
}
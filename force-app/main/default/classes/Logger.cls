/**
* @file Logger.cls
* @author Liubomyr
* @date 14 April 2021
* @brief this class contains methods for handling and logging exceptions into Apex
*/
public without sharing class Logger {

    private List<Log__c> logs = new List<Log__c>();
    private Type sourceType;

    public Logger(){
    }

    public Logger(Type sourceType){
        this.sourceType = sourceType;
    }

    /**
     * @description inserts the record into database
     * @return saved logs
     */
    public List<Log__c> saveLogs() {
        insert this.logs;
        return this.logs;
    }

    /**
     * @description inserts the record into database
     * @return saved logs
     */
    public List<Log__c> saveLogs(List<Log__c> logs) {
        insert logs;
        return logs;
    }

    public List<Log__c> getLogs() {
        return this.logs;
    }


    /**
    * @description creates a new Log__c record with a message and type
    * @param message a message for debugging
    * @return this Logger object
    */
    public Logger log(String type, String message) {
        Log__c log = new Log__c();
        log.Type__c = type;
        if (this.sourceType != null) {
            log.Class__c = this.sourceType.getName();
        }
        if (message.length() > 255) {
            log.Description__c = message;
        } else {
        	log.Message__c = message;
        }
        this.logs.add(log);
        return this;
	}

    /**
    * @description creates a new Log__c record and handle Exception object
    * @param exp accepts Exception or DmlException object
    * @return this Logger object
    */
    public Logger log(Exception exp) {
        Log__c log = new Log__c();
        log.Message__c = exp.getMessage();
        log.Type__c = exp.getTypeName();
        if (this.sourceType != null) {
            log.Class__c = this.sourceType.getName();
        }
        if (exp instanceof DmlException) {
            DmlException dmlExp = (DmlException) exp;
            List<DmlExceptionWrapper> dmlExceptions = this.getDmlExceptions(dmlExp);
            log.StackTrace__c = dmlExp.getStackTraceString() + '\n' + dmlExceptions;
        } else {
            log.StackTrace__c = exp.getStackTraceString();
        }
        this.logs.add(log);
        return this;
	}
    
    /**
     * @description creates a new Log__c record for BatchApexErrorEvent
     * @param  evt BatchApexErrorEvent
     * @return this Logger object
     */
    public Logger log(BatchApexErrorEvent evt) {
        Log__c log = new Log__c();
        if (this.sourceType != null) {
            log.Class__c = this.sourceType.getName();
        }
        log.Type__c = evt.ExceptionType;
        log.Message__c = evt.Message;
        log.StackTrace__c = evt.StackTrace;
        Map<String, Object> data = new Map<String, Object>{
            'AsyncApexJobId' => evt.AsyncApexJobId,
            'Phase' => evt.Phase,
            'RequestId' => evt.RequestId,
            'ReplayId' => evt.ReplayId,
            'JobScope' => evt.JobScope?.split(','),
            'EventUuid' => evt.EventUuid,
            'DoesExceedJobScopeMaxLength' => evt.DoesExceedJobScopeMaxLength
        };
        log.Description__c = JSON.serialize(data);
        this.logs.add(log);
        return this;
	}

    /**
    * @description wrapper class for handling DmlException object
    * @param dmlExp a DmlException object 
    * @return getDmlExceptions list of the DmlExceptionObject wrapper
    */
    private List<DmlExceptionWrapper> getDmlExceptions(DmlException dmlExp){
        Integer dmlFailed = dmlExp.getNumDml();
        Map<Integer, DmlExceptionWrapper> dmlExceptionObjectByIndex = new Map<Integer, DmlExceptionWrapper>();
        for (Integer i = 0; i < dmlFailed; ++i){
            DmlExceptionWrapper dmlExpObj = new DmlExceptionWrapper();
            dmlExpObj.dmlId = dmlExp.getDmlId(i);
            dmlExpObj.dmlIndex = dmlExp.getDmlIndex(i);
            dmlExpObj.dmlMessage = dmlExp.getDmlMessage(i);
            dmlExpObj.dmlStatusCode = dmlExp.getDmlStatusCode(i);
            dmlExpObj.dmlType = dmlExp.getDmlType(i);
            dmlExpObj.dmlFieldNames = dmlExp.getDmlFieldNames(i);
            dmlExpObj.dmlFields = dmlExp.getDmlFields(i);
            dmlExceptionObjectByIndex.put(i, dmlExpObj);
        }
        return dmlExceptionObjectByIndex.values();
    }

    /**
    * @description wrapper class for handling DmlException object
    */
    private class DmlExceptionWrapper {
        String dmlId;
        Integer dmlIndex;
        String dmlMessage;
        String dmlStatusCode;
        System.StatusCode dmlType;
        String [] dmlFieldNames;
        Schema.sObjectField [] dmlFields;
    }

}
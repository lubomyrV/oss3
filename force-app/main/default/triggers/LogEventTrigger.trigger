trigger LogEventTrigger on Log_Event__e (after insert) {
    List<Log__c> logs = new List<Log__c>();
    for(Log_Event__e evt : Trigger.new){
        System.debug('LogEventTrigger: ' + evt);
        Logger logger = new Logger().log(evt);
        logs.addAll(logger.getLogs());
    }
    System.debug('logs: ' + logs);
    new Logger().saveLogs(logs);
}
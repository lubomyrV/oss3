trigger BatchApexErrorEventTrigger on BatchApexErrorEvent (after insert) {
	System.debug('Trigger Executed');
    System.debug('Trigger.new '+ Trigger.new);
    //the event trigger code is running as the “Automated Process” user
    Set<Id> asyncApexJobIds = new Set<Id>();
    for(BatchApexErrorEvent evt:Trigger.new){
        asyncApexJobIds.add(evt.AsyncApexJobId);
    }
    
    Map<Id,AsyncApexJob> jobs = new Map<Id,AsyncApexJob>(
        [SELECT id, ApexClass.Name FROM AsyncApexJob WHERE Id IN :asyncApexJobIds]
    );
    List<Log__c> logs = new List<Log__c>();
    for(BatchApexErrorEvent evt : Trigger.new){
        String apexClassName = jobs.get(evt.AsyncApexJobId).ApexClass.Name;
        Logger logger = new Logger(Type.forName(apexClassName));
        logger.log(evt);
        logs.addAll(logger.getLogs());
    }
    new Logger().saveLogs(logs);
}
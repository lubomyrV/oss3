public class LoggingFinalizer implements Finalizer, Queueable {

    // Queueable implementation
    // A queueable job that uses LoggingFinalizer to buffer the log
    // and commit upon exit, even if the queueable execution fails
    public void execute(QueueableContext ctx) {
        String jobId = '' + ctx.getJobId();
        System.debug('Begin: executing queueable job: ' + jobId);
        // Create an instance of LoggingFinalizer and attach it
        // Alternatively, System.attachFinalizer(this) can be used instead of instantiating LoggingFinalizer
        LoggingFinalizer logFin = new LoggingFinalizer();
        System.attachFinalizer(logFin);
        String exceptionMsg;
        try {
            // While executing the job, log using LoggingFinalizer.addLog()
            // Note that addlog() modifies the Finalizer's state after it is attached 
            DateTime start = DateTime.now();
            logFin.addLog('Queueable About to do some work...', jobId);
            for (Integer i = 0; i < 201; i++) {
                AggregateResult[] groupedResults = [SELECT COUNT(Id) FROM Log__c];
                for (AggregateResult ar : groupedResults)  {
                    // System.debug('COUNT ' + ar.get('expr0'));
                }
            }
            // while (true) {
            //     // Results in "Apex CPU time limit exceeded"
            // }
        } catch (Exception e) {
            // does not work on limits exception
            System.debug('Exception: Error executing the job [' + jobId + ']: ' + e.getMessage());
        } finally {
            // does not work on limits exception
            System.debug('Completed: execution of queueable job: ' + jobId);
        }
    }
  
    // Finalizer implementation
    // Logging finalizer provides a public method addLog(message,source) that allows buffering log lines from the Queueable job.
    // When the Queueable job completes, regardless of success or failure, the LoggingFinalizer instance commits this buffered log.
    // Custom object Log__c has four custom fields-see addLog() method.

    // internal log buffer
    private List<Log__c> logRecords = new List<Log__c>();

    public void execute(FinalizerContext ctx) {
        String parentJobId = ctx.getAsyncApexJobId();
        System.debug('Begin: executing finalizer attached to queueable job: ' + parentJobId);

        // Update the log records with the parent queueable job id
        System.Debug('Updating job id on ' + logRecords.size() + ' log records');
        for (Log__c log : logRecords) {
            log.Message__c += parentJobId; // or could be ctx.getRequestId()
        }

        // Commit the buffer
        System.Debug('committing log records to database');
        insert logRecords;
        // Database.insert(logRecords, false);

        if (ctx.getResult() == ParentJobResult.SUCCESS) {
            System.debug('Parent queueable job [' + parentJobId + '] completed successfully.');
        } else {
            String message = 'Parent queueable job [' + parentJobId + '] failed due to unhandled exception: ' + ctx.getException().getMessage();
            System.debug(message);
            insert new Log__c(
                Message__c = 'Parent queueable job [' + parentJobId + '] failed due to unhandled exception',
                Type__c = 'Finalizer',
                StackTrace__c = ctx.getException().getMessage()
            );
            System.debug('Enqueueing another instance of the queueable...');
            System.enqueueJob(new LoggingFinalizer(), 1);
        }
        System.debug('Completed: execution of finalizer attached to queueable job: ' + parentJobId);
    }

    public void addLog(String message, String source) {
        // append the log message to the buffer
        logRecords.add(new Log__c(
            Message__c = message,
            Type__c = 'QueueableContext',
            StackTrace__c = source
        ));
    }
  }
public class ScheduleManager {
    
    public static Set<Id> startAllJobs(){
        
        Set<Id> cronTriggerIds = new Set<Id>();
        
        cronTriggerIds.add(System.schedule('Scheduled Cryptocurrency Job', '0 0 * * * ?', new ScheduledCryptocurrency()));
        cronTriggerIds.add(System.schedule('Scheduled Joke Job', '0 30 * * * ?', new ScheduledJoke()));
        cronTriggerIds.add(ScheduleManager.start('Scheduled Book Job', 120, new ScheduledBooks()));
        cronTriggerIds.add(ScheduleManager.start('Scheduled Garbage Collector Job', 360, new GarbageCollector()));


        return cronTriggerIds;
    }
    
    public static void abortAllJobs(){
        for(CronTrigger ctObj : [SELECT Id FROM CronTrigger]){
            System.abortJob(ctObj.Id);
        }
    }
    
    public static Id start(String jobName, Integer minutes, Schedulable scheduleObject){
        Datetime startTime = Datetime.now().addMinutes(minutes);
        String cronExp = getCronExp(startTime);
        Id cronTriggerId = System.schedule(jobName + '_' + startTime.minute(), cronExp, scheduleObject);
        return cronTriggerId;
    }
    
    public static Id continueExecute(SchedulableContext schedulableContext, Schedulable schedulObject, Integer minutes){
        Id thisJobId = schedulableContext.getTriggerId();
        CronTrigger thisJob = [
            SELECT Id, StartTime, PreviousFireTime, NextFireTime, CronJobDetail.Name
            FROM CronTrigger 
            WHERE  Id = :thisJobId
        ];
        
        String jobName = thisJob.CronJobDetail.Name;
        String jobNamePattern = jobName.substringBefore('_');
        List<CronTrigger> similarJobs = [
            SELECT Id, CronJobDetail.Name
            FROM CronTrigger 
            WHERE CronJobDetail.Name LIKE :(jobNamePattern +'%')
        ];
        for (CronTrigger similarJob : similarJobs) {
            if (similarJob.Id != thisJobId){
                System.abortJob(similarJob.Id);
            }
        }

        Datetime nextJobRun = Datetime.now().addMinutes(minutes);
        String cronExp = getCronExp(nextJobRun);
        Id nextCronTriggerId;
        try {
            //create a next job
            nextCronTriggerId = System.schedule(jobNamePattern + '_' + nextJobRun.minute(), cronExp, schedulObject);
        } catch(Exception e){
            new Logger().log(e).saveLogs();
        }
        return nextCronTriggerId;
    }

    public static String getCronExp(Datetime startTime){
        String cronExp = startTime.second() + ' '
            + startTime.minute() + ' '
            + startTime.hour() + ' '
            + startTime.day() + ' '
            + startTime.month()
            + ' ? '
            + startTime.year();
        return cronExp;
    }
}
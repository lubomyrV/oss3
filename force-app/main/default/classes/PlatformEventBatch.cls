public class PlatformEventBatch implements Database.Batchable<sObject>, Database.RaisesPlatformEvents {
	public Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator('SELECT Id, Name FROM Account LIMIT 1');
    }

    public void execute(Database.BatchableContext BC, List<SObject> scope){
        throw new LimitException('throwing this exception');
    }
    
    public void finish(Database.BatchableContext BC){}
    
}
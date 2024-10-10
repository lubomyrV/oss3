global class GarbageCollector implements Schedulable {
    
    global void execute(SchedulableContext cs) {
        deleteOldRecords();
   	}
    
    public static void deleteOldRecords(){
        List<String> customObjects = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()) {
            Schema.DescribeSObjectResult describeSObjectResultObj = objTyp.getDescribe();
            if(describeSObjectResultObj.isCustom()) {
                String name = objTyp.getDescribe().getName();
                if(!name.containsIgnoreCase('history') && !name.containsIgnoreCase('tag') && !name.containsIgnoreCase('share') && !name.containsIgnoreCase('feed')) {
                    customObjects.add(name);
                }
            }
        }
        List<Id> recordIdsForDelete = new List<Id>();
        for(String objectName : customObjects){
            List<sObject> sobjList = Database.query('SELECT Id FROM '+objectName+' ORDER BY CreatedDate DESC');
            for(Integer i = 0; i < sobjList.size(); i++){
                if (i > 100) recordIdsForDelete.add(sobjList.get(i).Id);
            }
        }
        
        try {
            Database.delete(recordIdsForDelete);
        } catch(Exception e){
            new Logger().log(e).saveLogs();
        }
    }
}
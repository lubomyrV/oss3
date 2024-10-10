public with sharing class Utility {

    public static final Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();

    public static Map<String, Map<String,Schema.DisplayType>> getSObjectFiledsMap(String sObjectName) {
        Map<String, Map<String,Schema.DisplayType>> sObjectFileds = new Map<String, Map<String,Schema.DisplayType>>();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sObjectName).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values()) {
            Schema.DescribeFieldResult dfield = sfield.getDescribe();
            Map<String,Schema.DisplayType> typeByLabe = new Map<String,Schema.DisplayType>();
            typeByLabe.put(dfield.getLabel(), dfield.getType());
            sObjectFileds.put(dfield.getName(), typeByLabe);
        }
        return sObjectFileds;
    }

    public static List<String> getSObjectFileds(String sObjectName) {
        List<String> fileds = new List<String>();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(sObjectName).getDescribe().fields.getMap();
        for(Schema.SObjectField sfield : fieldMap.Values()) {
            Schema.DescribeFieldResult dfield = sfield.getDescribe();
            Map<String,Schema.DisplayType> typeByLabe = new Map<String,Schema.DisplayType>();
            fileds.add(dfield.getName());
        }
        return fileds;
    }

    public static List<String> getPickListValues(String sObjectName, String fieldName){
        List<String> pickListValues = new List<String>();
        List<Schema.DescribeSobjectResult> results = Schema.describeSObjects(new List<String>{sObjectName});
        for(Schema.DescribeSobjectResult res : results) {
            for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) {
                if (entry.isActive()) {
                    pickListValues.add(entry.getValue());
                }
            }
        }
        return pickListValues;
    }
    
    public static Boolean isAsync() {
		return System.isBatch() || System.isQueueable() || System.isScheduled() || System.isFuture();
	}

    public static Schema.sObjectField getSObjectField (Schema.SObjectField  sobjectField) {
        Schema.DescribeFieldResult describe = sobjectField.getDescribe();
        Schema.sObjectField objectField = describe.getSObjectField();
        return objectField;
    }
    
    public static Datetime getNowDatetimeByTimezone(String userTimeZone) {
        //'America/Los_Angeles';
        Datetime gmt = DateTime.now();
        Integer offset = Timezone.getTimeZone(userTimeZone).getOffset(gmt);
        Datetime local = gmt.addSeconds(offset/1000);
        return local;
    }

    /**
    * @brief gets sObject name
    * @param recordId - record id
    * @return sObject name
    */
    public static String getSObjectNameById(Id recordId) {
        return recordId.getSObjectType().getDescribe().getName();
    }

    /**
    * @brief creates sObject records
    * @param sObjectType - sObject type as 'Account.sObjectType'
    * @param count - number of records
    * @return list of sObject records
    */
    public static List<SObject> createRecords(SObjectType sObjectType, Integer count) {
        //example: Utility.createRecords(Account.sObjectType, 42);
        List<SObject> records = new List<SObject>();
        for (Integer i = 0; i < count; i++)
            records.add(sObjectType.newSObject());
        return records;
    }

    /**
    * @brief creates and send an email
    * @return list of SendEmailResult records
    */
    public static List<Messaging.SendEmailResult> sendEmail(String toAddress, String ccAddress, String replyTo, String senderDisplayName, String subject, String plainTextBody, String htmlBody){
        Messaging.reserveSingleEmailCapacity(2);
        
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{toAddress});
        mail.setBccSender(false);
        mail.setUseSignature(false);

        if (ccAddress != null) mail.setCcAddresses(new List<String>{ccAddress});
        if (replyTo != null) mail.setReplyTo(replyTo);
        if (senderDisplayName != null) mail.setSenderDisplayName(senderDisplayName);
        if (subject != null) mail.setSubject(subject);
        if (plainTextBody != null) mail.setPlainTextBody(plainTextBody);
        if (htmlBody != null) mail.setHtmlBody(htmlBody);

        List<Messaging.SendEmailResult> result = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
        return result;
    }
}
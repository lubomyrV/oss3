@isTest
public class LoggerTest {
    @isTest
    static void log_pos() {
        Logger logger = new Logger(LoggerTest.class);
        String msg = 'Lorem ipsum dolor sit amet';
        logger.log(LoggingLevel.DEBUG.toString(), msg);
        logger.saveLogs();
        List<Log__c> logs = [SELECT Type__c, Message__c, StackTrace__c, Class__c FROM Log__c];
        Assert.areEqual(msg, logs.get(0).Message__c, 'Message__c does not match');
        Assert.areEqual(LoggingLevel.DEBUG.toString(), logs.get(0).Type__c, 'Type__c does not match');
        Assert.areEqual(LoggerTest.class.getName(), logs.get(0).Class__c, 'Class__c does not match');
    }

    @isTest
    static void log2_pos() {
        Logger logger = new Logger();
        String msg = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.';
        logger.log(LoggingLevel.DEBUG.toString(), msg);
        logger.saveLogs();
        List<Log__c> logs = [SELECT Type__c, Message__c, Description__c, Class__c FROM Log__c];
        Assert.areEqual(msg, logs.get(0).Description__c, 'Description__c does not match');
        Assert.areEqual(LoggingLevel.DEBUG.toString(), logs.get(0).Type__c, 'Type__c does not match');
    }

    @isTest
    static void log_exp_pos() {
        Logger logger = new Logger();
        try {
            Integer i = 5 / 0;
        } catch (Exception exp) {
            logger.log(exp);
        }
        logger.saveLogs();
        List<Log__c> logs = [SELECT Type__c, Message__c, StackTrace__c, Class__c FROM Log__c];
        Assert.areEqual('Divide by 0', logs.get(0).Message__c, 'Message__c does not match');
        Assert.areEqual('System.MathException', logs.get(0).Type__c, 'Type__c does not match');
    }

    @isTest
    static void log_dmlexp_pos() {
        Logger logger = new Logger(LoggerTest.class);
        try {
            insert new Contact();
        } catch (Exception exp) {
            logger.log(exp);
        }
        logger.saveLogs(logger.getLogs());
        List<Log__c> logs = [SELECT Type__c, Message__c, StackTrace__c, Class__c FROM Log__c];
        Assert.areEqual('Insert failed. First exception on row 0; first error: REQUIRED_FIELD_MISSING, Required fields are missing: [LastName]: [LastName]', logs.get(0).Message__c, 'Message__c does not match');
        Assert.areEqual('System.DmlException', logs.get(0).Type__c, 'Type__c does not match');
    }

    @isTest
    static void log_batchevt_pos() {
        Logger logger = new Logger(LoggerTest.class);
        logger.log(new BatchApexErrorEvent());
        logger.saveLogs(logger.getLogs());
        List<Log__c> logs = [SELECT Type__c, Message__c, Description__c, Class__c FROM Log__c];
        Assert.areEqual(true, logs.get(0).Description__c.length() > 0, 'Description__c does not match');
    }

}
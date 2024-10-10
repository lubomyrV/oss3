@isTest
public class AccountTriggerHandlerTest {
    @testSetup
    static void setup() {
        System.debug('testSetup');
        List<Account> accounts = TestDataFactory.createAccounts(200, null);//new Account(Phone = '777555333222')
        accounts.add(new Account(Name = 'setup'));
        insert accounts; 
        accounts = [SELECT Id, Name, Phone FROM Account WHERE Name = 'setup'];
        System.debug('setup ' + accounts);
    }
    @isTest
    static void test1_pos() {
        System.debug('test1');
        List<Account> accounts = [SELECT Id, Name, Phone FROM Account WHERE Name = 'setup'];
        System.debug('begin ' + accounts);
        delete accounts;
        insert new Account(Name = 'test1'); 
        accounts = [SELECT Id, Name, Phone FROM Account WHERE Name = 'setup'];
        System.debug('end ' + accounts);
        Assert.areEqual(0, accounts.size(), 'Account was not delited');
    }

    @isTest
    static void test2_neg() {
        System.debug('test2');
        List<Account> accounts = [SELECT Id, Name, Phone FROM Account WHERE Name = 'setup'];
        System.debug('begin ' + accounts);
        delete accounts;
        Test.startTest();
            insert new Account(Name = 'test2');
        Test.stopTest();
        accounts = [SELECT Id, Name, Phone FROM Account WHERE Name = 'setup'];
        System.debug('end ' + accounts);
        Assert.areNotEqual(6, accounts.size(), 'Account was not delited');
    }
}
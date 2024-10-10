@isTest
public with sharing class DemoClassTest {

    @isTest
    static void method2_pos() {
        List<Account> accounts = new List<Account>();
        accounts.add(new Account(Name = 'Test', Phone = '111222333444'));
        String expectedPhone = '777555222333';
        Test.startTest();
            AccountSelector accountSelectorMock = (AccountSelector) Test.createStub(AccountSelector.class, new AccountSelectorMock(accounts));
            DmlUtility dmlUtilityMock = (DmlUtility) Test.createStub(DmlUtility.class, new DmlUtilityMock(accounts));
            List<Account> newAccounts = new DemoClass(accountSelectorMock, dmlUtilityMock).updateAccountPhone('Test', expectedPhone);
        Test.stopTest();
        Assert.areEqual(expectedPhone, newAccounts.get(0).Phone, 'Phone was not updated!');
    }
}
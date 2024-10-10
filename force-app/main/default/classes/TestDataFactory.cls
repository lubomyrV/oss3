@isTest
public with sharing class TestDataFactory {
    
    public static List<Account> createAccounts(Integer size, Account accountToClone) {
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < size; i++) {
            Account account = new Account();
            if (accountToClone != null) {
                Boolean preserveId = true;
                Boolean isDeepClone = true;
                Boolean preserveReadonlyTimestamps = false;
                Boolean preserveAutonumber = false;
                account = accountToClone.clone(preserveId, isDeepClone, preserveReadonlyTimestamps, preserveAutonumber);
            }
            account.Name = 'Account ' + i;
            System.debug(account);
            accounts.add(account);
        }
        return accounts;
    }
}
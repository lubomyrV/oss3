public with sharing class AccountService implements IService{
    public AccountService() {}


    public List<Account> doSomething(String accountName) {
        List<Account> results = new AccountSelector().getAccountsByName(accountName);
        results = new AccountDomain().updatePhones(results);
        results = (List<Account>)new DmlUtility().updateSobjects(results);
        return results;
    }

}
@isTest
public with sharing class AccountSelectorMock implements StubProvider {
    List<Account> accounts;
    public AccountSelectorMock(List<Account> accounts) {
        this.accounts = accounts;
    }

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, 
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, 
        List<Object> listOfArgs) {
        if(stubbedMethodName == 'getAccountsByName'){
            return accounts;
        }

        return new Account();
    }
}
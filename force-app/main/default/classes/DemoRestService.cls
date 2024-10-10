@RestResource(urlMapping='/Account/*')
global with sharing class DemoRestService {
    @HttpDelete
    global static void doDelete() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        Account account = [SELECT Id FROM Account WHERE Id = :accountId];
        delete account;
    }
  
    @HttpGet
    global static String doGet() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);

        List<Account> result = new List<Account>();
        if (accountId != null && accountId == 'getAll'){
            result = [SELECT Id FROM Account LIMIT 50000];
            if (!result.isEmpty()){
                Set<Id> accountIds = new Set<Id>();
                for (Account account : result) {
                    accountIds.add(account.Id);
                }
                return JSON.serialize(accountIds);
            }
        }

        result = [SELECT Id, Name, Phone, Website FROM Account WHERE Id = :accountId];
        if (!result.isEmpty()){
            return JSON.serialize(result);
        }
        return null;
    }
  
    @HttpPost
    global static String doPost(String name, String phone, String website) {
        Account account = new Account();
        account.Name = name;
        account.phone = phone;
        account.website = website;
        insert account;
        return account.Id;
    }

    @HttpPatch
    global static String doPatch(String accountId, String phone) {
        List<Account> accounts =[SELECT Phone FROM Account WHERE Id = :accountId];
        if (!accounts.isEmpty()){
            accounts.get(0).Phone = phone;
            update accounts;
            return accounts.get(0).Id;
        }
        return 'Account not found.';
    }
}
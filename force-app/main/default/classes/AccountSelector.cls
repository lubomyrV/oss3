public inherited sharing class AccountSelector extends SObjectSelector {
    
    private Schema.SObjectType getSObjectType() {
        return Account.getSObjectType();
    }
    private List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            Account.Id,
            Account.Name,
            Account.Phone, 
            Account.Fax, 
            Account.Industry, 
            Account.AccountNumber, 
            Account.AccountSource, 
            Account.Type, 
            Account.Website, 
            Account.PhotoUrl, 
            Account.Rating, 
            Account.Site, 
            Account.NumberOfEmployees, 
            Account.AnnualRevenue
        };
    }

    public List<Account> getAccountsByName(String accountName) {
        String query = this.getQueryBuilder()
            .addField('Fax')
            .addField(Account.Phone)
            .addCondition('WHERE Name =:accountName')
            .toSOQL();
        return Database.query(query);
    }
}
public with sharing class AccountDomain extends SObjectDomain {

    public List<Account> updatePhones(List<Account> accounts){
        for(Account account : accounts){
            if (account.Phone == '444') {
                account.Phone = '1234567890';
            }
        }
        return accounts;
    }

    protected override void validate(){
        validatePhone();
    }


    protected override void beforeUpdate() {
        this.updatePhones((List<Account>)this.records);
    }

    protected override void afterUpdate() {
        Account acc = (Account)this.records.get(0);
        try {

        } catch (Exception e) {
            acc.addError(e.getMessage() + ', ERROR_CODE: AccountS.dS8, Please try again later or contact your system administrator');
        }
        TriggerHandler.addBypass('AccountDomain');
        TriggerHandler.removeBypass('AccountDomain');
    }

    private void validatePhone() {
        Schema.sObjectField fieldApiName = Utility.getSObjectField(Account.Phone);
        for (Account record : (List<Account>)this.records) {
            if (record.Phone == null) {
                record.addError(fieldApiName, 'Phone cannot be empty!');
            }
        }
    }
}
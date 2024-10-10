public class DemoClass {

	AccountSelector accountSelector;
	DmlUtility dmlUtility;
	public DemoClass() {
		this(new AccountSelector(), new DmlUtility());
	}

	@TestVisible
	private DemoClass(AccountSelector accountSelector, DmlUtility dmlUtility) {
		this.accountSelector = accountSelector;
		this.dmlUtility = dmlUtility;
	}

	public static void method1() {
		try {
			// for (Integer i = 0; i < 201; i++) {
			// 	if (Limits.getQueries() >= Limits.getLimitQueries()) {
			// 		throw new HandledException('Too many SOQL queries: ' + Limits.getQueries());
			// 	}
			// 	List<SObject> res = [SELECT Id FROM Contact];
			// }
			new DmlUtility().insertSobjects(new List<Contact>{new Contact()});
		} catch (Exception exp){
			System.debug(exp.getMessage());
			new Logger(DemoClass.class).log(exp).saveLogs();
		}
	}
    
    public List<Account> updateAccountPhone(String accountName, String phone) {
		List<Account> accounts = accountSelector.getAccountsByName(accountName);
		System.debug('accounts before'+ accounts);
		for (Account account : accounts) {
			account.Phone = phone;
		}
		accounts = dmlUtility.updateSobjects(accounts);
		System.debug('accounts '+ accounts);
		return accounts;
	}
}
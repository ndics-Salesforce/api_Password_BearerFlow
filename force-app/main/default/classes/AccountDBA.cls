public class AccountDBA extends RestApi {
	public AccountDBA() {
	}

	public void upsertAccounts(List<Object> records) {
		if (records != null && records.size() > 0) {
			List<Account> accList = new List<Account>();
			// アカウント毎に外部キーを使用しUpsert
			try {
				for (Object record : records) {
					Map<String, Object> tmp = (Map<String, Object>) record;
					Account acc = new Account();
					acc.Name = (String) tmp.get(PROPERTY_NAME);
					acc.ExternalId__c = (String) tmp.get(PROPERTY_ID);
					accList.add(acc);
				}

				upsert accList ExternalId__c;
			} catch (Exception e) {
				System.debug('The following exception has occurred while upsert accounts: ' + e.getMessage());
			}
		} else {
			System.debug('No Account obtained');
		}
	}
}

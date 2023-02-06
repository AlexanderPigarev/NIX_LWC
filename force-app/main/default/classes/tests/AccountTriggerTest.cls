@IsTest
private class AccountTriggerTest {
	private static final List<Account> ACCOUNTS = TestDataFactory.createAccountsList(5, null, false);

	@IsTest
	static void checkShippingAddressData() {

		for (Account a : [SELECT FIELDS(STANDARD) FROM Account LIMIT 200]) {
			System.assertEquals(a.BillingCity, a.ShippingCity);
			System.assertEquals(a.BillingCountryCode, a.ShippingCountryCode);
			System.assertEquals(a.BillingStateCode, a.ShippingStateCode);
			System.assertEquals(a.BillingState, a.ShippingState);
			System.assertEquals(a.BillingStreet, a.ShippingStreet);
			System.assertEquals(a.BillingPostalCode, a.ShippingPostalCode);
		}
	}

	@IsTest
	static void accountsDeletion() {
		Test.startTest();
		Database.DeleteResult[] results = Database.delete(ACCOUNTS, false);
		Test.stopTest();

		for (Database.DeleteResult dr : results) {
			System.assert(!dr.isSuccess());
			System.assert(dr.getErrors().size() > 0);
			System.assertEquals('Deleting an account record is prohibited.',
					dr.getErrors()[0].getMessage());
		}
	}


}
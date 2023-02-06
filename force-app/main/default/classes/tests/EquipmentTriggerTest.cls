@IsTest
private class EquipmentTriggerTest {

	@IsTest
	static void equipmentsDeletion() {
		List<Proposal__c> proposals = TestDataFactory.createProposalsWithAccountsAndOpportunities(1);
		Equipment__c equipment = TestDataFactory.createEquipmentsWithEquipmentCategoryList(1)[0];
		Equipment_Set__c equipmentSet = new Equipment_Set__c(Equipment__c = equipment.Id, Proposal__c = proposals[0].Id);
		insert equipmentSet;

		Test.startTest();
		Database.DeleteResult result = Database.delete(equipment, false);
		Test.stopTest();

		System.assert(!result.isSuccess());
		System.assert(result.getErrors().size() > 0);
		System.assertEquals('Current Equipment record can not be deleted, because it is related to Proposal',
				result.getErrors()[0].getMessage());

	}

}
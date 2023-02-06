@IsTest
public with sharing class ProposalTriggerTest {

	private static final List<Proposal__c> PROPOSALS = TestDataFactory.createProposalsWithAccountsAndOpportunities(1);

	@IsTest
	public static void checkOnExistedEqSetInProposalTest() {
		Equipment__c equipment = TestDataFactory.createEquipmentsWithEquipmentCategoryList(1)[0];
		Equipment_Set__c equipmentSet1 = new Equipment_Set__c(Equipment__c = equipment.Id, Proposal__c = PROPOSALS[0].Id);
		insert equipmentSet1;

		Equipment_Set__c equipmentSet2 = new Equipment_Set__c(Equipment__c = equipment.Id, Proposal__c = PROPOSALS[0].Id);

		Test.startTest();
		Database.SaveResult result = Database.insert(equipmentSet2, false);
		Test.stopTest();

		System.debug(result);

		System.assert(!result.isSuccess());
		System.assert(result.getErrors().size() > 0);
		System.assertEquals('Such Equipment already exists in this Proposal.', result.getErrors()[0].getMessage());
	}

	@IsTest
	public static void deletionProposalTest() {
		Proposal__c proposal = PROPOSALS[0];
		proposal.Status__c = 'Sent';
		update proposal;

		Test.startTest();
		Database.DeleteResult result = Database.delete(proposal, false);
		Test.stopTest();

		System.assert(!result.isSuccess());
		System.assert(result.getErrors().size() > 0);
		System.assertEquals('Only proposals with the status "Draft" can be deleted.',
				result.getErrors()[0].getMessage());
	}

}
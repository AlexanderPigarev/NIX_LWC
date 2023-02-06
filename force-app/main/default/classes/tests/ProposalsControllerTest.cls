@IsTest
public with sharing class ProposalsControllerTest {

	private static final List<Proposal__c> PROPOSALS = TestDataFactory.createProposalsWithAccountsAndOpportunities(1);

	@IsTest
	public static void getProposalsServerTest() {
		Test.startTest();
		List<Proposal__c> proposalsFromTestedMethod = ProposalsController.getProposalsServer(PROPOSALS[0].Opportunity__c);
		Test.stopTest();
		System.assertEquals(PROPOSALS.size(), proposalsFromTestedMethod.size());
		System.assertEquals(PROPOSALS[0].Id, proposalsFromTestedMethod[0].Id);
	}

	@IsTest
	public static void deleteSinglePropServerTest() {
		Id pId = PROPOSALS[0].Id;
		Test.startTest();
		ProposalsController.deleteSinglePropServer(pId);
		Test.stopTest();
		System.assertEquals(0, [SELECT COUNT() FROM Proposal__c WHERE Id = :pId]);
	}

}
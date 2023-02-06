@IsTest
public with sharing class ProposalPDFControllerTest {

	@TestSetup
	private static void testSetup() {
		Proposal__c proposal = TestDataFactory.createProposalsWithAccountsAndOpportunities(1)[0];

		Equipment__c equipment = TestDataFactory.createEquipmentsWithEquipmentCategoryList(1)[0];
		Equipment_Set__c equipmentSet = new Equipment_Set__c(Proposal__c = proposal.Id, Equipment__c = equipment.Id, Quantity__c = 13);
		insert equipmentSet;
	}

	@IsTest
	public static void testProposalPDFPage() {
		Id proposalId = [SELECT Id, Name FROM Proposal__c WHERE Name = 'TestProposal0'].Id;

		Test.startTest();
		PageReference pageRef = Page.ProposalRenderPDF;
		pageRef.getParameters().put('Id', proposalId);
		Test.setCurrentPage(pageRef);

		ProposalPDFController testProp = new ProposalPDFController();
		Proposal__c prop = ProposalPDFController.proposal;
		List <Equipment_Set__c> equipmentItems = ProposalPDFController.equipmentItems;
		OpportunityContactRole primaryContact = ProposalPDFController.primaryContact;
		Test.stopTest();

		System.assertEquals('TestProposal0', prop.Name);
		System.assertEquals(13, equipmentItems[0].Quantity__c);
		System.assert(primaryContact != null);
	}

}
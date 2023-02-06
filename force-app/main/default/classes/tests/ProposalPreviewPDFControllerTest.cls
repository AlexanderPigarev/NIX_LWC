@IsTest
public with sharing class ProposalPreviewPDFControllerTest {

	@IsTest
	public static void generateProposalPDFTest() {
		Proposal__c proposal = TestDataFactory.createProposalsWithAccountsAndOpportunities(1)[0];

		Test.startTest();
		Map<String, String> pdfTestData = ProposalPreviewPDFController.generateProposalPDF(proposal.Id);
		Test.stopTest();

		Id contentDocId = pdfTestData.get('contentDocId');
		Id cvId = pdfTestData.get('cvId');

		List<ContentDocumentLink> cdl = [SELECT ContentDocumentId FROM ContentDocumentLink WHERE ContentDocumentId = :contentDocId];
		ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cvId];

		System.assert(cv != null);
		System.assert(cdl.size() > 0);
	}

	@IsTest
	public static void sendSingleEmail() {
		ProposalPreviewPDFController.sendSingleEmail(TestDataFactory.getEmailTestData(null));

	}
}
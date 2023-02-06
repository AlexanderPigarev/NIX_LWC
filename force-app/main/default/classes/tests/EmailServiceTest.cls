@IsTest
public with sharing class EmailServiceTest {

	@IsTest
	public static void sendEmailWithAttachmentTest() {
		Proposal__c proposal = TestDataFactory.createProposalsWithAccountsAndOpportunities(1)[0];
		Map<String, String> fileIdsMap = TestDataFactory.createAttachmentFile(proposal.Id);

		System.debug('CDL: ' + fileIdsMap);
		Map<String, List<String>> emailTestData = TestDataFactory.getEmailTestData(new List<String>{
				fileIdsMap.get('cvId')
		});

		List<String> recipients, ccRecipients, bccRecipients;
		recipients = ccRecipients = bccRecipients = emailTestData.get('recipients');

		String subject = emailTestData.get('subject')[0];
		String body = emailTestData.get('body')[0];
		List<String> filesIds = emailTestData.get('filesIds');

		Test.startTest();
		EmailService.sendSingleEmail(recipients, ccRecipients, bccRecipients, subject, body, filesIds);
		Integer invocations = Limits.getEmailInvocations();
		Test.stopTest();

		System.assertEquals(1, invocations, 'An email should be sent');
	}
}
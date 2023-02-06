/**
 * @author Olexander Piharev
 * @version 1.0
 *
 * @since 2023-01-22
 */
public with sharing class ProposalPreviewPDFController {

	/**
	 * This method stores the generated PDF file.
	 *
	 * @param proposalId - Proposal Id
	 *
	 * @return : id of ContentVersion (file id, for using in email); id of ContentDocumentId (link to the file, for download)
	 */
	@AuraEnabled
	public static Map<String, String> generateProposalPDF(Id proposalId) {
		String proposalName = '';

		if (proposalId == null) return null;
		List<Proposal__c> proposalList = [SELECT Id, Name FROM Proposal__c WHERE Id = :proposalId];
		if (!proposalList.isEmpty()) {
			proposalName = proposalList[0].Name;
		}
		Blob body;

		try {
			// PageReference pageRef = new PageReference('/apex/ProposalRenderPDF?іd=' + proposalId); // the link to VF page
			PageReference pageRef = Page.ProposalRenderPDF;
			pageRef.getParameters().put('Id', proposalId);

			ContentVersion cont = new ContentVersion();
			cont.ContentLocation = 'S'; // S - used in SF
			cont.PathOnClient = 'Proposal ' + proposalName + '.pdf';
			cont.Title = 'Proposal ' + proposalName + ' Template';
			if (Test.isRunningTest()) {
				body = Blob.valueOf('Unit.Test');
			} else {
				body = pageRef.getContentAsPDF();
			}
			cont.VersionData = body;
			insert cont;

			ContentVersion cv = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cont.Id];
			Id objDocId = cv.ContentDocumentId;

			ContentDocumentLink cdl = new ContentDocumentLink();
			cdl.LinkedEntityId = proposalId;
			cdl.ContentDocumentId = objDocId;

			insert cdl;

			return new Map<String, String>{
					'contentDocId' => cdl.ContentDocumentId,
					'cvId' => cv.Id
			};
		} catch (Exception e) {
			e.getMessage();
			return null;
		}
	}

	/**
	 * The method get the data for email, convert it and call the method that send single email.
	 *
	 * @param params - contains all necessary data to send email
	 *
	 * @return -message to display on UI
	 */
	@AuraEnabled
	public static String sendSingleEmail(Map<String, List<String>>params) {

		List<String> recipients = params.get('recipients');
		String subject = params.get('subject')[0];
		String body = params.get('body')[0];
		List<String> filesIds = params.get('filesIds');

		EmailService.sendSingleEmail(recipients, null, null, subject, body, filesIds);
		return 'Success';
	}

}
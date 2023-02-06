/**
 * @author Olexander Piharev
 * @version 1.0
 *
 * @since 2023-01-25
 */
public with sharing class EmailService {

	/**
	 * The method for send single email.
	 *
	 * @param recipients - contains list of primary email addresses
	 * @param ccRecipients - contains list of CC email addresses
	 * @param bccRecipients - contains list of BCC email addresses
	 * @param subject - subject, text
	 * @param body - subject, text
	 * @param filesIds - list of ids of attached files
	 */
	@AuraEnabled
	public static void sendSingleEmail(List<String> recipients, List<String> ccRecipients, List<String>bccRecipients, String subject, String body, List<String> filesIds) {
		// TODO check on empty params

		Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
		email.setToAddresses(recipients);
		email.setCcAddresses(ccRecipients);
		email.setBccAddresses(bccRecipients);
		email.setSubject(subject);
		email.setPlainTextBody(body);
		email.setHtmlBody(body);
		if (filesIds != null) email.setEntityAttachments(filesIds);

		Messaging.sendEmail(new Messaging.SingleEmailMessage[]{
				email
		});

	}

}
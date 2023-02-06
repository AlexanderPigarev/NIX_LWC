/**
 * @author Olexander Piharev
 * @version 1.0
 *
 * @since 2023-01-27
 */
public class ProposalPDFController {

	private static final String propId = ApexPages.currentPage().getParameters().get('Id');

	public ProposalPDFController() {
		System.debug('Proposal Id from VF Controller: ' + propId);
	}

	public static Proposal__c proposal {
		get {
			if (proposal == null) {
				proposal = [
						SELECT Name, Opportunity__c, Opportunity__r.Account.Name, Total_Quantity__c, Total_Price__c
						FROM Proposal__c
						WHERE Id = :propId
						LIMIT 1
				];
			}
			return proposal;
		}
		set;
	}

	public static List <Equipment_Set__c> equipmentItems {
		get {
			if (equipmentItems == null) {
				equipmentItems = [
						SELECT Name, Equipment__r.Name, Cost__c, Quantity__c, Price__c, Price_per_1__c
						FROM Equipment_Set__c
						WHERE Proposal__c = :propId
						ORDER BY Name
				];
			}
			return equipmentItems;
		}
		set;
	}

	public static OpportunityContactRole primaryContact {
		get {
			if (primaryContact == null) {
				primaryContact = [
						SELECT Contact.Name, Contact.MailingCountry, Contact.MailingCity, Contact.MailingState, Contact.MailingStreet, Contact.MailingPostalCode,
								Contact.Email
						FROM OpportunityContactRole
						WHERE OpportunityId = :proposal.Opportunity__c
						// AND IsPrimary = TRUE
						LIMIT 1
				];
			}
			return primaryContact;
		}
		set;
	}

}
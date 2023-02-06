/**
 * @author Olexander Piharev
 * @version 1.0
 *
 * @since 2023-01-17
 */
public without sharing class OpportunityTriggerHelper {

	/**
	 * The method set contact as primary and add role by the last that was referenced to Opportunity (triggered on insert Opportunity only)
	 *
	 * @param opp - newly created Opportunity Id
	 */
	public static void setPrimaryContact(Opportunity opp) {

		List<Contact> contacts = [
				SELECT Id, Name, AccountReferenceDate__c
				FROM Contact
				WHERE AccountReferenceDate__c != NULL AND AccountId = :opp.AccountId
				ORDER BY AccountReferenceDate__c DESC
		];

		if (!contacts.isEmpty()) {
			insert new OpportunityContactRole(OpportunityId = opp.Id, Role = 'Decision Maker', IsPrimary = true, ContactId = contacts[0].Id);
		}
	}

	/**
	 * The method returns to null values in Loss Reason fields.
	 * Needs when a user change back stage from "Closed Lost" to another
	 *
	 * @param opp - current Opportunity Id
	 */
	public static void resetReasonFields(Opportunity opp) {
		opp.Loss_Reason__c = null;
		opp.Loss_Reason_Details__c = null;
	}
}
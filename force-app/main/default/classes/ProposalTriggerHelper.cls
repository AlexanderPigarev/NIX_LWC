/**
 * @author Olexander Piharev
 * @version 1.0
 *
 * @since 2023-01-16
 */
public without sharing class ProposalTriggerHelper {

	/**
	 * This method check on duplicates Equipment in one Proposal
	 *
	 * @param propId - current Proposal Id
	 *
	 * @return message error message if plurality found
	 */
	public static String checkOnExistedEqSetInProposal(Id propId) {
		String message = '';
		Set <Id> eqIdsSet = new Set<Id>();
		List <Equipment_Set__c> eqListInProposal = [SELECT Id, Equipment__c FROM Equipment_Set__c WHERE Proposal__c = :propId];
		if (!eqListInProposal.isEmpty()) {
			for (Equipment_Set__c eSet : eqListInProposal) {
				eqIdsSet.add(eSet.Equipment__c);
			}
			if (eqListInProposal.size() != eqIdsSet.size()) message = 'Such Equipment already exists in this Proposal.';
		}
		return message;
	}
}
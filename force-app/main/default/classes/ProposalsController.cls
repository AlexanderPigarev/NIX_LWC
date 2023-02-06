/**
 * @author Olexander Piharev
 * @version 1.0
 *
 * @since 2023-01-17
 */
public with sharing class ProposalsController {

	/**
	 * This method get all proposal of related Opportunity
	 *
	 * @param oppId - related Opportunity Id
	 *
	 * @return proposals list
	 */
	@AuraEnabled
	public static List<Proposal__c> getProposalsServer(Id oppId) {
		System.debug('Opp Id: ' + oppId);
		return [
				SELECT Id, Name, Opportunity__r.Name, Status__c, Total_Price__c, isActionsDisabled__c
				FROM Proposal__c
				WHERE Opportunity__r.Id = :oppId
				ORDER BY CreatedDate
		];
	}

	/**
	 * The method for deleting single proposal by id
	 *
	 * @param propId -proposal Id
	 */
	@AuraEnabled
	public static void deleteSinglePropServer(Id propId) {
		System.debug('Proposal Id to delete: ' + propId);
		delete [SELECT Id FROM Proposal__c WHERE Id = :propId];
	}

}
/**
 * @author Olexander Piharev
 * @version 1.0
 *
 * @since 2023-01-17
 */
public with sharing class ProposalCreationPageController {

	/**
	 * The method gets all Equipment Category records.
	 *
	 * @return a list of Equipment Category
	 */
	@AuraEnabled
	public static List<Equipment_Category__c> getCategoriesServer() {

		return [
				SELECT Id, Name
				FROM Equipment_Category__c
				ORDER BY Name
		];
	}

	/**
	 * The method gets Equipment records that Name match to entered text and Equipment Category.
	 *
	 * @param params : nameKey - a part of Equipment Name; categoryId - Equipment Category Id
	 *
	 * @return a list of found by filter Equipment
	 */
	@AuraEnabled
	public static List<Equipment__c> getProductsServer(Map<String, String> params) {
		System.debug('Product params: ' + params);

		String categoryId = params.get('categoryId');
		String nameKey = params.get('nameKey');

		categoryId = categoryId == null ? '' : categoryId;
		nameKey = nameKey == null ? '' : nameKey;

		String s = 'SELECT Id, Name, Cost__c, Equipment_Category__r.Name, Vendor__r.Name ';
		String f = ' FROM Equipment__c ';
		String w = ' WHERE Equipment_Category__c = \'' + categoryId + '\' AND Name LIKE \'%' + nameKey + '%\' ' ;
		String o = ' ORDER BY Name';
		String l = ' LIMIT 2000';

		return Database.query(s + f + w + o + l);
	}

	/**
	 * The method insert new Proposal and fetch method that creates related EquipmentSets
	 *
	 * @param params : proposalData - data for proposal creation;
	 * productsDataList - list of related to newly Proposal Equipments
	 */
	@AuraEnabled
	public static void setNewProposalWithProductsServer(Map<String, List<Map<String, String>>> params) {
		System.debug('Proposal creation params: ' + params);
		// Proposal__c newProposal = (Proposal__c) params.get('proposalData')[0]; // TODO figure out why casting not working

		Map<String, String> proposalData = params.get('proposalData')[0];
		List<Map<String, String>> productsDataList = params.get('productsData');

		System.debug('Proposal: ' + proposalData);
		System.debug('Products: ' + productsDataList);

		Proposal__c newProposal = new Proposal__c(Name = proposalData.get('Name'), Opportunity__c = proposalData.get('Opportunity__c'), Status__c = proposalData.get('Status__c'));

		insert newProposal;

		saveNewEquipmentSets(newProposal.Id, productsDataList);
	}

	/**
	 * The method creates EquipmentsSets to specified Proposal
	 *
	 * @param proposalId - Proposal id
	 * @param productsDataList - list of Equipments data
	 */
	private static void saveNewEquipmentSets(String proposalId, List<Map<String, String>> productsDataList) {
		List<Equipment_Set__c> eqList = new List<Equipment_Set__c>();
		for (Map<String, String> e : productsDataList) {
			eqList.add(new Equipment_Set__c(Proposal__c = proposalId, Equipment__c = e.get('Equipment__c'), Quantity__c = Decimal.valueOf(e.get('Quantity__c'))));
		}

		insert eqList;
	}
}
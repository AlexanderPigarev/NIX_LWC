/**
 * @author Olexander Piharev
 * @version 1.0
 * @since 2023-01-05
*/
trigger EquipmentTrigger on Equipment__c (before insert, before update, before delete) {
	if (Trigger.isBefore && Trigger.isDelete) {

		List <Equipment_Set__c> eqS = [SELECT Id FROM Equipment_Set__c WHERE Equipment__c IN: Trigger.old];
		if (!eqS.isEmpty()) {
			Trigger.old[0].addError('Current Equipment record can not be deleted, because it is related to Proposal');
		}
	}
}
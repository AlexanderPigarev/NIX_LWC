/**
 * @author Olexander Piharev
 * @version 1.0
 *
 * @since 2023-01-07
 */
trigger AccountTrigger on Account (before insert, before update, before delete) {

	if (Trigger.isBefore && Trigger.isInsert) {
		for (Account a : Trigger.new) {
			if (a.LeadId_Converted__c != null) AccountTriggerHelper.setShippingAddress(a);
		}
	}

	if (Trigger.isBefore && Trigger.isDelete) {
		for (Account acc : Trigger.old) {
			acc.addError('Deleting an account record is prohibited.');
		}
	}
}
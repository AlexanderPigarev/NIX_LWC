/**
 * @author Olexander Piharev
 * @version 1.0
 * @since 2023-01-07
*/
trigger OpportunityTrigger on Opportunity (before insert, before update, before delete, after insert, after update, after delete) {

	if (Trigger.isAfter && Trigger.isInsert) {
		for (Opportunity opp : Trigger.new) {
			OpportunityTriggerHelper.setPrimaryContact(opp);
		}
	}

	if (Trigger.isBefore && Trigger.isUpdate) {
		for (Opportunity opp : Trigger.new) {
			if (opp.StageName != 'Closed Lost') {
				OpportunityTriggerHelper.resetReasonFields(opp); // when a user change back stage from Closed Lost
			}
		}
	}
}
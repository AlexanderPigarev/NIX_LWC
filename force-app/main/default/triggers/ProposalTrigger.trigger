/**
 * @author Olexander Piharev
 * @version 1.0
 *
 * @since 2023-01-12
 */
trigger ProposalTrigger on Proposal__c (before insert, before update, before delete) {

	if (Trigger.isBefore && Trigger.isUpdate) {
		for (Proposal__c prop : Trigger.new) {
			String message = ProposalTriggerHelper.checkOnExistedEqSetInProposal(prop.Id);
			if (message != '') Trigger.new[0].addError(message);
		}
	}

	if (Trigger.isBefore && Trigger.isDelete) {
		for (Proposal__c oldRec : Trigger.old) {
			if (oldRec.Status__c != 'Draft') {
				oldRec.addError('Only proposals with the status "Draft" can be deleted.');
			}
		}
	}
}
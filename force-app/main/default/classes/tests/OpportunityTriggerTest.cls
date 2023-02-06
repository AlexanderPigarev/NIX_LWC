@IsTest
public class OpportunityTriggerTest {

	@IsTest
	public static void setPrimaryContactTest() {
		Opportunity opportunity = TestDataFactory.createOpportunitiesWithAccounts(1, true)[0];

		Test.startTest();
		OpportunityContactRole ocr = [SELECT OpportunityId, Role, IsPrimary, ContactId FROM OpportunityContactRole WHERE OpportunityId = :opportunity.Id];
		Test.stopTest();

		System.assertEquals('Decision Maker', ocr.Role);
		System.assertEquals(true, ocr.IsPrimary);
	}

	@IsTest
	public static void resetClosedLostReasonTest() {
		List<Opportunity> opportunities = [SELECT Id FROM Opportunity LIMIT 1];
		if (opportunities.isEmpty()) opportunities = TestDataFactory.createOpportunitiesWithAccounts(1, false);
		Opportunity o = opportunities[0];
		o.StageName = 'Closed Lost';
		o.Loss_Reason__c = 'Other';
		o.Loss_Reason_Details__c = 'Test Other';
		update o;

		o.StageName = 'Proposal Sent';
		update o;
		Opportunity oppAfterTriggered = [SELECT Id, Loss_Reason__c, Loss_Reason_Details__c FROM Opportunity WHERE Id = :o.Id];

		System.assertEquals(null, oppAfterTriggered.Loss_Reason__c);
		System.assertEquals(null, oppAfterTriggered.Loss_Reason_Details__c);

	}
}
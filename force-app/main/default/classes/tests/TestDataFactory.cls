@IsTest
public with sharing class TestDataFactory {

	public static List<Account> createAccountsList(Integer numRecords, String recordTypeName, Boolean withContacts) {
		if (recordTypeName == null) recordTypeName = 'Buyer';

		List<Account> aList = new List<Account>();
		for (Integer i = 0; i < numRecords; i++) {
			Account a = new Account(
					Name = recordTypeName + 'TestAccount' + i,
					LeadId_Converted__c = 'testId',
					BillingCity = 'NY',
					BillingCountryCode = 'US',
					BillingStateCode = 'NY',
					BillingState = 'New York',
					BillingStreet = 'Street #' + (i + 1),
					BillingPostalCode = '44444',
					Payment_Method__c = 'Cash',
					RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(recordTypeName).getRecordTypeId()
			);
			aList.add(a);
		}
		insert aList;
		if (withContacts) {
			List<Contact> contacts = createContactsList (numRecords, new List<Id>((new Map<Id, Account>(aList)).keySet()));
		}
		return aList;
	}

	public static List<Opportunity> createOpportunitiesWithAccounts(Integer numRecords, Boolean withContacts) {
		List<Account> accounts = createAccountsList(numRecords, 'Buyer', withContacts);

		List<Opportunity> oList = new List<Opportunity>();
		for (Integer i = 0; i < numRecords; i++) {
			Opportunity o = new Opportunity(
					Name = 'TestOpportunity' + i,
					AccountId = accounts[i].Id,
					StageName = 'Appointment Scheduled',
					CloseDate = Date.newInstance(2025, 2, 17)
			);
			oList.add(o);
		}
		insert oList;
		return oList;
	}

	public static List<Proposal__c> createProposalsWithAccountsAndOpportunities(Integer numRecords) {
		List<Opportunity> opportunities = createOpportunitiesWithAccounts(numRecords, true);

		List<Proposal__c> pList = new List<Proposal__c>();
		for (Integer i = 0; i < numRecords; i++) {
			Proposal__c p = new Proposal__c(
					Name = 'TestProposal' + i,
					Opportunity__c = opportunities[i].Id,
					Status__c = 'Draft'
			);
			pList.add(p);
		}
		insert pList;
		return pList;
	}

	public static Equipment_Category__c createSingleEquipmentCategory() {
		Equipment_Category__c eC = new Equipment_Category__c(Name = 'TestEquipmentCategory', Margin__c = 20);
		insert eC;
		return eC;
	}

	public static List<Equipment__c> createEquipmentsWithEquipmentCategoryList(Integer numRecords) {

		List<Account> accounts = createAccountsList(1, 'Vendor', false);

		Equipment_Category__c eC = createSingleEquipmentCategory();

		List<Equipment__c> eList = new List<Equipment__c>();
		for (Integer i = 0; i < numRecords; i++) {
			Equipment__c e = new Equipment__c(
					Name = 'TestEquipment' + i,
					Description__c = 'TestEquipment' + i,
					Cost__c = 100,
					Equipment_Category__c = eC.Id,
					Vendor__c = accounts[0].Id
			);
			eList.add(e);
		}
		insert eList;
		return eList;
	}

	public static List<Contact> createContactsList(Integer numRecords, List<Id> accountsIds) {

		List<Contact> cList = new List<Contact>();
		for (Integer i = 0; i < numRecords; i++) {
			Contact c = new Contact(
					FirstName = 'TestContactFirstName' + i,
					LastName = 'TestContactLastName' + i,
					AccountId = accountsIds[i],
					AccountReferenceDate__c = Date.today(),
					Email = 'test@test.com'
			);
			cList.add(c);
		}
		insert cList;
		return cList;
	}

	public static Map<String, String> createAttachmentFile(Id parentRecordId) {
		ContentVersion cv = new ContentVersion(
				Title = 'Test CV',
				PathOnClient = 'Test CV.jpg',
				VersionData = Blob.valueOf('Test CV version'),
				IsMajorVersion = true,
				ContentLocation = 'S'
		);
		insert cv;
		List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

		ContentDocumentLink cdl = new ContentDocumentLink();
		cdl.LinkedEntityId = parentRecordId;
		cdl.ContentDocumentId = documents[0].Id;
		cdl.ShareType = 'V';
		insert cdl;
		return new Map<String, String>{
				'contentDocId' => cdl.ContentDocumentId,
				'cvId' => cv.Id
		};
	}

	public static Map<String, List<String>> getEmailTestData(List<String> filesIds) {
		return new Map<String, List<String>>{
				'recipients' => new List<String>{
						'test@test.com'
				},
				'subject' => new List<String>{
						'Test Subject'
				},
				'body' => new List<String>{
						'Test Body'
				},
				'filesIds' => (filesIds == null) ? null : filesIds
		};
	}
}
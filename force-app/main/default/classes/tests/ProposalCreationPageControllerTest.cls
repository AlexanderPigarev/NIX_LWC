@IsTest
public with sharing class ProposalCreationPageControllerTest {

	@IsTest
	public static void getCategoriesServerTest() {

		Equipment_Category__c equipmentCategory = TestDataFactory.createSingleEquipmentCategory();

		Test.startTest();
		List<Equipment_Category__c> equipmentCategoriesFromTestedMethod = ProposalCreationPageController.getCategoriesServer();
		Test.stopTest();

		System.assertEquals(1, equipmentCategoriesFromTestedMethod.size());
		System.assertEquals(equipmentCategory.Id, equipmentCategoriesFromTestedMethod[0].Id);
	}

	@IsTest
	public static void getProductsServerTest() {
		List<Equipment__c> equipments = TestDataFactory.createEquipmentsWithEquipmentCategoryList(5);

		Map<String, String> params = new Map<String, String>{
				'nameKey' => 'equip',
				'categoryId' => equipments[0].Equipment_Category__c
		};

		Test.startTest();
		List<Equipment__c> equipmentsFromTestedMethod = ProposalCreationPageController.getProductsServer(params);
		Test.stopTest();

		System.assertEquals(equipments.size(), equipmentsFromTestedMethod.size());
	}

	@IsTest
	public static void setNewProposalWithProductsServerTest() {

		Opportunity opportunity = TestDataFactory.createOpportunitiesWithAccounts(1, false)[0];
		Equipment__c equipment = TestDataFactory.createEquipmentsWithEquipmentCategoryList(1)[0];


		Map<String, List<Map<String, String>>> params = new Map<String, List<Map<String, String>>>{
				'proposalData' => new List<Map<String, String>>{
						new Map<String, String>{
								'Opportunity__c' => opportunity.Id,
								'Name' => 'TestProposalName777',
								'Status__c' => 'Draft'
						}
				},
				'productsData' => new List<Map<String, String>>{
						new Map<String, String>{
								'Equipment__c' => equipment.Id,
								'Quantity__c' => '10'
						}
				}
		};

		Test.startTest();
		ProposalCreationPageController.setNewProposalWithProductsServer(params);
		Test.stopTest();

		List<Proposal__c> proposalTested = [SELECT Name, Opportunity__c FROM Proposal__c WHERE Opportunity__c = :opportunity.Id];
		List<Equipment_Set__c> equipmentSetTested = [SELECT Equipment__c, Proposal__c, Quantity__c FROM Equipment_Set__c WHERE Proposal__r.Opportunity__c = :opportunity.Id];

		System.assertEquals(false, proposalTested.isEmpty());
		System.assertEquals(false, equipmentSetTested.isEmpty());
		System.assertEquals('TestProposalName777', proposalTested[0].Name);
		System.assertEquals(10, equipmentSetTested[0].Quantity__c);
	}
}
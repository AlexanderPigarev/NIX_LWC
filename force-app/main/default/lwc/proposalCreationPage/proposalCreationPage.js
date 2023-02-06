import {LightningElement, api, track} from 'lwc';
import {_cl, _message, _isInvalid, _numberedList, _parseServerError} from 'c/utils';

import getCategoriesServer from "@salesforce/apex/ProposalCreationPageController.getCategoriesServer";
import getProductsServer from "@salesforce/apex/ProposalCreationPageController.getProductsServer";
import setProposalWithProductsServer from "@salesforce/apex/ProposalCreationPageController.setNewProposalWithProductsServer";

export default class ProposalCreationPage extends LightningElement {
	@api oppId;

	// --> RENDER
	@track isContentReadyToRender = false;
	@track isProductsTableReadyToRender = false;
	@track isSaveBtnDisabled = true;

	// --< RENDER

	@track categoriesOptions = [];
	@track productsList = [];
	@track categoryId = '';

	newProposalName = '';
	productNameKey = '';
	proposalWithProductsDataToSave = {};
	quantityTemp = 1;
	selectedRowsCounter = 0;

	connectedCallback() {
		this.doInit();
	}

	doInit() {
		document.title = 'New Proposal';
		this.getCategories();
	}


	setCategoriesOptions(categoriesList) {
		categoriesList.forEach(i => {
			this.categoriesOptions.push({label: i.Name, value: i.Id});
		});
		_cl(JSON.stringify(this.categoriesOptions));
		this.isContentReadyToRender = true;
	}

	setCategoryId(event) {
		_cl("Category: " + event.detail.value, "green");
		this.categoryId = event.detail.value;
	}


	handleSetNewProposalName(event) {
		_cl("New Proposal Name: " + event.detail.value, "lightgreen");
		this.newProposalName = event.detail.value;
	}

	handleSetProductNameKey(event) {
		_cl("Product Name Key: " + event.detail.value, "violet");
		this.productNameKey = event.detail.value;
	}

	closeModalWindow() {
		this.dispatchEvent(new CustomEvent('closecreationmodalwindow', {detail: false}));
	}

	productsSearchFilter() {
		const message = this.validateSearchFilterData();
		if (message !== null) {
			_message('warning', null, message);
			return;
		}
		return {nameKey: this.productNameKey, categoryId: this.categoryId};
	}

	validateSearchFilterData() { // TODO with a switch case to manage many fields
		let message = null;

		if (this.productNameKey === '') message = 'Product Name is missing or incorrect.';
		if (this.categoryId === '') message = 'Category data is missing or incorrect.';
		return message;
	}

	manageDisablingSaveBtn(isChecked) {
		isChecked ? this.selectedRowsCounter++ : this.selectedRowsCounter--;
		_cl("Selected Rows Num: " + this.selectedRowsCounter, "cyan");

		this.isSaveBtnDisabled = !(this.selectedRowsCounter > 0);
	}

	handleSelectProductRow(event) { //TODO name to value
		const isChecked = event.target.checked;
		this.manageDisablingSaveBtn(isChecked);

		const index = event.target.name - 1;
		this.productsList[index].checked = isChecked;

		_cl(JSON.stringify(this.productsList[index]), "gold");
	}

	handleSetQuantityRow(event) {
		const index = event.target.name - 1;
		this.productsList[index].quantity = event.detail.value;

		_cl(JSON.stringify(this.productsList[index]), "gold");
	}


	handleSave() {
		this.validateDataToSave();

		let productsData = [];
		this.productsList.forEach((p) => {
			if (p.checked === true) {
				productsData.push({
					Equipment__c: p.Id,
					Quantity__c: _isInvalid(p.quantity) ? 1 : p.quantity
				});
			}
		});

		if (this.newProposalName.trim() === '') { // TODO move to validate method
			_message('warning', null, 'Proposal Name is missing or incorrect.');
			return;
		}

		this.proposalWithProductsDataToSave.proposalData = [{Opportunity__c: this.oppId, Name: this.newProposalName, Status__c: 'Draft'}]; //TODO Add validation on Name
		this.proposalWithProductsDataToSave.productsData = productsData;

		this.saveNewProposalWithProducts();

		_cl("Data to Save: " + JSON.stringify(this.proposalWithProductsDataToSave), "coral");
	}

	validateDataToSave() {

	}

	// --> SERVER METHODS

	getCategories() {
		try {
			getCategoriesServer()
				.then(result => {
					if (_isInvalid(result)) {
						_message('info', 'The list of Categories is empty', 'No Records');
						return null;
					}
					_cl(" Result: " + JSON.stringify(result));
					this.setCategoriesOptions(result);
				})
				.catch(e => _parseServerError('getCategories callback Error: ', e));
		} catch{(e => _parseServerError('Get Categories Error : ', e));
		}
	}

	handleSearchProducts() {
		const params = this.productsSearchFilter();
		if (_isInvalid(params)) return;

		try {
			getProductsServer({params: params})
				.then(result => {
					if (_isInvalid(result)) {
						_message('info', 'The list of Products is empty', 'No Records');
						return null;
					}
					this.productsList = _numberedList(result);
					this.isProductsTableReadyToRender = true;
					_cl("Products Result: " + JSON.stringify(this.productsList));
				})
				.catch(e => _parseServerError('getProductsServer callback error : ', e));
		} catch (e) {
			_parseServerError('getProductsServer callback error : ', e);
		}
	}

	saveNewProposalWithProducts() {
		const params = this.proposalWithProductsDataToSave;
		try {
			setProposalWithProductsServer({params: params})
				.then(() => {
					_message('success', '', 'Saved');
					this.dispatchEvent(new CustomEvent('refreshproposalslist', {detail: true}));
					this.dispatchEvent(new CustomEvent('closecreationmodalwindow', {detail: false}));
				})
				.catch(e => {
					_parseServerError('saveNewProposalWithProducts callback error: ', e);
				});
		} catch (e) {
			_parseServerError('saveNewProposalWithProducts error: ', e);
		}
	}

	// --< SERVER METHODS
}
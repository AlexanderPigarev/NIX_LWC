import {api, LightningElement, track} from "lwc";
import {_cl, _isInvalid, _message, _numberedList, _parseServerError} from 'c/utils';

import getProposalsServer from "@salesforce/apex/ProposalsController.getProposalsServer";
import deleteSinglePropServer from "@salesforce/apex/ProposalsController.deleteSinglePropServer";

export default class ProposalsList extends LightningElement {
	@api recordId;
	@api proposalId;

	@track filteredProposals = [];
	@track isCreationPageDisplaying = false;
	@track isPDFModalDisplaying = false;

	connectedCallback() {
		this.doInit();
	}

	doInit() {
		document.title = 'Proposals';
		this.getFilteredProposals();
	}

	handleDisplayCreationModalWindow() {
		this.isCreationPageDisplaying = true;
	}

	handleCloseCreationModalWindow(event) {
		this.isCreationPageDisplaying = event.detail;
	}

	handleCloseProposalPDFModalWindow(event) {
		this.isPDFModalDisplaying = event.detail;
	}

	refreshProposalsList() {
		_message('info', null, 'The list of Proposals refreshed.');
		this.doInit();
	}

	setRedirectLink(propList) { //TODO think about to move to the numberedLst method
		propList.forEach((p) => {
			p.link = '/' + p.Id;
		});
		return propList;
	}

	openPDFModal(event) {
		this.proposalId = event.target.value;
		this.isPDFModalDisplaying = true;
	}


	// --> SERVER METHODS
	getFilteredProposals() {
		_cl("Current Opportunity Id: " + this.recordId, 'orange');

		try {
			getProposalsServer({oppId: this.recordId})
				.then(result => {
					if (_isInvalid(result)) {
						_message('info', 'The list of Proposals is empty', 'No Records');
						return null;
					}
					this.filteredProposals = this.setRedirectLink(_numberedList(result));
					// _cl("From Server: " + JSON.stringify(this.filteredProposals), "cyan");

				})
				.catch(e => _parseServerError('getFilteredProposals callback Error: ', e));
		} catch (e) {
			_parseServerError('getFilteredProposals Error: ', e);
		}
	}

	deleteSingleProp(event) {
		if (!confirm('Are you sure you want to delete this record?')) return null;
		const currentPropId = event.target.value

		_cl("Delete -> Prop Id: " + currentPropId, "red");

		deleteSinglePropServer({propId: currentPropId})
			.then(() => {
				_message('success', 'Deleted', null);
				this.refreshProposalsList();
			})
			.catch(e => _parseServerError('Delete Proposal Error: ', e));
	}

	// --< SERVER METHODS

}
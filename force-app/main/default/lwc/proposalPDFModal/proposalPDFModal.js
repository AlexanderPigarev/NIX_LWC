import {LightningElement, api, track} from 'lwc';
import {_cl, _message, _isInvalid, _parseServerError} from 'c/utils';

import downloadPDFPropServer from "@salesforce/apex/ProposalPreviewPDFController.generateProposalPDF";
import sendSingleEmailServer from "@salesforce/apex/ProposalPreviewPDFController.sendSingleEmail";

export default class ProposalPDFModal extends LightningElement {
	@api proposalId;

	@track isContentReadyToRender = false;

	downloadLink = '/sfc/servlet.shepherd/document/download/';
	link = '/apex/ProposalRenderPDF?id=';
	fileId = '';
	isFileInserted = false;

	connectedCallback() {
		this.doInit();
	}

	doInit() {
		document.title = 'Proposal PDF Template';
		this.link += this.proposalId;
		this.isContentReadyToRender = true;

		_cl('Link: ' + this.link);
	}

	closeModalWindow() {
		this.dispatchEvent(new CustomEvent('closeproposalpdfmodalwindow', {detail: false}));
	}

	preparedEmailData() { //TODO Pop up window for email setup

		return {
			'recipients': ['shushikatom@gmail.com'],
			'ccRecipients': null,
			'bccRecipients': null,
			'subject': ['Proposal for Agreement'],
			'body': ['Please acquaint yourself with our proposal, which you can find in the attached file, there you will also find contacts for feedback.'],
			'filesIds': [this.fileId]
		}
	}

	handleDownloadPDFDoc() {
		if (!this.isFileInserted) {
			this.insertPDFFile('download');
		} else {
			window.open(this.downloadLink, '_self');
		}
	}

	insertPDFFile(action) {
		_cl("storePDFToServer starts -> Prop Id: " + this.proposalId, "red");

		downloadPDFPropServer({proposalId: this.proposalId})
			.then(result => {
				if (_isInvalid(result)) {
					_message('info', 'Could not get download PDF file.', '');
					return null;
				}
				_cl("PDF Result: " + JSON.stringify(result), "orange");

				this.downloadLink += result.contentDocId;
				this.fileId = result.cvId;
				this.isFileInserted = true;

				if (action === 'download') this.handleDownloadPDFDoc();
				if (action === 'send') this.handleSendEmail();
			})
			.catch(e => _parseServerError('Preview PDF Proposal Error!', e));
	}


	handleSendEmail() {
		if (!this.isFileInserted) {
			this.insertPDFFile('send');
		} else {
			if (!confirm('Are you sure you want to send the current PDF Template via Email?')) return null;
			_cl("Send Email -> Prop Id: " + this.proposalId, "green");
			sendSingleEmailServer({params: this.preparedEmailData()})
				.then(result => {
					if (_isInvalid(result)) {
						_message('info', 'Could not send email, please check the data you try to send.', '');
						return null;
					}
					_message('success', 'Email sent successfully.', '');
				})
				.catch(e => _parseServerError('Send Email Error!: ', e));
		}
	}
}
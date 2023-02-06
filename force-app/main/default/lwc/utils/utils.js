import {ShowToastEvent} from "lightning/platformShowToastEvent";


/**
 * Salesforce alert
 * @param type = error || warning || success || info
 * @param message = "BLM : Some Error"
 * @param title = "Toast Header" (not mandatory)
 * EXAMPLE:    _message('error', `Reporting : Generate Report Lines Error: ${e}`, 'Error');
 */
const _message = (type, message, title) => {
	try {
		dispatchEvent(new ShowToastEvent({
			title: type === 'error' ? `Error` : (title ? title : `Note`),
			message: message,
			variant: type,
			mode: type === 'error' ? 'sticky' : 'dismissible'
		}));
	} catch (e) {
		alert('Message Error : ' + e);
	}
};

/**
 * Method to put comments in a browser console
 * @param  message console log text
 * @param  color console log color
 */
const _cl = (message, color) => {
	try {
		message = typeof message === `object` ? message.toString() : message;
		console.log(
			`%c🌩️ ${message}`,
			`color:${color}; font: 1 Tahoma; font-size: 1.2em; font-weight: bolder; padding: 2px;`
		);
	} catch (e) {
		console.error(e);
	}
};

const _isInvalid = (t) => {
	return (t === undefined || !t || t === 'undefined');
};

const _numberedList = (list) => {
	list.forEach((item, index) => {
		item.idx = index + 1;
	});
	return list;
};

const _parseServerError = (reason, error) => {
	console.log("Console log: " + JSON.stringify(error));
	let styleCSS = document.createElement("style");
	styleCSS.type = "text/css";
	styleCSS.innerHTML = " .toastMessage.forceActionsText{white-space : pre-line !important;}", "";
	document.getElementsByTagName("head")[0].appendChild(styleCSS);
	try {
		const event = new ShowToastEvent({
			title: reason ? reason : "Unknown",
			message: error.body ? "Status: " + error.status + "\nMessage: " + error?.body.message + "\nStack: " + error?.body.stackTrace : 'Unknown',
			variant: "error",
			mode: "sticky"
		});
		dispatchEvent(event);
	} catch (e) {
		alert('Parse Server Error : ' + e);
	}
};

export {
	_cl,
	_message,
	_isInvalid,
	_parseServerError,
	_numberedList,
};
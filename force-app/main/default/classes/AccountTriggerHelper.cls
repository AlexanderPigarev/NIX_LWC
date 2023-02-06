/**
 * @author Olexander Piharev
 * @version 1.0
 * @since 2023-01-05
*/
public with sharing class AccountTriggerHelper {

	/** method set Shipping address data from Billing address data while insert new Account
	 * @param a -  newly created Account
	 */
	public static void setShippingAddress(Account a) {
		a.ShippingCity = a.BillingCity;
		a.ShippingCountryCode = a.BillingCountryCode;
		a.ShippingStateCode = a.BillingStateCode;
		a.ShippingState = a.BillingState;
		a.ShippingStreet = a.BillingStreet;
		a.ShippingPostalCode = a.BillingPostalCode;
	}
}
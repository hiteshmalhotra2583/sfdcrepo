@isTest
private class SmartFactoryTest {

	static {
	        SmartFactory.FillAllFields = true; // increase test coverage without creating custom objects
	    }  

	static testMethod void createsObjectWithoutCascadeDoesNotSetLookupField() {
	    Contact contact = (Contact)SmartFactory.createSObject('Contact', false);
	    insert contact;
	    System.assert(contact.AccountId == null);
	}

	static testMethod void createObjectWithUnsupportedTypeThrowsException() {
	    try {
	        SmartFactory.createSObject('Unsupported');
	        System.assert(false);
	    } catch (SmartFactory.UnsupportedObjectTypeException ex) {
	        System.assert(true);
	    }
	}

}
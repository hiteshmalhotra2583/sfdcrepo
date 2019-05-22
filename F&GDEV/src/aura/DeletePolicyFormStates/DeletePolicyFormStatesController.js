({
	doInit : function(component, event, helper) {
	    //call to server fetch the list to be deleted
	    helper.fetchPolicyFormStates(component,event);
	},
	handleSubmit : function(component, event, helper) {
	    //console.log('--Enter submit--');
	    helper.submitForm(component,event);
	},
	handleCancel : function(component, event, helper) {
	    $A.get("e.force:closeQuickAction").fire();
	},
    onRowSelect : function(component, event, helper) {
        //console.log('--Entering selected rows--');
        var selectedRows = event.getParam('selectedRows');
        component.set('v.selectedStateList', selectedRows);
        //console.log('--selected rows--', JSON.stringify(selectedRows));
    }
})
({
	doInit : function(component, event, helper) {
	    console.log('--intializing component--');
		helper.fetchPickListVal(component,'method','Policy_Form_Detail__c','getState','stateList');
	},
	handleSubmit : function(component, event,helper) {
	    helper.submitForm(component,event);
	},
	handleCancel : function(component,event,helper) {
	    $A.get("e.force:closeQuickAction").fire();
	},
	selectAll : function(component,event,helper) {
        helper.selectAllStates(component,event);
    }
})
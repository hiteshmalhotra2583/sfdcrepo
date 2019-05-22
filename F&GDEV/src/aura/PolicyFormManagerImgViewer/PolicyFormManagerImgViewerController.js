({
	doInit : function(component, event, helper) {
        let state = component.get('v.stateCode');
        let policyid = component.get('v.policyId');
        let statepolicymap = component.get('v.statepolicymap');
        helper.getClassStatus(component, event,state,policyid,statepolicymap);
        helper.getStatusMessage(component, event,state,policyid,statepolicymap);
    },
    displayToolTip : function(component, event, helper) {
       component.set('v.tooltipStatus',true);
    },
    hideToolTip : function(component, event, helper) {
        component.set('v.tooltipStatus',false);
    }
})
({
	doInit : function(component, event, helper) {
        var prodid = component.get('v.productId');
        var state = component.get('v.stateCode');
        var policyid = component.get('v.policyId');
        let prodstatepolicystatestatmap = component.get('v.prodstatepolicystatestatmap');
        helper.getProdStateStatus(component, event,prodid, state, policyid);
        helper.getStatusMessage(component, event,prodid,state,policyid,prodstatepolicystatestatmap);
	},
    displayToolTip : function(component, event, helper) {
       component.set('v.tooltipStatus',true);
    },
    hideToolTip : function(component, event, helper) {
        component.set('v.tooltipStatus',false);
    }

})
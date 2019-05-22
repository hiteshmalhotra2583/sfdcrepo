({
	doInit : function(component, event, helper) {
        helper.deleteMassRecords(component, event, helper);
    },
    sendBackToRecord : function(component, event, helper){       
        $A.get('e.force:refreshView').fire();
            var recordIdPar = component.get("v.recordId");
            var urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/"+recordIdPar
            });
            urlEvent.fire();         
	},

})
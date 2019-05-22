({
	showToast : function(title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    navToRecord : function(recordId,slideName) {
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": recordId,
            "slideDevName": slideName
        });
        navEvt.fire();
    },
    closeQuickAction : function(component) {
        $A.get("e.force:closeQuickAction").fire();
    }
})
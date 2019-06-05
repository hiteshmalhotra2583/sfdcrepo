({
	
    handleClone : function(component,event,helper) {
        helper.callToServer(component,event);
    },
    handleCancel : function(component,event,helper) {
          helper.closeQuickAction(component);
    }
})
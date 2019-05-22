({
	deleteMassRecords : function(component, event,helper) {
		var recordId = component.get('v.recordId');   
        var action = component.get("c.deleteProductStateRecords");
        action.setParams({
            "parentId": recordId
        });
        component.set("v.spinner",true);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
            	component.set("v.responseMessage", response.getReturnValue());  
                var navigate = $A.get("e.force:navigateToSObject");
                    navigate.setParams({
                        "parentId" : component.get('v.recordId')
                });
            } else if (state === "ERROR") {
                component.set("v.responseMessage", response.getReturnValue());
            }
            component.set("v.spinner",false);
        });
        $A.enqueueAction(action); 
    },
})
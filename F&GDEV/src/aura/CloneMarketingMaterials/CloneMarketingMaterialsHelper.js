({
    callToServer : function(component,event) {
        var recordId = component.get("v.recordId");
        console.log('--recordId--'+recordId);
        var marketingMaterialNewName = component.get("v.newMarketingMaterialName");
        var action = component.get("c.cloneMarketingMaterials");
        action.setParams({
            "marketingMaterialId":recordId,
            "marketingMaterialNewName": marketingMaterialNewName
        });
        action.setCallback(this, function(response){
            if (response.getState() == "SUCCESS"){

                var message = response.getReturnValue();
                console.log("--message--"+message);
                console.log("indexof"+message.indexOf("a0d"));
                if(message.indexOf("a0d")!=-1) {
                   this.navToRecord(message, "detail");
                    this.closeQuickAction(component);
                }else {
                    this.showToast("Error occurred!!","Unable to clone Marketing Materials", "error");
                    this.closeQuickAction(component);
                }
            } else{
                this.showToast("Error occurred!!","Unable to clone Marketing Materials", "error");
                this.closeQuickAction(component);
            }
        });
        $A.enqueueAction(action);
    },
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
    },
    getMarketingMaterialName : function(component,event)
    {
        var marketingMaterialId = component.get("v.recordId");
        var action = component.get("c.getMarketingMaterialName");
        action.setParams({
            "marketingMaterialId":marketingMaterialId
        });
        action.setCallback(this, function(response) {
            if(response.getState()== "SUCCESS") {
                var marketingMaterialForm = response.getReturnValue();
                component.set("v.newMarketingMaterialName",marketingMaterialForm.Name);
                component.set("v.existingMarketingMaterialName", marketingMaterialForm.Name);
            }
        });
        $A.enqueueAction(action);
    },
})
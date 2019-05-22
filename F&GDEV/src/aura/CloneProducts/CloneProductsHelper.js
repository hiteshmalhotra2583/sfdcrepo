({
    callToServer : function(component,event) {
        var recordId = component.get("v.recordId");
        console.log('--recordId--'+recordId);
        var productNewName = component.get("v.newProductName");
        var action = component.get("c.cloneWithProducts");
        action.setParams({
            "productId":recordId,
            "productNewName": productNewName
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
                    this.showToast("Error occurred!!","Unable to clone products", "error");
                    this.closeQuickAction(component);
                }
            } else{
                this.showToast("Error occurred!!","Unable to clone products", "error");
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
    getProductName : function(component,event)
    {
        var productId = component.get("v.recordId");
        var action = component.get("c.getProductName");
        action.setParams({
            "productId":productId
        });
        action.setCallback(this, function(response) {
            if(response.getState()== "SUCCESS") {
                var productForm = response.getReturnValue();
                component.set("v.newProductName",productForm.Name);
                component.set("v.existingProductName", productForm.Name);
            }
        });
        $A.enqueueAction(action);
    },
})
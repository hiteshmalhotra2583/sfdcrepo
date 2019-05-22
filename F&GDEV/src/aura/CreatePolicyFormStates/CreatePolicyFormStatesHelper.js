({
	    fetchPickListVal: function(component, getFrom,objectName,methodOrFieldName,elementId){
        var parentRecordId  = component.get("v.recordId");
        var action = component.get("c.getselectOptions");
        action.setParams({
            "getFrom":getFrom,
            "objectName": objectName,
            "methodOrFieldName": methodOrFieldName,
            "parentRecordId": parentRecordId
        });
        
        var opts = [];
        action.setCallback(this, function(response){
            //console.log("response:",response.getState());
            if (response.getState() == "SUCCESS"){
                var allValues = response.getReturnValue();
                function compare(a, b){
                  if (a > b) return 1;
                  if (b > a) return -1;
                
                  return 0;
                }
                console.log(JSON.stringify(allValues));
                allValues.sort(compare);
                //console.log("values:",response.getReturnValue());
                if (allValues != undefined ){
                    for(var k in allValues){ 
                        opts.push({
                            class: "optionClass",
                            label: allValues[k],
                            value: allValues[k]
                        });
                     };
                }
                component.find(elementId).set("v.options", opts); 
                component.set("v.lstStatesAll",opts);
            }
        });
        $A.enqueueAction(action);
    },
    submitForm : function(component, event) {
        var parentRecordId  = component.get("v.recordId");
        var selectedStateList = component.get("v.selectedStateList");
        var action = component.get("c.createChildPolicyStates");
        console.log('selectedStateList'+selectedStateList);
        action.setParams({
            "policyFormId" : parentRecordId,
            "selectedStates" : selectedStateList
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var message = response.getReturnValue();
                if(message==='State records created') {
                    console.log('--Success--'); 
                    this.showToast("SUCCESS!!", "Policy form State records created","success");
                    $A.get("e.force:closeQuickAction").fire();
                } else{
                    this.showToast("Error Occurred!!", message,"error");
                }
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
    selectAllStates : function(component,event) {
        var checkBoxValue = event.getSource().get("v.value");
        console.log('--checkboxvalue--'+checkBoxValue);
        var lstAllStates = component.get("v.lstStatesAll");
        console.log('--lstAllsTates--'+lstAllStates);
        if(checkBoxValue===true) {
            var lstStateSubset = [];
            for(var k in lstAllStates) {
                lstStateSubset.push(lstAllStates[k].value);
            }
            component.find("stateList").set("v.value", lstStateSubset);
        } else {
            component.find("stateList").set("v.value", []);
        }
    }
})
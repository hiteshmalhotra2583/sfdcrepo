({
    fetchPolicyFormStates : function(component,event) {
    //set columns
    component.set('v.tableColumns', [
            {label: 'State Name', fieldName: 'Name', type: 'text'},
            ]);
    var recordId = component.get('v.recordId');
    var action = component.get('c.getDeleteablePolicyStates');
    action.setParams({
    	"parentRecordId": recordId
	});
	        action.setCallback(this, function(response){
            //console.log("response:",response.getState());
            //console.log('entering response');
            if (response.getState() == "SUCCESS") {
                var stateValues = response.getReturnValue();
        		//console.log('--entering response--'+stateValues);
                if(stateValues && stateValues.length>0) {
        			//console.log('--entering response--'+stateValues);
                	component.set("v.deletablePolicyStateList", stateValues);    
                }
                
            }
        component.set("v.isLoading",false);
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
    $A.get("e.force:closeQuickAction").fire();
    },
    submitForm : function(component, event) {
        var stateList = component.get('v.selectedStateList');
        var action = component.get('c.deleteSelectedStateRecord');
        action.setParams({
            "selectedStates" : stateList
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var message = response.getReturnValue();
                //console.log('--message--'+message);
                if(message.indexOf("Successful") !=-1) {
                    this.showToast('Success!!', message,'Success');
                }
                else {
                    this.showToast('Error!!', message,'Error');
                }
            }
        });
        $A.enqueueAction(action);
    }
})
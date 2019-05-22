({
    getStates : function(component,event,elementId) 
    {
        //call to server and fetch related states
        var opts = [];
        var recordId = component.get("v.recordId");
        var action = component.get("c.getPolicyFormStates");
        action.setParams({
            "policyFormId":recordId
        });
        action.setCallback(this, function(response) {
            if(response.getState()== "SUCCESS") {
                var allValues = response.getReturnValue();
                function compare(a, b){
                    if (a.Name > b.Name) return 1;
                    if (b.Name > a.Name) return -1;
                    
                    return 0;
                }
                //console.log(JSON.stringify(allValues));
                allValues.sort(compare);
                //console.log('-allvalues-'+allValues);
                //console.log("values:",response.getReturnValue());
                if (allValues != undefined ){
                    for(var k in allValues){ 
                        opts.push({
                            label: allValues[k].Name,
                            value: allValues[k].Id
                        });
                    };
                }
                component.find(elementId).set("v.options",opts);
                //console.log('--get options--');
                //console.log(component.find(elementId).get("v.options"));
                component.set("v.policyFormStates",opts);
            }
        });
        $A.enqueueAction(action);
    },
    saveHelper : function(component, event,helper)
    {
        component.set("v.showSpinner",true);
		var policyFormStateId = component.get("v.stateSelect");
		var newPolicyFormName = component.get("v.newPolicyFormName");
		var recordId = component.get("v.recordId");
		var action = component.get("c.clonePolicyFormWithChild");
        action.setParams({
            "recordId" : recordId,
            "newPolicyFormName" : newPolicyFormName,
            "policyFormStateId" : policyFormStateId
        });        
        action.setCallback(this, function(response) {
            if(response.getState()=="SUCCESS") 
            {
                var message = response.getReturnValue();
                console.log("message"+message);
                if(message && message.length===18)
                {
                    var cloneSuccessMsg = $A.get("$Label.c.Clone_Policy_Form_Success");
                    helper.showToast("Success",cloneSuccessMsg ,"success");
                    helper.navToRecord(message,"detail");
                    helper.closeQuickAction();                 

                } else
                    //error occurred
                {
                    helper.showToast("Error",message,"error");
                    helper.closeQuickAction();
                }
            }
            component.set("v.showSpinner",false);
        });
        $A.enqueueAction(action);
    },
    getPolicyForm : function(component,event)
    {
        var policyFormId = component.get("v.recordId");
        var action = component.get("c.getPolicyForm");
        action.setParams({
            "policyFormId":policyFormId
        });
        action.setCallback(this, function(response) {
            if(response.getState()== "SUCCESS") {
                var policyForm = response.getReturnValue();
                component.set("v.newPolicyFormName",policyForm.Name);
                component.set("v.existingPolicyFormName",policyForm.Name);
                
            }
        });
        $A.enqueueAction(action);
    }
})
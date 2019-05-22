({
    getStates : function(component,event) {
        var action = component.get("c.getStates");
        var opts = [];
        action.setCallback(this, function(response){
            console.log('--response states--'+response);
            if (response.getState() == "SUCCESS"){
                var allValues = response.getReturnValue();
                if (allValues != undefined ){
                    for(var k in allValues){ 
                        opts.push({
                            class: "optionClass",
                            label: allValues[k].StateCode__c,
                            value: allValues[k].StateCode__c
                        });
                    };
                }
                component.find("stateList").set("v.options", opts);
                component.set("v.lstStatesAll",opts);
            }
        });
        $A.enqueueAction(action);
        
    },
    submitHelper: function(component,event) {
        component.set("v.showSpinner","true");
        var action = component.get("c.createProductAssociations");
        var selectedProducts = component.get("v.lstSelectedProducts");
        var selectedForms = component.get("v.lstSelectedForms");
        var selectedStates = component.get("v.lstSelectedStates");
        action.setParams({
            "lstProducts": selectedProducts,
            "lstPolicyForms": selectedForms,
            "lstStates": selectedStates
        });
        action.setCallback(this, function(response){
            console.log('--response--');
            if (response.getState() == "SUCCESS") {
                var result = response.getReturnValue();
                console.log(JSON.stringify(result));
                component.set("v.resultString",result.lstSuccess);
                component.set("v.resultStringErrors",result.lstErrors);
                //this.resetPostSave(component,event);
            }
            component.set("v.showSpinner","false");
        });
        $A.enqueueAction(action);
    },
    initCols : function(component,event) {
        var cols = [
        {label: 'Result', fieldName: 'resultValue', type: 'text'}
        ];
        component.set("v.resultCols", cols);
        component.set('v.productCols', [
            {label: 'Name', fieldName: 'Name', type: 'text'}
        ]);
        component.set('v.formCols', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label:'IS Base?', fieldName: 'Base_Policy_Form__c' , type:'boolean', fixedWidth : 100}
        ]);
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
    },
    resetPostSave : function(component,event) {
        var prodSearchCmp = component.find("prodSearch");
        var policyFormSearchCmp = component.find("policyFormSearch");
        prodSearchCmp.resetSearch();
        policyFormSearchCmp.resetSearch();
        component.find("stateList").set("v.value", []);
        component.find("selectAll").set("v.value", "false");
        
    }
})
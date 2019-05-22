({
	doInit : function(component, event, helper) {
	    helper.initCols(component,event);
		helper.getStates(component,event);
	},
    handleSubmit : function(component, event, helper) {
        helper.submitHelper(component,event);
    },
    clearForm:function(component, event, helper) {
        helper.resetPostSave(component,event);
    },
    selectAll : function(component,event,helper) {
        helper.selectAllStates(component,event);
    },
    basePolicyFormSelection : function(component,event, helper) {
        var params = event.getParam("arguments");
        console.log('--newselectedRecords--'+JSON.stringify(params.newSelectedRecords));
        var selectedRows = params.newSelectedRecords;
        var source = component.get("v.lstSelectedForms");
        var basePolicyFormSelected = false;
        var basePolicyFormSelectedCounter = 0;
        var sourcePolicyFinalList = [];
        var setBaseListToPush = [];
        var basePolicyFormSelectedId = component.get("v.basePolicyFormSelectedId");
        console.log('basePolicyFormSelectedId'+basePolicyFormSelectedId);
        for( var policyForm in source )
        {
            if(source[policyForm] && source[policyForm].Base_Policy_Form__c)
            {
                basePolicyFormSelectedCounter++;
                if(basePolicyFormSelectedId && source[policyForm].Id!=basePolicyFormSelectedId) 
                {
                    setBaseListToPush.push(source[policyForm]);
                    continue;
                } 
                else if(basePolicyFormSelectedId === undefined || basePolicyFormSelectedId==='')
                {
                    component.set("v.basePolicyFormSelectedId",source[policyForm].Id);
                    basePolicyFormSelectedId = source[policyForm].Id;
                }
            }
            sourcePolicyFinalList.push(source[policyForm]);
            /*
            if(basePolicyFormSelected===true)
            {
                if(source[policyForm] && source[policyForm].Base_Policy_Form__c)
                {
                    //invalid selection show alert
                    //alert("You cannot select another base policy form state");
                    source.splice(counter,1);
                    console.log('--spliced source'+JSON.stringify(source));
                    //component.set("v.lstSelectedForms",source);
                    
                    basePolicyFormSelectedCounter++;
                    //return;
                }
            }
            if(basePolicyFormSelected===false && source[policyForm] && source[policyForm].Base_Policy_Form__c)
            {
                basePolicyFormSelected=true;
                basePolicyFormSelectedCounter++;
            }
            counter++;
            */
        }
        var policyFormSearchCmp = component.find("policyFormSearch");
        policyFormSearchCmp.setSelectedRecords(sourcePolicyFinalList,setBaseListToPush);
        //console.log('--basePolicyForm--'+JSON.stringify(sourcePolicyFinalList));
        if(basePolicyFormSelectedCounter>1)
        {
            alert("You cannot select more than one base policy form");
        }
        if(basePolicyFormSelectedCounter===0)
        {
            component.set("v.basePolicyFormSelectedId","");
        }
    },
    goBack : function(component,event,helper) {
        window.history.back();
    }
})
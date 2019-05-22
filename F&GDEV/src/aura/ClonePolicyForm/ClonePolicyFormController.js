({
	doInit : function(component, event, helper) 
    {
        helper.getPolicyForm(component,event);
		helper.getStates(component,event,"elecheckbox");
	},
    handleCheckBoxSelect : function(component, event, helper) 
    {
        var checkBoxValue = event.getSource().get("v.value");
        component.set("v.stateSelect",checkBoxValue);
    },
    handleClone : function(component, event, helper) 
    {
       component.set("v.isOpen", false);
       helper.saveHelper(component,event, helper); 
    },
    handleCancel : function(component, event, helper)
    {
        $A.get("e.force:closeQuickAction").fire();
    },
    validateNameChange : function(component,event,helper)
    {
        var policyFormName = event.getSource().get("v.value");
        var existingPolicyName = component.get("v.existingPolicyFormName");
        var inputComponent = component.find("formInput");
        if(policyFormName===existingPolicyName)
        {
            component.set("v.existingPolicyNameMatches",true);
             $A.util.addClass(inputComponent, 'cloneInput');    
            
        } else
        {
            component.set("v.existingPolicyNameMatches",false);
            $A.util.removeClass(inputComponent, 'cloneInput'); 
        }
    },
    openModal : function(component,event,helper)
    {
        component.set("v.isOpen", true);
    }
})
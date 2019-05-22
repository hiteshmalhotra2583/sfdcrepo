({
	doInit : function(component, event, helper) {
        var policystatusaggr = component.get('v.policystatusaggr');
        var field = component.get('v.field');
        var fieldName =  policystatusaggr.FieldLabelMap[field];
        var fieldValue =  policystatusaggr.FieldValueMap[field];
        var fieldType = policystatusaggr.FieldTypeMap[field];
        var fieldOptions = policystatusaggr.FieldPicklistMap[field];
        var isMultiValueMapFieldStatus = policystatusaggr.isMultiValueMap[field];
        var isEditableMapFieldStatus = policystatusaggr.isEditableMap[field];
       // console.log('fieldName : ',fieldName);
       // console.log('fieldValue :',fieldValue);
       // console.log('fieldType :',fieldType);
        component.set('v.fieldName',fieldName);
        component.set('v.fieldValue',fieldValue);
        component.set('v.fieldType',fieldType);
        component.set('v.fieldOptions',fieldOptions);
        component.set('v.isMultiValueMapFieldStatus',isMultiValueMapFieldStatus);
        component.set('v.isEditableMapFieldStatus',isEditableMapFieldStatus);
	},
    override : function(component, event, helper) {
        var fieldClass = event.currentTarget.dataset.value;
        var array = fieldClass.split('-');
        var field = array[1]!=undefined?array[1]:'';
        console.log('field ',field);
        if(field!=undefined && field!=''){
            var policystatusaggr = component.get('v.policystatusaggr');
            var message = 'The associated field has multiple values present.  Editing the field will cause all associated records to be overwritten.  Click OK to continue.';
            //  var evalUndo = policystatusaggr.isEditableMap[field] && policystatusaggr.isEditedMap[field];
            var enabled = true;
            
            if(policystatusaggr.isEditableMap[field]){
                message = 'Click cancel to undo current field changes.  Click ok to continue editing.';
            }
            
            enabled = confirm(message);
            
            //  Enable/Disable Field Based on User Selection
            policystatusaggr.isEditableMap[field] = enabled;
            
            //  Reverse Editable and Edited Values If Successfully Disabled
            if(policystatusaggr.isEditedMap[field] && !enabled){
                policystatusaggr.FieldValueMap[field] = policystatusaggr.FieldOrigValueMap[field];
                policystatusaggr.isEditedMap[field] = false;
               
            }
             component.set('v.isEditableMapFieldStatus',policystatusaggr.isEditableMap[field]);
            
            
        }
    },
    updatePolicyStatus:function(component, event, helper) {
        var field = component.get('v.field');
        var policystatusaggr = component.get('v.policystatusaggr');
        policystatusaggr.FieldValueMap[field] = component.get('v.fieldValue');
        policystatusaggr.isEditedMap[field]  = true;
        console.log(component.get('v.fieldValue'));
        
    }
})
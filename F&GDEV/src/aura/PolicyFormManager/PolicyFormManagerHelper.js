({
    filterSectionHelper : function(component,event,secId) {
	  var acc = component.find(secId);
        	for(var cmp in acc) {
        	$A.util.toggleClass(acc[cmp], 'slds-show');  
        	$A.util.toggleClass(acc[cmp], 'slds-hide');  
       }
	},
    getPolicyFormStateHelper:function(component,event) {
        var action = component.get("c.getPolicyFormState");
        action.setCallback(component, function(response){
            var state = response.getState();
            var errorMsg='',warningMsg='',successMsg='';
            if (state == "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.policyFormStateList",result); 
            }else if (state === "INCOMPLETE") {
                errorMsg = response.getReturnValue();
                self.toastMessage(component, event,"Error!","error",errorMsg);
            } else if (state === "ERROR") {
                var errors = response.getError();
                errorMsg='';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                        self.toastMessage(component, event,"Error!","error",errorMsg);
                    }
                } else {
                    errorMsg = "Unknown error!";
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                }
            }
        });
        $A.enqueueAction(action);
    },
     getPolicyFormTypeHelper:function(component,event) {
        var action = component.get("c.getPolicyFormType");
        action.setCallback(component, function(response){
            var state = response.getState();
            var errorMsg='',warningMsg='',successMsg='';
            if (state == "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.policyFormTypeList",result); 
            }else if (state === "INCOMPLETE") {
                errorMsg = response.getReturnValue();
                self.toastMessage(component, event,"Error!","error",errorMsg);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errorMsg='';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                        self.toastMessage(component, event,"Error!","error",errorMsg);
                    }
                } else {
                    errorMsg = "Unknown error!";
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                }
            }
        });
        $A.enqueueAction(action);
    },
	doInitHelper : function(component,event,policyFormStateVal) {
        var self = this;
        var pageReference = component.get("v.pageReference");
        component.set("v.recordId", pageReference.state.Id);
        component.set('v.Spinner',true);
        var self=this;
        var action = component.get("c.getPolicyDetails");
        action.setParams({
            "projectId":component.get("v.recordId"),
            "policyFormStateVal":policyFormStateVal
        });
        
        var opts = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log("response:",response.getState());
            if (state == "SUCCESS"){
                var result = response.getReturnValue();
                if(result==null){
                    return;
                }
                result=JSON.parse(result);
               // console.log('result :',result);
                if(result.states!=null && result.PolicyReturns!=null){
                    component.set("v.states", result.states);
                    if(result.ProductReturns!=null ){
                        component.set("v.project", result.ProductReturns.oProject);  
                        component.set("v.products", result.ProductReturns.oProducts);  
                        component.set("v.prodstatepolicystatestatmap", result.ProductReturns.oProdStatePolicyStateStatMap);  
                        component.set("v.policyidlist", result.ProductReturns.oPolicyIdSet);  
                    }
                    component.set("v.statepolicymap", result.PolicyReturns.oStatePolicyMap);
                    component.set("v.policies", result.PolicyReturns.oPolicyList); 
                    component.set("v.policiesCopy", result.PolicyReturns.oPolicyList); 
                    component.set("v.policyUpdateAccess", result.PolicyReturns.bPolicyUpdateAccess); 
                    
                    component.set("v.statepolicyselectcount", 0); 
                    component.set("v.refPolicies", []); 
                    if(result.PolicyReturns.oPolicyList.length<=0){
                        self.toastMessage(component, event,"Warning!","warning",'No Policy Records Found !');
                    }
                    var products=[];
                    var policies=[];
                    if(result.ProductReturns!=null){
                         products=result.ProductReturns.oProducts;
                    }
                    if(result.PolicyReturns!=null){
                         policies=result.PolicyReturns.oPolicyList;
                    }
                    self.doInitSubHelper(component,event,products,policies);
                    /*==== states multi dropdown ====*/
                    var states = component.get("v.states");
                    //===== Paggination Logic =====
                    var options = [];
                    for(var i=0; i< states.length; i++){
                        options.push({value: states[i].Name, label: states[i].Name});    
                    }
                    component.set('v.options',options);
                    component.set('v.Spinner',false);
                }    
            }else if (state === "INCOMPLETE") {
                var errorMsg = response.getReturnValue();
                self.toastMessage(component, event,"Error!","error",errorMsg);
                component.set('v.Spinner',false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errorMsg='';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                        self.toastMessage(component, event,"Error!","error",errorMsg);
                    }
                    component.set('v.Spinner',false);
                } else {
                    errorMsg = "Unknown Error!";
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                    component.set('v.Spinner',false);
                }
            }
        });
        $A.enqueueAction(action);
	},
    doInitSubHelper: function (component, event,products,policies){
        /*var productpolicies = []; 
        if(products.length>0){
            for(var i=0;i<products.length;i++){
                for(var j=0;j<policies.length;j++){
                    //Add PolicyFormType field in obj for display records Policy_Form_Type__c from Product_Detail__c obj.
                    productpolicies.push({ProductId:products[i].Id, PolicyId: policies[j].Id, PolicyName: policies[j].Name,PolicyFormType:policies[j].PolicyFormType});
                }
            } 
        }	
        component.set("v.productpolicies", productpolicies); */
        //===== Paggination Logic =====
        var pageSize = component.get("v.pageSize");
        var states = component.get("v.states");
        component.set("v.totalSize", states.length);
        component.set("v.start",0);
        component.set("v.end",pageSize-1);
        var begin = component.get('v.start');
        var end = component.get('v.end');
        var statess = [];
        for(var i=0; i< pageSize; i++)
        {
            statess.push(states[i]);    
        }
        component.set("v.statess", statess);
        //console.log('statess ',JSON.stringify(statess));
        //===== Paggination Logic =====
        
    },
    handleChangeHelper: function (component, event) {
        var self = this;
        var selectedOptionValue = component.get('v.selectedOptionsList');
        //console.log(selectedOptionValue);
        var pageSize = component.get("v.pageSize");
        var states = [];
        if(selectedOptionValue.length<=0){
            states = component.get("v.states");
        }else{
            var states2 = component.get("v.states");
            for(var i=0;i<states2.length;i++){
                for(var j=0;j<selectedOptionValue.length;j++){
                    if(states2[i].Name==selectedOptionValue[j]){
                        states.push(states2[i]);
                    } 
                }
            }
        }
        component.set("v.totalSize", states.length);
        component.set("v.start",0);
        component.set("v.end",pageSize-1);
        var begin = component.get('v.start');
        var end = component.get('v.end');
        var statess = [];
        for(var i=0; i< pageSize; i++){
            statess.push(states[i]);    
        }
        component.set("v.statess", statess);  
        
    },
    policyFormStateChangeHelper:function(component,event){
        var self = this;
        var policyFormStateVal = component.get('v.policyFormStateVal');
        if(policyFormStateVal =='' || policyFormStateVal==null){
            policyFormStateVal = '';
            component.set('v.policies',component.get('v.policiesCopy'));
        }else{
            var policies2 = component.get("v.policiesCopy");
            var policies = [];
            for(var i=0;i<policies2.length;i++){
                if(policies2[i].PolicyFormStatus == policyFormStateVal){
                    policies.push(policies2[i]);
                } 
            }
            if(policies.length<=0){
                self.toastMessage(component, event,"Warning!","warning",'No Policy Records Found !');
            }
            component.set('v.policies',policies);
        }
       // helper.doInitHelper(component,event,policyFormStateVal);
    },
    searchPolicyHelper:function(component,event){
        var self = this;
        var sPolicyName = component.find('searchPolicyName').get('v.value'); 
       // console.log('sPolicyName ',sPolicyName);
        var action = component.get("c.searchPolicies");
        action.setParams({
            "sPolicyName" : sPolicyName
        });
        action.setCallback(component, function(response){
            var state = response.getState();
            var errorMsg='',warningMsg='';
            if (state == "SUCCESS"){
                var result = response.getReturnValue();
                if(!result.bIsError && result.sMessage!=null){
                    var policyDetails = result.oPolicySearchResults;
                    if(policyDetails.length>0){
                       // console.log('policyDetails ',policyDetails);
                        var cols = [
                            {label: 'Policy Name', fieldName: 'Name', type: 'text'}
                        ];
                        component.set('v.serPolicyColumns', cols);
                        component.set("v.serPolicyData", policyDetails);
                    }else{
                        warningMsg = 'No such policy found!Try again!';
                        self.toastMessage(component, event,"Warning!","warning",warningMsg); 
                    }
                }else{
                    errorMsg = result.sMessage;
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                    component.set('v.isPolicyAddStatus',false);
                }
            }else if (state === "INCOMPLETE") {
                errorMsg = response.getReturnValue();
                self.toastMessage(component, event,"Error!","error",errorMsg);
                component.set('v.isPolicyAddStatus',false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errorMsg='';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                        self.toastMessage(component, event,"Error!","error",errorMsg);
                    }
                    component.set('v.isPolicyAddStatus',false);
                } else {
                    errorMsg = "Unknown error!";
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                    component.set('v.isPolicyAddStatus',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    saveProjectPolicysHelper:function(component, event,projectId,selectedPolicyIds){
        var self = this; 
        var action = component.get("c.saveProjectPolicy");
        action.setParams({
            "ProjectId":projectId,
            "PolicyIdList" : selectedPolicyIds
        });
        action.setCallback(component, function(response){
            var state = response.getState();
            var errorMsg='',warningMsg='',successMsg='';
            if (state == "SUCCESS"){
                var result = response.getReturnValue();
                if(!result.bIsError){
                    successMsg = result.sMessage;
                    self.toastMessage(component, event,"Success!","success",successMsg);
                    component.set('v.isPolicyAddStatus',false);
                }else{
                    errorMsg = result.sMessage;
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                    component.set('v.isPolicyAddStatus',false);
                }
                $A.get('e.force:refreshView').fire();
            }else if (state === "INCOMPLETE") {
                errorMsg = response.getReturnValue();
                self.toastMessage(component, event,"Error!","error",errorMsg);
                component.set('v.isPolicyAddStatus',false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errorMsg='';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                        self.toastMessage(component, event,"Error!","error",errorMsg);
                    }
                    component.set('v.isPolicyAddStatus',false);
                } else {
                    errorMsg = "Unknown error!";
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                    component.set('v.isPolicyAddStatus',false);
                }
            }
        });
        $A.enqueueAction(action);
    },
    selectHelper:function(component, event,state, policyid, currSelectVal,statepolicymap,statepolicyselectcount){
        if(!(statepolicymap[state]!=undefined)){
            statepolicymap[state] = {};
        }
        
        if(!(statepolicymap[state][policyid]!=undefined)){
            statepolicymap[state][policyid]={Id:null, FilingStatusId:null, FilingStatusAvailId:null, Name:null, FormName:null, UISelected:false, FilingStatusObj:{}};
        }
        
        if(currSelectVal == undefined){
            currSelectVal = !statepolicymap[state][policyid].UISelected;
        }
        
        statepolicymap[state][policyid].UISelected = currSelectVal;
        
        //  Tally Selected Fields
        var isSelected = statepolicymap[state][policyid].UISelected;
        statepolicyselectcount += (isSelected ? 1 : -1);
        component.set('v.statepolicyselectcount',statepolicyselectcount);
       // console.log('statepolicymap[state][policyid] ',statepolicymap[state][policyid]);
       // console.log('statepolicyselectcount ',statepolicyselectcount);
    },
    editFilingStatusesHelper:function(component, event){
        var self = this; 
        component.set('v.Spinner',true);
        component.set('v.isEditFilings',true);
        var statepolicymap = component.get('v.statepolicymap');
        component.set('v.policystatusaggr',{});
       // console.log('JSON.stringify(statepolicymap) ',JSON.stringify(statepolicymap));
        //console.log('editFilingStatusesHelper statepolicymap ',statepolicymap);
        var action = component.get("c.getPolicyFormStateAggr");
        action.setParams({
            "statepolicymapstr":JSON.stringify(statepolicymap)
        });
        action.setCallback(component, function(response){
            var state = response.getState();
            var errorMsg='',warningMsg='',successMsg='';
            if (state == "SUCCESS"){
                var result = JSON.parse(response.getReturnValue());
                if(!result.bIsError){
                    var policystatusaggr = result.oPolicyFormStateAggr;
                    if(policystatusaggr!=null){
                        for(var i=0;i<policystatusaggr.Fields.length;i++){
                            var field = policystatusaggr.Fields[i];
                            if(policystatusaggr.FieldTypeMap[field] == 'DATE'){
                                var newDt = new Date(policystatusaggr.FieldValueMap[field]);
                                if(newDt instanceof Date && !isNaN(newDt.valueOf())){
                                    var dateStr = ('0' + newDt.getUTCDate());
                                    var monthStr = ('0' + (newDt.getUTCMonth()+1));
                                    dateStr = dateStr.substring(dateStr.length - 2, dateStr.length);
                                    monthStr = monthStr.substring(monthStr.length - 2, monthStr.length);
                                    var yearStr = newDt.getUTCFullYear();
                                    var fullDtStr = monthStr + dateStr + yearStr;
                                    //console.log('@@dateStr:' + dateStr);
                                    //console.log('@@monthStr:' + monthStr);
                                    //console.log('@@yearStr:' + yearStr);
                                    //console.log('@@fullDtStr: ' + fullDtStr);
                                    policystatusaggr.FieldValueMap[field] = fullDtStr;
                                }
                            }  
                        }
                        component.set('v.policystatusaggr',policystatusaggr);
                        //console.log('policystatusaggr :',policystatusaggr);
                    }
                }else{
                    errorMsg = result.sMessage;
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                    //component.set('v.isEditFilings',false);
                }
            }else if (state === "INCOMPLETE") {
                errorMsg = response.getReturnValue();
                self.toastMessage(component, event,"Error!","error",errorMsg);
               component.set('v.isEditFilings',false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errorMsg='';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                        self.toastMessage(component, event,"Error!","error",errorMsg);
                    }
                     component.set('v.isEditFilings',false);
                } else {
                    errorMsg = "Unknown error!";
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                    component.set('v.isEditFilings',false);
                }
            }
            component.set('v.Spinner',false);
        });
        $A.enqueueAction(action);
    },
    saveStatePolicyStatusHelper : function(component,event) {
        var self = this; 
		var policystatusaggr = component.get('v.policystatusaggr');
       // console.log('policystatusaggr ',JSON.stringify(policystatusaggr));
        var action = component.get("c.saveStatePolicyStatus");
        action.setParams({
            "policyformstateaggrstr":JSON.stringify(policystatusaggr)
        });
        action.setCallback(component, function(response){
            var state = response.getState();
            var errorMsg='',warningMsg='',successMsg='';
            if (state == "SUCCESS"){
                var result = JSON.parse(response.getReturnValue());
                if(!result.bIsError){
                    successMsg = result.sMessage;
                    self.toastMessage(component, event,"Success!","success",successMsg);
                    component.set('v.isEditFilings',true);
                }else{
                    errorMsg = result.sMessage;
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                    component.set('v.isEditFilings',true);
                }
                $A.get('e.force:refreshView').fire();
            }else if (state === "INCOMPLETE") {
                errorMsg = response.getReturnValue();
                self.toastMessage(component, event,"Error!","error",errorMsg);
                component.set('v.isEditFilings',false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                var errorMsg='';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                        self.toastMessage(component, event,"Error!","error",errorMsg);
                    }
                    component.set('v.isEditFilings',false);
                } else {
                    errorMsg = "Unknown error!";
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                    component.set('v.isEditFilings',false);
                }
            }
        });
        $A.enqueueAction(action);
	},
    toastMessage:function(component, event,title,status,msg){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type":status,
            "message": msg
        });
        toastEvent.fire();
    },
    applyCSStoSelectedRec:function(component){
        var statepolicymap = component.get('v.statepolicymap');
        setTimeout(function(){
            for(var state in statepolicymap){
                for(var policyid in statepolicymap[state]){
                    if(statepolicymap[state][policyid].UISelected){
                        if(document.getElementsByClassName(policyid+' '+state)!=undefined && document.getElementsByClassName(policyid+' '+state).length>0){
                            document.getElementsByClassName(policyid+' '+state)[0].style.backgroundColor='yellow';
                        }
                    }
                }
            }
        },200);
        

    },
})
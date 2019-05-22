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
        var pageReference = component.get("v.pageReference");
		component.set("v.recordId", pageReference.state.Id);
        component.set('v.Spinner',true);
        var self=this;
        var action = component.get("c.getDetails");
        action.setParams({
            "projectId":component.get("v.recordId"),
            "policyFormStateVal":policyFormStateVal
        });
        
        var opts = [];
        action.setCallback(this, function(response){
            var state = response.getState();
            //console.log("response:",response.getState());
            if (state== "SUCCESS"){
                var result = response.getReturnValue();
                if(result==null){
                    return;
                }
                result=JSON.parse(result);
                //console.log('result :',result);
                if(result.ProductReturns!=null && result.states!=null && result.PolicyReturns!=null){
                    
                    component.set("v.states", result.states);
                    component.set("v.project", result.ProductReturns.oProject);  
                    component.set("v.products", result.ProductReturns.oProducts);  
                    component.set("v.productsCopy", result.ProductReturns.oProducts);
                    component.set("v.prodstatepolicystatestatmap", result.ProductReturns.oProdStatePolicyStateStatMap);  
                    component.set("v.policyidlist", result.ProductReturns.oPolicyIdSet); 
                    component.set("v.statepolicymap", result.PolicyReturns.oStatePolicyMap);
                    component.set("v.policies", result.PolicyReturns.oPolicyList); 
                    component.set("v.policiesCopy", result.PolicyReturns.oPolicyList); 
                    component.set("v.policyUpdateAccess", result.PolicyReturns.bPolicyUpdateAccess);
                    component.set("v.prodstatepolicyeditcount", 0); 
                    component.set("v.refPolicies", []); 
                    component.set("v.refProducts", []); 
                    if(result.PolicyReturns.oPolicyList.length<=0){
                        self.toastMessage(component, event,"Warning!","warning",'No Policy Records Found !');
                    }
                    var products=result.ProductReturns.oProducts;
                    var policies=result.PolicyReturns.oPolicyList;
                    self.doInitSubHelper(component,event,products,policies);
                    /*==== states multi dropdown ====*/
                    var states = component.get("v.states");
                    var options = [];
                    for(var i=0; i< states.length; i++){
                        options.push({value: states[i].Name, label: states[i].Name});    
                    }
                    component.set('v.options',options);
                    component.set('v.Spinner',false);
                    /*==== states multi dropdown ====*/
                }
               
            }else if (state === "INCOMPLETE") 
            {
                errorMsg = response.getReturnValue();
                self.toastMessage(component, event,"Error!","error",errorMsg);
                 component.set('v.Spinner',false);
            } else if (state === "ERROR") 
            {
                var errors = response.getError();
                var errorMsg='';
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        errorMsg = errors[0].message;
                        self.toastMessage(component, event,"Error!","error",errorMsg);
                    }
                } 
                else
               {
                    errorMsg = "Unknown error!";
                    self.toastMessage(component, event,"Error!","error",errorMsg);
                }
                component.set('v.Spinner',false);
            }
        });
        $A.enqueueAction(action);
	},
    doInitSubHelper: function (component, event,products,policies){
        var productpolicies = []; 
        if(products.length>0){
            for(var i=0;i<products.length;i++){
                for(var j=0;j<policies.length;j++){
                    //Add PolicyFormType field in obj for display records Policy_Form_Type__c from Product_Detail__c obj.
                    productpolicies.push({ProductId:products[i].Id, PolicyId: policies[j].Id, PolicyName: policies[j].Name,PolicyFormType:policies[j].PolicyFormType});
                }
            } 
        }	
        component.set("v.productpolicies", productpolicies); 
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
        //console.log(selectedOptionValue);
        var selectedOptionValue = component.get('v.selectedOptionsList');
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
        if(policyFormStateVal==null || policyFormStateVal ==''){
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
    /* =============== Save Product State Records =============== */
    setProdStateStatusHelper:function(component,event,prodid, state, policyid, isselected,prodstatepolicystatestatmap){
        var self = this;
       // console.log('Before prodid ',prodid,' state ',state,' policyid ',policyid,' isselected ',isselected);
        if(isselected != undefined){
            var hasRelation=self.getProdStateStatus(component,event,prodid, state, policyid,isselected);
            if(hasRelation){
                return;
            }
        }
        var statepolicymap = component.get('v.statepolicymap');
        var prodstatepolicyeditcount = component.get('v.prodstatepolicyeditcount');
        //  Define Cell if it Does Not Exist (First ProdId to State Map, Then State to Policy Id Map, Then Policy to ProdStateStatusObject)
        if(!(prodstatepolicystatestatmap[prodid]!=undefined)){
            prodstatepolicystatestatmap[prodid] = {};
        }
        
        if(!(prodstatepolicystatestatmap[prodid][state]!=undefined)){
            prodstatepolicystatestatmap[prodid][state] = {StateAvailId: null, PolicytoProdStateStat: {}};
        }
        
        var stateavailid = Object.keys(prodstatepolicystatestatmap[prodid][state])[0];
        if(stateavailid!='' && !stateavailid.includes('StateAvailId')){
            if(!(prodstatepolicystatestatmap[prodid][state][stateavailid].PolicytoProdStateStat[policyid]!=undefined)){
                //  Retrieve Filing Status Id If Available
                var filingstatid;
                var isdefined = false;
                
                if(statepolicymap[state]!=undefined){
                    isdefined = (statepolicymap[state][policyid]!=undefined);
                }
                
                if(isdefined){
                    filingstatid = statepolicymap[state][policyid].FilingStatusId;
                }
                prodstatepolicystatestatmap[prodid][state][stateavailid].PolicytoProdStateStat[policyid] = {ProductStateStatusId: null, FilingStatusId: filingstatid, InsertOrDelete: false};
                
            }
            
            //  Toggle Value of Cell
            var newInsertOrDel = !prodstatepolicystatestatmap[prodid][state][stateavailid].PolicytoProdStateStat[policyid].InsertOrDelete;
            if(isselected != undefined){
                newInsertOrDel = isselected;
            }
            // when select column then make it as true
            prodstatepolicystatestatmap[prodid][state][stateavailid].PolicytoProdStateStat[policyid].InsertOrDelete = newInsertOrDel;
            
            //  Tally Edit Fields
            prodstatepolicyeditcount += (newInsertOrDel ? 1 : -1);
            component.set('v.prodstatepolicyeditcount',prodstatepolicyeditcount);
            
          
        }
        
    },
    getProdStateStatus :function(component,event,prodid, state, policyid,isselected)
    {
        var hasRelation =  component.get('v.hasRelation');
        var prodstatepolicystatestatmap = component.get('v.prodstatepolicystatestatmap');
        var isdefined = false;
        if(prodstatepolicystatestatmap[prodid]!=undefined)
        {
            if(prodstatepolicystatestatmap[prodid][state]!=undefined){
                var stateavailid = Object.keys(prodstatepolicystatestatmap[prodid][state])[0];
                if(stateavailid!='' && !stateavailid.includes('StateAvailId')){
                    isdefined = (prodstatepolicystatestatmap[prodid][state][stateavailid].PolicytoProdStateStat[policyid]);
                }
            }
        }
        
        if(isdefined)
        {
            var stateavailid = Object.keys(prodstatepolicystatestatmap[prodid][state])[0];
            var prodstatestat = prodstatepolicystatestatmap[prodid][state][stateavailid].PolicytoProdStateStat[policyid];
            if(isselected!=undefined && prodstatestat.InsertOrDelete){
                return false;
            }
            hasRelation = ((prodstatestat.ProductStateStatusId == null && prodstatestat.InsertOrDelete) || 
                           (prodstatestat.ProductStateStatusId != null && !prodstatestat.InsertOrDelete));
        } 
		        
        return hasRelation;
        
    },
    saveProdStatePolicyStatusHelper: function(component,event) 
    {
        var self = this; 
		var statestatprodmap = component.get('v.prodstatepolicystatestatmap');
        var finalData=self.removeInvalidRecords(component);
        console.log('@@prodstatepolicystatestatmapNew :: ',JSON.stringify(finalData));
        //console.log('statestatprodmap ',statestatprodmap);
        var action = component.get("c.saveProdStatePolicyStatus");
        action.setParams({
            "prodstatepolicystatmapstr":JSON.stringify(finalData)
        });
        action.setCallback(component, function(response){
            var state = response.getState();
            var errorMsg='',warningMsg='',successMsg='';
            if (state == "SUCCESS"){
                var result = JSON.parse(response.getReturnValue());
               // console.log('result ',result);
                if(!result.bIsError){
                    successMsg = result.sMessage;
                    self.toastMessage(component, event,"Success!","success",successMsg);
                }else{
                    errorMsg = result.sMessage;
                    self.toastMessage(component, event,"Error!","error",errorMsg); 
                }
                $A.get('e.force:refreshView').fire();
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
    /* =============== Save Product State Records =============== */
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
        var prodcolumns = component.get('v.prodcolumns');
        setTimeout(function(){
            for(var prodId in prodcolumns){
                for(var policyid in prodcolumns[prodId]){
                    if(prodcolumns[prodId][policyid]){
                        if(document.getElementsByClassName(prodId+' '+policyid)!=undefined && document.getElementsByClassName(prodId+' '+policyid).length>0){
                            for(var i=0;i<document.getElementsByClassName(prodId+' '+policyid).length;i++){
                            	document.getElementsByClassName(prodId+' '+policyid)[i].style.backgroundColor='yellow';
                            }
                        }
                    }
                }
            }
        },200);
    },
    removeInvalidRecords:function(component){
        var prodstatepolicystatestatmapNew={};
        var prodstatepolicystatestatmap = component.get('v.prodstatepolicystatestatmap');
        for(var Product in prodstatepolicystatestatmap){
            prodstatepolicystatestatmapNew[Product]={};
            for(var state in prodstatepolicystatestatmap[Product]){
                prodstatepolicystatestatmapNew[Product][state]={};
                var stateavailid = Object.keys(prodstatepolicystatestatmap[Product][state])[0];
                if(stateavailid!='' && !stateavailid.includes('StateAvailId')){
                    prodstatepolicystatestatmapNew[Product][state]=prodstatepolicystatestatmap[Product][state];
                }
            }
        }
        return prodstatepolicystatestatmapNew;
        
    }
})
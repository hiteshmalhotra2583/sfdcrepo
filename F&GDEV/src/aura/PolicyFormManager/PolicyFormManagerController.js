({
    filterSection : function(component, event, helper) {
       helper.filterSectionHelper(component,event,'filterOne');
    },
	doInit : function(component, event, helper) {
			
	  //  console.log('--intializing component--');
	    component.set("v.policies",[]);
        component.set("v.products",[]);
        component.set('v.policyFormStateVal','');
        component.set('v.selctedPolicyFormType','');
        var policyFormStateVal = component.get('v.policyFormStateVal');
        helper.getPolicyFormStateHelper(component,event);
        helper.getPolicyFormTypeHelper(component,event);
        helper.doInitHelper(component,event,policyFormStateVal);
	},
    refreshCmp : function(component, event, helper) {
      $A.get('e.force:refreshView').fire();   
    },
    handleChange:function(component, event,helper){
        var selectedOptionsList = event.getParam("value");
        component.set('v.selectedOptionsList',selectedOptionsList);
        helper.handleChangeHelper(component, event);
        helper.policyFormStateChangeHelper(component,event);
    },
    policyFormStateChange:function(component, event,helper){
        helper.policyFormStateChangeHelper(component, event);
        helper.handleChangeHelper(component, event);
    },
    selectColumns :function(component, event, helper) {
        var policyid=event.currentTarget.dataset.value;
       // console.log('policyid',policyid);
        if(policyid!=undefined && policyid!=null && policyid!=''){
            var policycolumns = component.get('v.policycolumns');
            var states = component.get('v.states');
            var statepolicymap = component.get('v.statepolicymap');
            if(!(policycolumns[policyid]!=undefined)){
                policycolumns[policyid] = false;
            }
            policycolumns[policyid]  = !policycolumns[policyid];
            for(var i=0;i<document.getElementsByClassName(policyid).length;i++){
                if(policycolumns[policyid])
                    document.getElementsByClassName(policyid)[i].style.backgroundColor='yellow';
                else
                    document.getElementsByClassName(policyid)[i].style.backgroundColor='';
            }
            var policycolselcount = component.get('v.policycolselcount');
            for(var i=0; i<states.length; i++){
               
                var statepolicyselectcount = component.get('v.statepolicyselectcount');
                
                var statecode = states[i].StateCode__c;
                var isSelected = policycolumns[policyid];
                
                helper.selectHelper(component,event,statecode, policyid, isSelected,statepolicymap,statepolicyselectcount);
                policycolselcount += (isSelected ? 1 : -1);
                component.set('v.policycolselcount',policycolselcount);
               // console.log('policycolselcount ',policycolselcount);
            }
        }
    },
    hideColumns:function(component, event, helper){
        var policyid=event.currentTarget.dataset.value;
        var refPolicies = component.get('v.refPolicies');
        var policies = component.get('v.policies');
        for(var i=0;i<policies.length;i++){
            if(policies[i].Id == policyid){
                var policyObj = policies.splice(i, 1);
                refPolicies.push({"index":i,"policyData":policyObj[0]});
                break;
            }
        }
        
        component.set('v.policies',policies);
        component.set('v.refPolicies',refPolicies);
    },
    undoHidePolicy:function(component, event, helper){
        var policies = component.get('v.policies');
        var refPolicies = component.get('v.refPolicies');
        var lastPolicyObj = refPolicies.splice(refPolicies.length-1, 1);
   		policies.splice(lastPolicyObj[0].index, 0,lastPolicyObj[0].policyData);
        component.set('v.policies',policies);
        component.set('v.refPolicies',refPolicies);
    },
    deSelectAllPolicy:function(component, event, helper){
        for(var i=0;i<document.getElementsByClassName('policyStatusBlock').length;i++){
             document.getElementsByClassName('policyStatusBlock')[i].style.backgroundColor='';
        }
        for(var i=0;i<document.getElementsByClassName('statesPolicyNameBlock').length;i++){
            document.getElementsByClassName('statesPolicyNameBlock')[i].style.backgroundColor='';
        }
        var policycolumns = component.get('v.policycolumns');
        var statepolicymap = component.get('v.statepolicymap');
        var policies = component.get('v.policies');
        var states = component.get('v.states');
        for(var i=0;i<policies.length;i++){
            var policyid  = policies[i].Id;
            
            for(var j=0;j<states.length;j++){
                var state = states[j].StateCode__c;
                if(policyid!=undefined && policyid!=null &&
                   state!=undefined && state!=null &&
                   statepolicymap[state][policyid]!=undefined && statepolicymap[state][policyid]!=null &&
                   statepolicymap[state][policyid].UISelected!=undefined && 
                   statepolicymap[state][policyid].UISelected){
                    //console.log('state policyid : ',state+' , '+policyid);
                    statepolicymap[state][policyid].UISelected = false;
                    policycolumns[policyid] = false;
                   
                } 
            }
        }
        component.set('v.policycolselcount',0);
        component.set('v.statepolicyselectcount',0);
        component.set('v.statepolicymap',statepolicymap);
        component.set('v.policycolumns',policycolumns);
       // console.log('JSON.stringify(statepolicymap) ',JSON.stringify(statepolicymap));
        
    },
    redirectToSobject: function (component, event, helper) {
        var statePolicyIds = event.currentTarget.dataset.value;
        window.open('/' + statePolicyIds);  
        component.set("v.isDoubleClicked",true);
    },
    redirectToSobject2: function (component, event, helper) {
        component.set("v.isDoubleClicked",true);
        var statepolicymap = component.get('v.statepolicymap');
        var statePolicyIds = event.currentTarget.dataset.value;
        var array = statePolicyIds.split(',');
        var state = array[0];
        var policyid = array[1];
        try {
            if(state!=undefined && state!=null && state!='' && 
               policyid!=undefined && policyid!=null && policyid!='' &&
               statepolicymap!=undefined && statepolicymap!=null &&
               statepolicymap[state][policyid]!=undefined && statepolicymap[state][policyid]!=null &&
               statepolicymap[state][policyid].FilingStatusObj!=undefined && statepolicymap[state][policyid].FilingStatusObj!=null &&
               statepolicymap[state][policyid].FilingStatusObj.Id!=undefined && statepolicymap[state][policyid].FilingStatusObj.Id!=null ){
                window.open('/' + statepolicymap[state][policyid].FilingStatusObj.Id);  
            }
        }catch(err) { 
            helper.toastMessage(component, event,"Error!","error",err.message);
            return;
        }
        
    },
    redirectToHome:function(component, event, helper){
        //window.history.back();
      window.open('/' + component.get('v.recordId'),'_self');  
    },
    selectColumn:function(component, event, helper){
        
        var statePolicyIds = event.currentTarget.dataset.value;
        if(event.currentTarget.style.backgroundColor=='yellow'){
            event.currentTarget.style.backgroundColor='';
        }else{
            event.currentTarget.style.backgroundColor='yellow';
        }
        var array = statePolicyIds.split(',');
        var state = array[0];
        var policyid = array[1];
        // console.log('state ',state);
        // console.log('policyid ',policyid);
        if(state!=undefined && state!=null && state!='' && policyid!=undefined && policyid!=null && policyid!=''){
            var statepolicymap = component.get('v.statepolicymap');
            var statepolicyselectcount = component.get('v.statepolicyselectcount');
            var currSelectVal;
           // console.log('before statepolicymap ',statepolicymap);
            helper.selectHelper(component, event,state, policyid, currSelectVal,statepolicymap,statepolicyselectcount);
           // console.log('after statepolicymap ',statepolicymap);
        }
    },
    selectRow :function(component, event, helper) {
       // var policyrows = [];
        var policies = component.get('v.policies');
        //var policycolumns = component.get('v.policycolumns');
        var policyrows = component.get('v.policyrows');
        var statecode = event.currentTarget.dataset.value;
        if(!(policyrows[statecode]!=undefined)){
            policyrows[statecode] = false;
        }
        policyrows[statecode] = !policyrows[statecode];
        for(var i=0;i<document.getElementsByClassName(statecode).length;i++){
            if(policyrows[statecode])
                document.getElementsByClassName(statecode)[i].style.backgroundColor='yellow';
            else
                document.getElementsByClassName(statecode)[i].style.backgroundColor='';
        }
        for(var i=0; i<policies.length; i++){
            var policyid = policies[i].Id;
            var currSelectVal = policyrows[statecode];
            var statepolicymap = component.get('v.statepolicymap');
            var statepolicyselectcount = component.get('v.statepolicyselectcount');
           /* 
            //Change bg color of columns whose row is selected
            for(var ii=0;ii<document.getElementsByClassName(policyid).length;ii++){
                if(policycolumns[policyid])
                    document.getElementsByClassName(policyid)[ii].style.backgroundColor='yellow';
                else
                    document.getElementsByClassName(policyid)[ii].style.backgroundColor='';
            }*/
            helper.selectHelper(component, event,statecode, policyid, currSelectVal,statepolicymap,statepolicyselectcount);
        }
    },
    editFilingStatuses:function(component, event, helper) {
        helper.editFilingStatusesHelper(component, event);
    },
    closeFilings:function(component, event, helper) {
         component.set('v.isEditFilings',false);
    },
    updateFilings:function(component, event, helper) {
        helper.saveStatePolicyStatusHelper(component, event);
    },
    addPolicies:function(component, event, helper) {
        component.set('v.isPolicyAddStatus',true);
    },
    closePolicy:function(component, event, helper) {
         component.set('v.isPolicyAddStatus',false);
    },
    searchPolicy:function(component, event, helper) {
        helper.searchPolicyHelper(component, event);
    },
    refreshPage: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    setSelPolicyRowsData:function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');        
        var setRows = [];
        for (var i = 0; i < selectedRows.length; i++){
            setRows.push(selectedRows[i].Id);
        }
        component.set("v.selectedPolicyIds", setRows);
    },
    selectPolicies:function(component, event, helper) {
        var selectedPolicyIds = component.get("v.selectedPolicyIds");
        var projectId = component.get('v.recordId');
        if(selectedPolicyIds.length>0){
            // console.log('selectedPolicyIds ',selectedPolicyIds);
             helper.saveProjectPolicysHelper(component, event,projectId,selectedPolicyIds);
        }else{
            var warningMsg = 'Please first select at list one record!';
            helper.toastMessage(component, event,"Warning!","warning",warningMsg); 
        }
    },
    /* =============== Save Product State Records =============== */
    selProdCol :function(component, event, helper){
        var prodpolindex = event.currentTarget.dataset.value;
        var productpolicies = component.get('v.productpolicies');
        var prodcolumns = component.get('v.prodcolumns');
        var states = component.get('v.states');
        var prodid = (productpolicies[prodpolindex].ProductId!=undefined && productpolicies[prodpolindex].ProductId!='')?productpolicies[prodpolindex].ProductId:'';
        var policyid = (productpolicies[prodpolindex].PolicyId!=undefined && productpolicies[prodpolindex].PolicyId!='')?productpolicies[prodpolindex].PolicyId:'';
        
        if(prodid!=undefined && prodid!='' && policyid!=undefined && policyid!=''){
            if(!(prodcolumns[prodid]!=undefined)){
                prodcolumns[prodid]  = {};
            }
            if(!(prodcolumns[prodid][policyid]!=undefined)){
                prodcolumns[prodid][policyid] = false;
            }
            
            prodcolumns[prodid][policyid] = !prodcolumns[prodid][policyid];
            var isSelected = prodcolumns[prodid][policyid];
            
            for(var i=0; i<states.length; i++){
                var statecode = states[i].StateCode__c;
                helper.setProdStateStatusHelper(component,event,prodid, statecode, policyid, isSelected);
            }
        }
    },
    setProdStateStatus: function(component, event, helper) {
        var productStatePolicy = event.currentTarget.dataset.value;
        var array = productStatePolicy.split(',');
        var prodid   = (array[0]!=undefined && array[0]!='')?array[0]:'';
        var state    = (array[1]!=undefined && array[1]!='')?array[1]:'';
        var policyid = (array[2]!=undefined && array[2]!='')?array[2]:'';
        if(prodid!=undefined && prodid!='' && state!=undefined && state!='' && policyid!=undefined && policyid!='')
            helper.setProdStateStatusHelper(component,event,prodid, state, policyid);
    },
    saveProdStatePolicyStatuss:function(component, event, helper) {
        helper.saveProdStatePolicyStatusHelper(component, event);
    },
    /* =============== Save Product State Records =============== */
    nextPage : function(component, event, helper){
        var states = component.get('v.states');
        var end = component.get('v.end');
        var start = component.get('v.start');
        var pageSize = component.get('v.pageSize');
        var statess = [];
        var counter = 0;
        var startPoint= end+1;
        var endPoint = end+pageSize+1;
      //  console.log('startPoint ',startPoint,'endPoint ',endPoint);
        for(var i=startPoint; i<endPoint; i++)  
        {
            if(states.length > end){
                statess.push(states[i]);
                counter ++ ;  
            } 
        }
        start = start + counter;
        end = end + counter;
        component.set('v.start',start);
        component.set('v.end',end);
        component.set('v.statess', statess);
        helper.applyCSStoSelectedRec(component);
       // console.log('statess ',JSON.stringify(statess));
      //  console.log('statess size ',statess.length);
    },
    previousPage : function(component, event, helper){
        var states = component.get('v.states');
        var end = component.get('v.end');
        var start = component.get('v.start');
        var pageSize = component.get('v.pageSize');
        var statess = [];
        var counter = 0; 
        for(var i= start-pageSize; i < start ; i++){ 
            if(i > -1){  
                statess.push(states[i]);
                counter ++; 
            }else {
                start++;  
            }
        }
        
        start = start - counter;
        end = end - counter;
        component.set('v.start',start);
        component.set('v.end',end);
        component.set('v.statess', statess);
        helper.applyCSStoSelectedRec(component);
       //  console.log('statess ',JSON.stringify(statess));
    },
    PolicyFormTypeChange:function(component, event, helper){
        var policies = [];
        var selctedPolicyFormType = component.get('v.selctedPolicyFormType');
        var products = component.get('v.products');
        var policiesCopy = component.get("v.policiesCopy");
        if(selctedPolicyFormType!='' && selctedPolicyFormType!=null){
            for(var i=0;i<policiesCopy.length;i++){
                if(policiesCopy[i].PolicyFormType==selctedPolicyFormType){
                    policies.push(policiesCopy[i]);
                }
            }
            component.set("v.policies",policies);
            helper.doInitSubHelper(component, event,products,policies);
            helper.handleChangeHelper(component, event);
        }else{
            component.set("v.policies",policiesCopy);
            helper.policyFormStateChangeHelper(component, event,products,policiesCopy);
            helper.doInitSubHelper(component, event,products,policiesCopy);
            helper.handleChangeHelper(component, event);
        }
        
    },
    resetAllFilter:function(component, event, helper){
        component.set("v.policies",[]);
        component.set("v.products",[]);
        component.set('v.policyFormStateVal','');
        component.set('v.selctedPolicyFormType','');
        component.set('v.selectedOptionsList',[])
        var policyFormStateVal = component.get('v.policyFormStateVal');
        helper.getPolicyFormStateHelper(component,event);
        helper.getPolicyFormTypeHelper(component,event);
        helper.doInitHelper(component,event,policyFormStateVal);
    }
    
})
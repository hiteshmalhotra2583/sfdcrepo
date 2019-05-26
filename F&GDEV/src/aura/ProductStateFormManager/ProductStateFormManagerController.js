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
        component.set('v.selctedProduct','');
        component.set('v.prodcolumns',{});
        
        var policyFormStateVal = component.get('v.policyFormStateVal');
        helper.getPolicyFormStateHelper(component,event);
        helper.getPolicyFormTypeHelper(component,event);
        helper.getFilingStrategyHelper(component,event);
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
    /* =============== Save Product State Records =============== */
    selProdCol :function(component, event, helper){
        var prodpolindex = event.currentTarget.dataset.value;
        var productpolicies = component.get('v.productpolicies');
        var prodcolumns = component.get('v.prodcolumns');
        var states = component.get('v.states');
       
        var prodid = (productpolicies[prodpolindex].ProductId!=undefined && productpolicies[prodpolindex].ProductId!='')?productpolicies[prodpolindex].ProductId:'';
        var policyid = (productpolicies[prodpolindex].PolicyId!=undefined && productpolicies[prodpolindex].PolicyId!='')?productpolicies[prodpolindex].PolicyId:'';
        
        if(prodid!=undefined && prodid!='' && policyid!=undefined && policyid!=''){
           //=====additional logic set background color for selected columns=====
            var policycolumns = component.get('v.policycolumns');
            
            if(!(policycolumns[policyid]!=undefined)){
                policycolumns[policyid] = false;
            }
            policycolumns[policyid]  = !policycolumns[policyid];
            for(var i=0;i<document.getElementsByClassName(prodid+' '+policyid).length;i++){
                if(policycolumns[policyid])
                    document.getElementsByClassName(prodid+' '+policyid)[i].style.backgroundColor='yellow';
                else
                    document.getElementsByClassName(prodid+' '+policyid)[i].style.backgroundColor='';
            }
            
            //=====additional logic  set background color for selected columns=====
            
            if(!(prodcolumns[prodid]!=undefined)){
                prodcolumns[prodid]  = {};
            }
            if(!(prodcolumns[prodid][policyid]!=undefined)){
                prodcolumns[prodid][policyid] = false;
            }
            
            prodcolumns[prodid][policyid] = !prodcolumns[prodid][policyid];
            var isSelected = prodcolumns[prodid][policyid];
            var prodstatepolicystatestatmap = component.get('v.prodstatepolicystatestatmap');
            for(var i=0; i<states.length; i++){
                var statecode = states[i].StateCode__c;
                helper.setProdStateStatusHelper(component,event,prodid, statecode, policyid, isSelected,prodstatepolicystatestatmap);
            }
            component.set('v.prodstatepolicystatestatmap',prodstatepolicystatestatmap);
        }
    },
    deSelectProdStatePolicyStatuss: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    refreshPage: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    redirectToSobject: function (component, event, helper) {
        var policyId = event.currentTarget.dataset.value;
        window.open('/' + policyId);  
        component.set("v.isDoubleClicked",true);
    },
    redirectToSobject3: function (component, event, helper) {
        var prodStatePolicymap = component.get('v.prodstatepolicystatestatmap');
        var productStatePolicyMap = event.currentTarget.dataset.value;
        var array = productStatePolicyMap.split(',');
        console.log('array:::'+array);
        
    },
    redirectToSobject2: function (component, event, helper) {
        var statepolicymap = component.get('v.statepolicymap');
        var productStatePolicy = event.currentTarget.dataset.value;
        var array = productStatePolicy.split(',');
        var prodid   = (array[0]!=undefined && array[0]!='')?array[0]:'';
        var state    = (array[1]!=undefined && array[1]!='')?array[1]:'';
        var policyid = (array[2]!=undefined && array[2]!='')?array[2]:'';
        
        try {
            if(prodid!=undefined && prodid!='' && 
               state!=undefined && state!='' && 
               policyid!=undefined && policyid!=''&&
               statepolicymap!=undefined && statepolicymap!=null &&
               statepolicymap[state][policyid]!=undefined && statepolicymap[state][policyid]!=null &&
               statepolicymap[state][policyid].FilingStatusObj!=undefined && statepolicymap[state][policyid].FilingStatusObj!=null &&
               statepolicymap[state][policyid].FilingStatusObj.Id!=undefined && statepolicymap[state][policyid].FilingStatusObj.Id!=null ){
                window.open('/' + statepolicymap[state][policyid].FilingStatusObj.Id); 
                 component.set("v.isDoubleClicked",true);
            } 
        }catch(err) {
            helper.toastMessage(component, event,"Error!","error",err.message);
            return;
        }
      
    },
    /*redirectToSobject2: function (component, event, helper) {
        
        var prodstatepolicystatestatmap = component.get('v.prodstatepolicystatestatmap');
        var productStatePolicy = event.currentTarget.dataset.value;
        var array = productStatePolicy.split(',');
        var prodid   = (array[0]!=undefined && array[0]!='')?array[0]:'';
        var state    = (array[1]!=undefined && array[1]!='')?array[1]:'';
        var policyid = (array[2]!=undefined && array[2]!='')?array[2]:'';
        
        try {
            
            if(prodid!=undefined && prodid!='' && 
               state!=undefined && state!='' && 
               policyid!=undefined && policyid!=''&&
               prodstatepolicystatestatmap!=undefined &&  prodstatepolicystatestatmap!=null &&
               prodstatepolicystatestatmap[prodid]!=undefined && prodstatepolicystatestatmap[prodid]!=null &&
               prodstatepolicystatestatmap[prodid][state]!=undefined && prodstatepolicystatestatmap[prodid][state]!=null){
                var stateavailid = Object.keys(prodstatepolicystatestatmap[prodid][state])[0];
                if(stateavailid!=null && stateavailid!='' && stateavailid!='StateAvailId'){
                     window.open('/' + stateavailid);
                    component.set("v.isDoubleClicked",true);
                }
            } 
        }catch(err) {
            helper.toastMessage(component, event,"Error!","error",err.message);
            return;
        }
      
    },*/
    redirectToHome:function(component, event, helper){
        //window.history.back();
      window.open('/' + component.get('v.recordId'),'_self');  
    },
    hideColumns:function(component, event, helper){
        var policyid=event.currentTarget.dataset.value;
        var policies = component.get('v.policies');
        var products = component.get("v.products");
        var refPolicies = component.get('v.refPolicies');
        var productpolicies = [];
        for(var i=0;i<policies.length;i++){
            if(policies[i].Id == policyid){
                var policyObj = policies.splice(i, 1);
                refPolicies.push({"index":i,"policyData":policyObj[0]});
                break;
            }
        }
        if(products.length>0){
            for(var i=0;i<products.length;i++){
                for(var j=0;j<policies.length;j++){
                    productpolicies.push({ProductId:products[i].Id, PolicyId: policies[j].Id, PolicyName: policies[j].Name});
                }
            } 
        }
        component.set('v.policies',policies);
        component.set('v.productpolicies',productpolicies);
        component.set('v.refPolicies',refPolicies);
    },
    
    undoHidePolicy:function(component, event, helper){
        var policies = component.get('v.policies');
        var refPolicies = component.get('v.refPolicies');
        var products = component.get("v.products");
        var productpolicies = [];
        
        var lastPolicyObj = refPolicies.splice(refPolicies.length-1, 1);
   		policies.splice(lastPolicyObj[0].index, 0,lastPolicyObj[0].policyData);
        if(products.length>0){
            for(var i=0;i<products.length;i++){
                for(var j=0;j<policies.length;j++){
                    productpolicies.push({ProductId:products[i].Id, PolicyId: policies[j].Id, PolicyName: policies[j].Name});
                }
            } 
        }
        component.set('v.policies',policies);
        component.set('v.refPolicies',refPolicies);
        component.set('v.productpolicies',productpolicies);
    },
    setProdStateStatus: function(component, event, helper) {
        var productStatePolicy = event.currentTarget.dataset.value;
        var array = productStatePolicy.split(',');
        var prodid   = (array[0]!=undefined && array[0]!='')?array[0]:'';
        var state    = (array[1]!=undefined && array[1]!='')?array[1]:'';
        var policyid = (array[2]!=undefined && array[2]!='')?array[2]:'';
       
        if(prodid!=undefined && prodid!='' && state!=undefined && state!='' && policyid!=undefined && policyid!=''){
            //=====additional logic  set background color for selected columns=====
            if(event.currentTarget.style.backgroundColor=='yellow'){
                event.currentTarget.style.backgroundColor='';
            }else{
                event.currentTarget.style.backgroundColor='yellow';
            }
            var prodstatepolicystatestatmap = component.get('v.prodstatepolicystatestatmap');
            //=====additional logic  set background color for selected columns=====
            helper.setProdStateStatusHelper(component,event,prodid, state, policyid,undefined, prodstatepolicystatestatmap);
        }	component.set('v.prodstatepolicystatestatmap',prodstatepolicystatestatmap);
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
       // console.log('startPoint ',startPoint,'endPoint ',endPoint);
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
       // console.log('statess size ',statess.length);
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
    productChange:function(component,event,helper){
        var productId = component.get('v.selctedProduct');
        var products=[],policies=[];
        //var products=component.get('v.products');
        var productsCopy=component.get('v.productsCopy');
        var policies=component.get('v.policies');
        if(productId!='' && productId!=null){
            for(var i=0;i<productsCopy.length;i++){
                if(productsCopy[i].Id ==productId){
                    products.push(productsCopy[i]);
                }
            }
            component.set('v.products',products);
            helper.doInitSubHelper(component, event,products,policies);
            helper.handleChangeHelper(component, event);
        }else{
            component.set('v.products',productsCopy);
            helper.doInitSubHelper(component, event,productsCopy,policies); 
            helper.handleChangeHelper(component, event);
        }
    },
    hideProduct:function(component, event, helper){
        var productId=event.currentTarget.dataset.value;
        var refProducts = component.get('v.refProducts');
        var products=component.get('v.products');
        var policies=component.get('v.policies');
        for(var i=0;i<products.length;i++){
            if(products[i].Id == productId){
                var productObj = products.splice(i, 1);
                refProducts.push({"index":i,"productData":productObj[0]});
                break;
            }
        }
        component.set('v.refProducts',refProducts);
        component.set('v.products',products);
        helper.doInitSubHelper(component, event,products,policies); 
    },
    undoHideProduct:function(component, event, helper){
        var productId=event.currentTarget.dataset.value;
        var refProducts = component.get('v.refProducts');
        var products=component.get('v.products');
        var policies=component.get('v.policies');
        var lastProductObj = refProducts.splice(refProducts.length-1, 1);
   		products.splice(lastProductObj[0].index, 0,lastProductObj[0].productData);
        component.set('v.refProducts',refProducts);
        component.set('v.products',products);
        helper.doInitSubHelper(component, event,products,policies); 
    },
    redirectToProduct:function(component, event, helper){
        var productId=event.currentTarget.dataset.value;
        window.open('/' + productId,'_blank');  
    },
    PolicyFormTypeChange:function(component, event, helper){
        var policies = [];
        var selctedPolicyFormType = component.get('v.selctedPolicyFormType');
        var selctedFilingStrategy = component.get('v.selctedFilingStrategy');
        var products = component.get('v.products');
        var policiesCopy = component.get("v.policiesCopy");
        if((selctedPolicyFormType!='' && selctedPolicyFormType!=null) || (selctedFilingStrategy!='' && selctedFilingStrategy!=null)){
            for(var i=0;i<policiesCopy.length;i++){
                policies.push(policiesCopy[i]);
            }
            var policiesFormFilter=[];
            if(selctedPolicyFormType!='' && selctedPolicyFormType!=null){
                for(var i=0;i<policies.length;i++){
                    if(policies[i].PolicyFormType==selctedPolicyFormType){
                        policiesFormFilter.push(policies[i]);
                    }
                }
            }else{
                policiesFormFilter=policies;
            }
            var filingStrategyFilter=[];
            if(selctedFilingStrategy!='' && selctedFilingStrategy!=null){
                for(var i=0;i<policiesFormFilter.length;i++){
                    if(policiesFormFilter[i].FilingStrategy==selctedFilingStrategy){
                        filingStrategyFilter.push(policiesFormFilter[i]);
                    }
                }
            }else{
                filingStrategyFilter=policiesFormFilter;
            }
            component.set("v.policies",filingStrategyFilter);
            helper.doInitSubHelper(component, event,products,filingStrategyFilter);
            helper.handleChangeHelper(component, event);
        }else{
           
            component.set("v.policies",policiesCopy);
            helper.policyFormStateChangeHelper(component, event,products,policiesCopy);
            helper.doInitSubHelper(component, event,products,policiesCopy);
            helper.handleChangeHelper(component, event);
 
        }
        
    },
    FilingStrategyChange:function(component, event, helper){
        
    },
    resetAllFilter:function(component, event, helper){
        component.set("v.policies",[]);
        component.set("v.products",[]);
        component.set('v.policyFormStateVal','');
        component.set('v.selctedPolicyFormType','');
        component.set('v.selctedProduct','');
        component.set('v.selectedOptionsList',[]);
        var policyFormStateVal = component.get('v.policyFormStateVal');
        helper.getPolicyFormStateHelper(component,event);
        helper.getPolicyFormTypeHelper(component,event);
        helper.doInitHelper(component,event,policyFormStateVal);
    }
})
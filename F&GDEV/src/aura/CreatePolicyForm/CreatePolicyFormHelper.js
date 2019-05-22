({
    fetchPickListVal: function(component, getFrom,objectName,methodOrFieldName,elementId){
        var action = component.get("c.getselectOptions");
        action.setParams({
            "getFrom":getFrom,
            "objectName": objectName,
            "methodOrFieldName": methodOrFieldName
        });
        
        var opts = [];
        action.setCallback(this, function(response){
            //console.log("response:",response.getState());
            if (response.getState() == "SUCCESS"){
                var allValues = response.getReturnValue();
                
                //console.log("values:",response.getReturnValue());
                if (allValues != undefined ){
                    
                    opts.push({
                        class: "optionClass",
                        label: "--- None ---",
                        value: ""
                    });
                    for(var k in allValues){ 
                        opts.push({
                            class: "optionClass",
                            label: allValues[k],
                            value: k
                        });
                     };
                }
                if(elementId=='FIA_Filing_Strategy_1'){
                    component.set("v.FIA_Filing_Strategy_1",opts);
                    var individual=[];
                    var group=[];
                    var compact=[];
                    var stateVariance=[];
                    for(var i=0;i<opts.length;i++){
                        if(opts[i].label.toLowerCase().indexOf("individual")!=-1){
                            individual.push(opts[i]);
                            stateVariance.push(opts[i]);
                        }
                        else if(opts[i].label.toLowerCase().indexOf("group")!=-1){
                            group.push(opts[i]);
                            stateVariance.push(opts[i]);
                        }
                        else if(opts[i].label.toLowerCase().indexOf("compact")!=-1){
                            compact.push(opts[i]);
                        }
                        else if(opts[i].label.toLowerCase().indexOf("not filing")!=-1 || opts[i].label.toLowerCase().indexOf(" none ")!=-1){
                            individual.push(opts[i]);
                            group.push(opts[i]);
                            compact.push(opts[i]);
                            stateVariance.push(opts[i]);
                        }    
                    }
                    component.set("v.FIA_Filing_Strategy_Individual",individual);
                    component.set("v.FIA_Filing_Strategy_Group",group);
                    component.set("v.FIA_Filing_Strategy_Compact",compact);
                    component.set("v.FIA_Filing_Strategy_State_Variance",stateVariance);
                    
                    
                }else if(elementId=='FIA_Filing_Strategy_2'){
                  component.set("v.FIA_Filing_Strategy_2",opts);
                }else{
                    component.find(elementId).set("v.options", opts); 
                }
                
            }
        });
        $A.enqueueAction(action);
    }, 
   submitDetail: function(component){
       
       var action = component.get("c.createPolicyFormRecords");
        action.setParams({
            "insuranceType":component.get("v.insuranceType"),
            "policyFormType":component.get("v.policyFormType"),
            "otherType":component.get("v.otherType"),
            "individualStd":component.get("v.individualStd"),
            "groupStd":component.get("v.groupStd"),
            "compact":component.get("v.compact"),
            "stateVariationWrapper":JSON.stringify(component.get("v.stateVarianceList")),
            "selectedDefaultFillingStrategy":component.get("v.selectedDefaultFillingStrategy"),
            "isPrimaryInd":document.getElementById('isPrimaryInd').checked,
            "isPrimaryCompact":document.getElementById('isPrimaryStd').checked,
            "individualStdDes": component.get('v.IndividualStdDes'),
            "groupStdDes":component.get('v.GroupStdDes'),
            "compactStdDes":component.get('v.CompactStdDes')
        });
        
        var opts = [];
        action.setCallback(this, function(response){
            //console.log("response:",response.getState());
            if (response.getState() == "SUCCESS"){
                
                console.log('@@ ResponseData ',response.getReturnValue());
                
                // set approach1 and approach2
                if(response.getReturnValue()!=null){
                    var ResultData=[];
                    var rData=response.getReturnValue();
                    var policyFormDetail=[];
                    var MapFS={}
                    for(var i=0;i<rData.length;i++)
                    {
                        for(var j=0;j<rData[i].approach.length;j++){
                            console.log("(rData[i].approach[j].fs",rData[i].approach[j].fs);
                            if(rData[i].approach[j].fs != undefined){
                               
                                if(rData[i].approach[j].fs.Filing_Strategy__c !=undefined && rData[i].approach[j].fs.Filing_Strategy__c=='Group'){
                                    rData[i].approach[j].fs.Filing_Strategy__c="Group Filing";
                                }
                                MapFS[rData[i].approach[j].fs.Name]=rData[i].approach[j].fs;
                            }
                        }
                        if(policyFormDetail.length==0){
                            policyFormDetail=rData[i].policyFormDetail;
                        }
                    }
                    component.set("v.policyFormDetail",policyFormDetail);
                    for(var i=0;i<rData.length;i++)
                    {
                        var data={};
                        data.state=rData[i].state;
                        //data.policyFormId=rData[i].policyFormDetail;
                        data.approach=[];
                        for(var j=0;j<policyFormDetail.length;j++){
                            var fs=(MapFS[policyFormDetail[j].Name+'-'+rData[i].state]!=undefined && MapFS[policyFormDetail[j].Name+'-'+rData[i].state]!=null)?MapFS[policyFormDetail[j].Name+'-'+rData[i].state]:{};
                            var ApproachName=(fs.Filing_Strategy__c!=undefined?fs.Filing_Strategy__c:"");
                            var formType="State Variation";
                            if(policyFormDetail[j].Name==component.get("v.individualStd")){
                                formType="individualStd";
                            }else if(policyFormDetail[j].Name==component.get("v.groupStd") || policyFormDetail[j].Name==(component.get("v.groupStd")+' - GRP ')){
                                formType="groupStd";
                            }else if(policyFormDetail[j].Name==component.get("v.compact")){
                                formType="compact"; 
                            }
                            data.approach.push({formName:policyFormDetail[j].Name,formId:policyFormDetail[j].Id,type:formType,fs:fs,ApproachName:ApproachName});
                        }
                        ResultData.push(data);
                    }
                    console.log('@@ResultData',ResultData);   
                    component.set("v.ResultData",ResultData);
                    //component.set("v.ResponseData",rData);
                    component.set("v.cssStyle", true);
                    $A.util.addClass(component.find('stateModel'), 'slds-fade-in-open');
                    $A.util.addClass(component.find('stateModelBackDrop'), 'slds-backdrop--open');
                }
                
                
            }
        }); 
        $A.enqueueAction(action);
    },
    saveStateDetail : function(component){
         var self=this;
        var rData=component.get("v.ResultData");
        for(var i=0;i<rData.length;i++){
            if(rData[i].state == undefined || rData[i].state == null ||rData[i].state == ''){
                rData.splice(i, 1);
            }
        }
         console.log('@@policyFormDetail :: ',component.get("v.policyFormDetail"));
        console.log('@@rData :: ',rData);
        var action = component.get("c.createFilingStatus");
        action.setParams({
            "FilingStatusDetail":JSON.stringify(rData),
            "insuranceType":component.get("v.insuranceType"),
            "policyFormType":component.get("v.policyFormType"),
            "otherType":component.get("v.otherType")
        });
        
        var opts = [];
        action.setCallback(this, function(response){
            //console.log("response:",response.getState());
            if (response.getState() == "SUCCESS"){
                self.resetFormData(component);
                component.set("v.cssStyle", false);
                $A.util.removeClass(component.find('stateModel'), 'slds-fade-in-open');
                $A.util.removeClass(component.find('stateModelBackDrop'), 'slds-backdrop--open');  
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"Success",
                    "message": "The record has been saved successfully."
                });
                toastEvent.fire();
              
                var navService = component.find("navService");
                var pageReference = {
                    type: 'standard__objectPage',
                    attributes: {
                        objectApiName: 'Policy_Form_Detail__c',
                        actionName: 'list'
                    }
                };
                navService.navigate(pageReference);
               
            }
        }); 
        $A.enqueueAction(action);
         
    },
    cancelStateDetail : function(component){
        var self=this;
        var rData=component.get("v.ResultData");
         console.log('@@policyFormDetail :: ',component.get("v.policyFormDetail"));
        console.log('@@rData :: ',rData);
        var action = component.get("c.deletePolicyForm");
        action.setParams({
            "policyForms":JSON.stringify(component.get("v.policyFormDetail")),
        });
        
        var opts = [];
        action.setCallback(this, function(response){
            //console.log("response:",response.getState());
            if (response.getState() == "SUCCESS"){
                
                //self.resetFormData(component);
                component.set("v.cssStyle", false);
                $A.util.removeClass(component.find('stateModel'), 'slds-fade-in-open');
                $A.util.removeClass(component.find('stateModelBackDrop'), 'slds-backdrop--open');
               /* var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "title": "Success!",
                    "type":"Success",
                    "message": "The record has been saved successfully."
                });
                toastEvent.fire();*/
                
            }
        }); 
        $A.enqueueAction(action);
         
    },
    resetFormData : function(component){
        component.set("v.insuranceType","");
        component.set("v.policyFormType","");
        component.set("v.otherType","");
        component.set("v.individualStd","");
        component.set("v.groupStd","");
        component.set("v.compact","");
        component.set("v.stateVarianceList",[]);
        component.set("v.selectedDefaultFillingStrategy","");
        document.getElementById('radio-1').checked=false;
        document.getElementById('radio-2').checked=false;
        document.getElementById('radio-3').checked=false;
        document.getElementById('isPrimaryInd').checked=false;
        document.getElementById('isPrimaryStd').checked=false;
        
    },
    trimData : function(data){
        try{
            data=data.trim();
        }catch(e){
        }
        return data;
    },
    duplicateCheck : function(objData,newValue){
        var isDuplicate=false;
        if(newValue!=null && newValue!=''){
            if(objData[this.trimData(newValue)]==undefined)
                isDuplicate=false;
            else
                isDuplicate=true;
        }
        return isDuplicate;
    },
    isDuplicateFormGeneratedhelper:function(component, event,formName,formLabel){
        var self = this; 
        var action = component.get("c.duplicateFormGenerated");
        action.setParams({
            "formName":formName
        });
        action.setCallback(component, function(response){
            var state = response.getState();
            var errorMsg='',warningMsg='',successMsg='';
            if (state == "SUCCESS"){
                var result = response.getReturnValue();
                console.log('result ',result);
                if(result){
                    if(formLabel=='individualStd'){
                        component.set('v.isIndividualStdExist',true);
                    }else if(formLabel=='groupStd'){
                        component.set('v.isGroupStdExist',true);
                    }else if(formLabel=='compact'){
                        component.set('v.isCompactExist',true);
                    }else if(formLabel=='STRecordPolicyForm'){
                        component.set('v.isSTRecordPolicyFormExist',true);
                    }
                    errorMsg = formName+' form already exist!Please enter another form name!';
                    self.toastMessage(component, event,"Warning!","Warning",errorMsg); 
                }else{
                    if(formLabel=='individualStd'){
                        component.set('v.isIndividualStdExist',false);
                    }else if(formLabel=='groupStd'){
                        component.set('v.isGroupStdExist',false);
                    }else if(formLabel=='compact'){
                        component.set('v.isCompactExist',false);
                    }else if(formLabel=='STRecordPolicyForm'){
                        component.set('v.isSTRecordPolicyFormExist',false);
                    }
                }
                
            }else if (state === "INCOMPLETE") {
                errorMsg = response.getError();
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
    toastMessage:function(component, event,title,status,msg){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type":status,
            "message": msg
        });
        toastEvent.fire();
    }
    
    
})
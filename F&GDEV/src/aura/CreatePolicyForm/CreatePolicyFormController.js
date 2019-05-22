({
    doInit: function(component, event, helper){
        helper.fetchPickListVal(component,'object','Policy_Form_Detail__c','Insurance_Type__c','InsuranceType');
        helper.fetchPickListVal(component,'object','Policy_Form_Detail__c','Policy_Form_Type__c','PolicyFormType');
        helper.fetchPickListVal(component,'method','Policy_Form_Detail__c','getState','stateList');
        helper.fetchPickListVal(component,'method','Policy_Form_Detail__c','fillingType','groupSelect');
        helper.fetchPickListVal(component,'object','Filing_Status__c','Filing_Strategy__c','FIA_Filing_Strategy_1');
        component.set("v.STRecord",{});
        component.set("v.stateVarianceList",[]);
        component.set("v.ResponseData",[]);
    },
	showSpinner : function (component, event, helper){
        component.set("v.Spinner", true); 
    },
    
    hideSpinner : function (component, event, helper){
        component.set("v.Spinner", false);
    },
    strategySelect :function (component, event, helper){
        var data=event.currentTarget.dataset.value;
        component.set("v.selectedDefaultFillingStrategy",data);
        console.log('@@data :: '+data);
    },
    removeRecord: function (component, event, helper){
        var indx=parseInt(event.currentTarget.dataset.value);
        var lst=component.get("v.stateVarianceList");
        lst.splice(indx,1);
        component.set("v.stateVarianceList",lst);
       
    },
   
    closeModel: function(component, event, helper) {
       component.set("v.cssStyle", false);
          component.set("v.editRecIndex","");
       
       $A.util.removeClass(component.find('saveCallLog'), 'slds-fade-in-open');
       $A.util.removeClass(component.find('saveCallLogBackDrop'), 'slds-backdrop--open');
       
	},
    closeStateModel: function(component, event, helper) {
        helper.cancelStateDetail(component);
        
	},
    saveStateDetail :function(component, event, helper) 
    {
      
        helper.saveStateDetail(component);
    },
	editRecord: function(component, event, helper) {
        var indx=parseInt(event.currentTarget.dataset.value);
        component.set("v.editRecIndex",indx);
        var lst=component.get("v.stateVarianceList");
        component.set("v.STRecord",lst[indx]);
     
       component.set("v.cssStyle", true);
       $A.util.addClass(component.find('saveCallLog'), 'slds-fade-in-open');
       $A.util.addClass(component.find('saveCallLogBackDrop'), 'slds-backdrop--open');
        
	},
    addRecord: function(component, event, helper) {
        component.set("v.STRecord",{policyFormName:""});
        component.set("v.cssStyle", true);
       $A.util.addClass(component.find('saveCallLog'), 'slds-fade-in-open');
       $A.util.addClass(component.find('saveCallLogBackDrop'), 'slds-backdrop--open');
        
	},
    saveDetail: function(component, event, helper) {
        
        var policyFormNameState = component.get("v.STRecord.policyFormName");
        var StateDescription = component.get("v.STRecord.description");
        
        if(policyFormNameState==undefined || policyFormNameState==null || policyFormNameState==''){
            helper.toastMessage(component,event,"Warning!","Warning","Policy Form is a mandatory field!");
            return;
        }
        if(StateDescription==undefined || StateDescription==null || StateDescription==''){
            helper.toastMessage(component,event,"Warning!","Warning","Description is a mandatory field!");
            return;
        }
        
        
        if(component.get("v.STRecord.policyFormName") !=null 
           && component.get("v.STRecord.policyFormName") !='')
       {
            var lst=component.get("v.stateVarianceList");
            if(component.get("v.editRecIndex")!=null && component.get("v.editRecIndex")!=="")
            {
                var indx=component.get("v.editRecIndex");
                lst[indx]=component.get("v.STRecord");
            }
            else{
                lst.push(component.get("v.STRecord"));
            }
        	component.set("v.stateVarianceList",lst);
            
        }
        else
        {
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "title": "Error!",
                "type":"warning",
                "message": "Policy Form is a mandatory field."
            });
            toastEvent.fire();
            return;
        }
        
        
        component.set("v.cssStyle", false);
        component.set("v.editRecIndex","");
        
        $A.util.removeClass(component.find('saveCallLog'), 'slds-fade-in-open');
        $A.util.removeClass(component.find('saveCallLogBackDrop'), 'slds-backdrop--open');
        
	},
    submit :function(component, event, helper) {
        var errorTitle = '',errorType='',errorMsg='';
        var validationData={};
        var hasDuplicateName=false;
        
        //If stateVarianceList is not null then no need to check form is primary or not
        var stateVarianceList = component.get('v.stateVarianceList');
        var InsuranceType = component.get("v.insuranceType");
        var policyFormType =  component.get("v.policyFormType");
        var individualStd = component.get("v.individualStd");
        var groupStd = component.get("v.groupStd");
        var compact = component.get("v.compact");
        var isPrimaryInd = document.getElementById('isPrimaryInd').checked;
        var isPrimaryStd =  document.getElementById('isPrimaryStd').checked;
        var FIA = document.getElementById('radio-1').checked;
        var MYGA = document.getElementById('radio-2').checked;
        var IUL = document.getElementById('radio-3').checked;
        var isIndividualStdExist = component.get('v.isIndividualStdExist');
        var isGroupStdExist = component.get('v.isGroupStdExist');
        var isCompactExist = component.get('v.isCompactExist');
        var isSTRecordPolicyFormExist = component.get('v.isSTRecordPolicyFormExist');
        var IndividualStdDes = component.get('v.IndividualStdDes');
        var GroupStdDes = component.get('v.GroupStdDes');
        var CompactStdDes = component.get('v.CompactStdDes');
        
       
        if(InsuranceType==undefined || InsuranceType==null || InsuranceType==''){
            helper.toastMessage(component,event,"Warning!","Warning","Insurance Type is a mandatory field!");
            return;
        }
        if(policyFormType==undefined || policyFormType==null || policyFormType==''){
            helper.toastMessage(component,event,"Warning!","Warning","Policy Form Type is a mandatory field!");
            return;
        }
        if(!FIA && !MYGA && !IUL){
            helper.toastMessage(component,event,"Warning!","Warning","Please select at least one Default Filing Strategy!");
            return;
        }
       
        if(stateVarianceList.length<=0)
        {
            if(!isPrimaryInd && !isPrimaryStd){
                helper.toastMessage(component,event,"Warning!","Warning","Please select at least one Primary checkbox!");
                return;
            }
            
            if( isPrimaryInd && !isPrimaryStd && (individualStd==undefined || individualStd==null || individualStd=='') ){
                helper.toastMessage(component,event,"Warning!","Warning","Please Enter Individual Std Name!”");
                return;
            }
            
            if( !isPrimaryInd && isPrimaryStd && (compact==undefined || compact==null || compact=='')){
                helper.toastMessage(component,event,"Warning!","Warning","Please Enter Compact Name!”");
                return;
            }
            
            
            
            if((individualStd==undefined || individualStd==null || individualStd=='') &&
               (groupStd==undefined || groupStd==null || groupStd=='') &&
               (compact==undefined || compact==null || compact=='')){
                helper.toastMessage(component,event,"Warning!","Warning","Please enter at least an Individual Std form name, Group Std form name, or Compact form name!");
                return;
            }
            //else
            //{
                if(individualStd!=undefined && individualStd !=null && individualStd !='')
                {
                    if(!(IndividualStdDes!=undefined && IndividualStdDes!=null && IndividualStdDes!=''))
                    {
                        helper.toastMessage(component,event,"Warning!","Warning","Please Enter Individual Description!");
                        return;  
                    }
                }
                
                if(groupStd!=undefined && groupStd!=null && groupStd!='') {
                    if(!(GroupStdDes!=undefined && GroupStdDes!=null && GroupStdDes!='')){
                        helper.toastMessage(component,event,"Warning!","Warning","Please Enter Group Description!");
                        return;
                    }
                }
                
                if(compact!=undefined && compact!=null && compact!=''){
                    if(!(CompactStdDes!=undefined && CompactStdDes!=null && CompactStdDes!='')){
                        helper.toastMessage(component,event,"Warning!","Warning","Please Enter Compact Description!");
                        return;
                    }
                }
               
            //}
        }
        if(isIndividualStdExist){
            helper.toastMessage(component,event,"Warning!","Warning","Please Change Individual Std Form Name!");
            return;
        }
        if(isGroupStdExist){
            helper.toastMessage(component,event,"Warning!","Warning","Please Change Group Std Form Name!");
            return;
        }
        if(isCompactExist){
            helper.toastMessage(component,event,"Warning!","Warning","Please Change Compact Form Name!");
            return;
        }
        
        if(isSTRecordPolicyFormExist){
            helper.toastMessage(component,event,"Warning!","Warning","Please Change State Variation Policy Form Name!");
            return;
        }
        if(policyFormType=='Other'){
            var otherType = component.get('v.otherType');
             if(otherType==undefined || otherType==null || otherType==''){
                 helper.toastMessage(component,event,"Warning!","Warning","Other Type is a mandatory field!");
                 return;
             }
        }
        
        if(!helper.duplicateCheck(validationData,component.get("v.individualStd")))
            validationData[helper.trimData(component.get("v.individualStd"))]="true";
        if(!helper.duplicateCheck(validationData,component.get("v.groupStd")))
            validationData[helper.trimData(component.get("v.groupStd"))]="true";
        if(!helper.duplicateCheck(validationData,component.get("v.compact")))
            validationData[helper.trimData(component.get("v.compact"))]="true";
        else
            hasDuplicateName=true;
        var stateVariance=component.get("v.stateVarianceList");
        for(var i=0;i<stateVariance.length;i++){
            if(!helper.duplicateCheck(validationData,stateVariance[i].policyFormName))
                validationData[helper.trimData(stateVariance[i].policyFormName)]="true";
            else
                hasDuplicateName=true;
        }
        if(hasDuplicateName) 
        {
            errorTitle = "Warning!";
            errorType = "Warning";
            errorMsg = "Policy form name must be unique.";
            helper.toastMessage(component,event,errorTitle,errorType,errorMsg);
            return;
        }   
        helper.submitDetail(component); 
    },
    isPrimarySelected :function(component, event, helper){
        var isPrimaryInd = document.getElementById('isPrimaryInd').checked;
        var isPrimaryStd =  document.getElementById('isPrimaryStd').checked;
        if(isPrimaryInd){
            if(isPrimaryStd)
                document.getElementById("isPrimaryStd").checked = false;
        }
        if(isPrimaryStd){
            if(isPrimaryInd)
                document.getElementById("isPrimaryInd").checked = false;
        }
     },
    isIndividualStdChange:function(component, event, helper){
        var formName = component.get('v.individualStd');
        helper.isDuplicateFormGeneratedhelper(component, event,formName,'individualStd');
    },
    isGroupStdChange:function(component, event, helper){
        var formName = component.get('v.groupStd');
        helper.isDuplicateFormGeneratedhelper(component, event,formName,'groupStd');
    },
    isCompactChange:function(component, event, helper){
        var formName = component.get('v.compact');
        helper.isDuplicateFormGeneratedhelper(component, event,formName,'compact');
    },
    isSTRecordFormChange:function(component, event, helper){
        var formName = component.get('v.STRecord.policyFormName');
        helper.isDuplicateFormGeneratedhelper(component, event,formName,'STRecordPolicyForm');
    },
})
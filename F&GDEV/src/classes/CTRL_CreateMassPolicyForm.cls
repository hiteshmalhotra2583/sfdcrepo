public class CTRL_CreateMassPolicyForm {
    
    
    public static final String GROUP_SUFFIX = ' - GRP ';
    public static final String FIA_TYPE = 'FIA';
    public static final String BLANK_STRING = '';
    public static final String IUL_TYPE = 'IUL';
    public static final String MYGA_TYPE = 'MYGA';
    public static final String INDIVIUAL = 'Individual Filing';
    public static final String STATE_INDIVIUAL = 'StateIndividual';
    public static final String STATE_GROUP_TYPE = 'StateGroup';
    public static final String GROUP_TYPE = 'Group';
    public static final String GROUP_FILING_TYPE = 'Group Filing';
    public static final String GROUP_DEPENDENT_TYPE = 'Group Dependent';
    public static final String COMPACT_TYPE = 'Compact';
    public static final String COMPACTFILING_TYPE = 'Compact Filing';
    public static final String POLICY_STATE_IC = 'IC';
    public static Map<String, Policy_Form_Detail__c> policyTypeKeyPolicyFormvalue;
    public static Map<String, String> stateKeyPolicyTypeValue = new Map<String, String>();
    public static Map<String,ResponseWrapper> responseWrapperValue = new Map<String, ResponseWrapper>();
    
   @AuraEnabled
    public static  List<ResponseWrapper>  createPolicyFormRecords(String insuranceType, String policyFormType, 
                                                                  String otherType, String individualStd, String groupStd,
                                                                  String compact, String stateVariationWrapper,
                                                                  String selectedDefaultFillingStrategy,Boolean isPrimaryInd,
                                                                  Boolean isPrimaryCompact,String individualStdDes,
                                                                  String groupStdDes,String compactStdDes)
     {
        List<StateVariationFormWrapper> stateVariationWrappers;
        if(stateVariationWrapper!=null)
        {
            stateVariationWrappers=(List<StateVariationFormWrapper> )JSON.deserialize(stateVariationWrapper,
            														 List<StateVariationFormWrapper>.class);
        }
        
        List<Policy_Form_Detail__c> finalpolicyFormDetails = new List<Policy_Form_Detail__c>();
        List<Policy_Form_Detail__c> policyFormDetails = new List<Policy_Form_Detail__c>();
        policyTypeKeyPolicyFormvalue  = new Map<String, Policy_Form_Detail__c>();
        
        Policy_Form_Detail__c primaryPolicyFormDetails = null;
        Policy_Form_Detail__c indivialFrom = null;
        Policy_Form_Detail__c groupForm = null;
        Policy_Form_Detail__c compactForm = null;
        boolean flagCreateIC = false;
        //Map<String,Policy_Form_Detail__c> icPolicyformMap = new Map<String,Policy_Form_Detail__c>();
        if(isPrimaryInd && ! String.isBlank(individualStd) && ! String.isBlank(individualStdDes))
        {
            primaryPolicyFormDetails = createPolicyFormDetail(insuranceType,policyFormType,otherType,
            												  individualStd,individualStdDes,isPrimaryInd,null);
        }
        else if (isPrimaryCompact && !String.isBlank(compact) && !String.isBlank(compactStdDes))
        {
            primaryPolicyFormDetails = createPolicyFormDetail(insuranceType,policyFormType,otherType,
            												  compact,compactStdDes,isPrimaryCompact,null);
        }
        
        if( primaryPolicyFormDetails != null)
        insert primaryPolicyFormDetails;
        
        finalpolicyFormDetails.add(primaryPolicyFormDetails);
        
        if(isPrimaryInd && ! String.isBlank(individualStd))
        {
            policyTypeKeyPolicyFormvalue.put(INDIVIUAL,primaryPolicyFormDetails);
        }
        else if( !isPrimaryInd && ! String.isBlank(individualStd) && ! String.isBlank(individualStdDes))
        {
            indivialFrom = createPolicyFormDetail(insuranceType,policyFormType,otherType,
            									  individualStd,individualStdDes,isPrimaryInd,primaryPolicyFormDetails);
            policyTypeKeyPolicyFormvalue.put(INDIVIUAL,indivialFrom);
            policyFormDetails.add(indivialFrom);
            
        }
        
         if(!String.isBlank(groupStd) && !String.isBlank(groupStdDes))
        {
            if(individualStd == groupStd)
            groupStd = groupStd+GROUP_SUFFIX;
            
            groupForm = createPolicyFormDetail(insuranceType,policyFormType,otherType,
            								   groupStd,groupStdDes,false,primaryPolicyFormDetails);
            policyTypeKeyPolicyFormvalue.put(GROUP_TYPE,groupForm);
            policyFormDetails.add(groupForm);
        }
        
        if(isPrimaryCompact && ! String.isBlank(compact))
        {
            policyTypeKeyPolicyFormvalue.put(COMPACT_TYPE,primaryPolicyFormDetails);
            flagCreateIC = true;
        }
        else if( !isPrimaryCompact && ! String.isBlank(compact)&& !String.isBlank(compactStdDes))
        {
            compactForm = createPolicyFormDetail(insuranceType,policyFormType,otherType,
            									 compact,compactStdDes,isPrimaryCompact,primaryPolicyFormDetails);
            policyTypeKeyPolicyFormvalue.put(COMPACT_TYPE,compactForm);
            policyFormDetails.add(compactForm);
            flagCreateIC = true;
        }
        
        Map<String, Policy_Form_Detail__c> stateVariationPolicyTypeKeyPolicyFormvalue = new Map<String, Policy_Form_Detail__c>();
        Map<String, String> stateVariationPolicyNameKeyFillingstrategyTypeValue = new Map<String, String>();
        if(null != stateVariationWrappers)
        {
            for(StateVariationFormWrapper sVWrapper : stateVariationWrappers)
            {
                stateVariationPolicyTypeKeyPolicyFormvalue.put(sVWrapper.policyFormName, createPolicyFormDetail(insuranceType,policyFormType,
                                                                                        otherType,sVWrapper.policyFormName,
                                                                                        sVWrapper.description,false,primaryPolicyFormDetails));
                stateVariationPolicyNameKeyFillingstrategyTypeValue.put(sVWrapper.policyFormName,sVWrapper.fillingType);
            }
        }
        policyFormDetails.addAll(stateVariationPolicyTypeKeyPolicyFormvalue.values());
        
        insert policyFormDetails;
        finalpolicyFormDetails.addAll(policyFormDetails);
        
        List<Filing_Status__c> filingStatuss = null;
        Map<String, String > statesMaps = getAllStateMap();
        Map<String, String > statesKeyStateNameValueMap = getAllstatesKeyStateNameValueMap();
        filingStatuss = createStateVariationFillingStatusRecords(stateVariationWrappers,stateVariationPolicyTypeKeyPolicyFormvalue,statesMaps);
        
        Map<String, Filing_Strategy__c> mapFillingStrategyMap  = null;
        
        if(selectedDefaultFillingStrategy == FIA_TYPE)
        {
            mapFillingStrategyMap = DAL_FilingStrategy.getFIAFillingStrategyRecords();
            filingStatuss.addAll(createFillingStatusRecord(mapFillingStrategyMap, FIA_TYPE,statesKeyStateNameValueMap)); 
        }
        else if(selectedDefaultFillingStrategy == IUL_TYPE)
        {
            mapFillingStrategyMap = DAL_FilingStrategy.getIULFillingStrategyRecords();  
            filingStatuss.addAll(createFillingStatusRecord(mapFillingStrategyMap, IUL_TYPE,statesKeyStateNameValueMap)); 
        }
        else if(selectedDefaultFillingStrategy == MYGA_TYPE)
        {
            mapFillingStrategyMap = DAL_FilingStrategy.getMYGAFillingStrategyRecords(); 
            filingStatuss.addAll(createFillingStatusRecord(mapFillingStrategyMap, MYGA_TYPE,statesKeyStateNameValueMap));  
        } 
        
        return createResponseWrapper(filingStatuss,finalpolicyFormDetails,flagCreateIC);
     }
     
    public static List<ResponseWrapper>  createResponseWrapper(List<Filing_Status__c> filingStatuss, 
    														   List<Policy_Form_Detail__c> policyFormDetails,
    														   Boolean flagCreateIC)
    {
        List<ResponseWrapper> responseWrappers = new List<ResponseWrapper> ();
        ResponseWrapper rW = null;
        Map<String, List<Approach>> stateKeyResponseWrapperValue = new Map<String, List<Approach>>();
        List<Approach> lstApproach;
        for(Filing_Status__c f: filingStatuss)
        {
            Approach approach = new Approach();
            approach.ApproachName = f.Filing_Strategy__c;
            approach.fs= f;
            
            if(stateKeyResponseWrapperValue.containsKey(f.State__c))
            {
                lstApproach = stateKeyResponseWrapperValue.get(f.State__c);
            }
            else
            {
                lstApproach = new List<Approach>();
            }
            lstApproach.add(approach);
            stateKeyResponseWrapperValue.put(f.State__c,lstApproach);
        }
        
        if(flagCreateIC)
        {
        	Approach approach2 = new Approach();
            approach2.ApproachName = COMPACTFILING_TYPE;
            approach2.fs = createFillingStatusRecords(policyTypeKeyPolicyFormvalue.get(COMPACT_TYPE),
                                                      POLICY_STATE_IC,COMPACTFILING_TYPE);
                                                     
            List<Approach> lstApproach2 = new List<Approach>();  
            lstApproach2.add(approach2);
            stateKeyResponseWrapperValue.put('IC',lstApproach2);                                      
        }
       
        List<String> statekeys = new List<String>(stateKeyResponseWrapperValue.keySet());
        statekeys.sort();
        
        for(String state:statekeys)
        {
            rW=new ResponseWrapper();
            rW.state = state;
            rW.approach = stateKeyResponseWrapperValue.get(state);
            rW.policyFormDetail = policyFormDetails;
            responseWrappers.add(rW);
        }

        return responseWrappers;
    }
    
    public static List<Filing_Status__c> createStateVariationFillingStatusRecords(List<StateVariationFormWrapper> stateVariationWrappers,
                                                                                  Map<String, Policy_Form_Detail__c> stateVariationPolicyTypeKeyPolicyFormvalue,
                                                                                  Map<String,String> stateMap)
    {
        List<Filing_Status__c> filingStatuss = new List<Filing_Status__c>();
        if( null != stateVariationWrappers)
        {
            for(StateVariationFormWrapper sVW: stateVariationWrappers)
            {
                if( null != sVW.selectedStates)
                {
                    for(String selectedStates : sVW.selectedStates.split(';'))
                    {
                        filingStatuss.add(createFillingStatusRecords(stateVariationPolicyTypeKeyPolicyFormvalue.get(sVW.policyFormName),
                                                                      stateMap.get(selectedStates.toUpperCase()),sVW.fillingType));
                        stateKeyPolicyTypeValue.put(stateMap.get(selectedStates.toUpperCase()),sVW.fillingType);
                    }
                }
            }
        }
        return filingStatuss;
    } 
     
     
    public static List<Filing_Status__c>  createFillingStatusRecord(Map<String, Filing_Strategy__c> mapFillingStrategyMap,
                                                  String defaultFillingStrategyType,
                                                  Map<String,String> stateMap)
    {
        List<Filing_Status__c> filingStatuss = new List<Filing_Status__c>();
        
        for(Filing_Strategy__c fs: mapFillingStrategyMap.values())
        {
            if(defaultFillingStrategyType == FIA_TYPE)
            {
                if( null != fs.FIA_Filing_Strategy_1__c)
                {
                    
                    createFilingStatusRecord(fs.FIA_Filing_Strategy_1__c,fs.Name,filingStatuss,stateMap);
                }
                
                if( null != fs.FIA_Filing_Strategy_2__c)
                {
                    createFilingStatusRecord(fs.FIA_Filing_Strategy_2__c,fs.Name,filingStatuss,stateMap);
                }
                
            }
            else if(defaultFillingStrategyType == IUL_TYPE)
            {
                
                if( null != fs.IUL_Filing_Strategy_1__c)
                {
                    createFilingStatusRecord(fs.IUL_Filing_Strategy_1__c,fs.Name,filingStatuss,stateMap);
                }
                
                if( null != fs.IUL_Filing_Strategy_2__c)
                {
                    createFilingStatusRecord(fs.IUL_Filing_Strategy_1__c,fs.Name,filingStatuss,stateMap);
                }
            }
            else if(defaultFillingStrategyType == MYGA_TYPE)
            {
                if( null != fs.MYGA_Filing_Strategy_1__c)
                {
                    createFilingStatusRecord(fs.MYGA_Filing_Strategy_1__c,fs.Name,filingStatuss,stateMap);
                }
                
                if( null != fs.MYGA_Filing_Strategy_2__c)
                {
                    createFilingStatusRecord(fs.MYGA_Filing_Strategy_2__c,fs.Name,filingStatuss,stateMap);
                }
            }   
        }
        return filingStatuss;
    }
    
    
    
    
    public static void createFilingStatusRecord(String FilingStrategyType,
                                                String fsName,
                                                List<Filing_Status__c> filingStatuss,
                                                Map<String,String> stateMap)
    {
        String filingType  = FilingStrategyType;
        if(filingType.contains(INDIVIUAL))
        filingType = INDIVIUAL;
        if(filingType.contains(GROUP_TYPE))
        filingType = GROUP_TYPE;
        if(filingType.contains(COMPACT_TYPE))
        filingType = COMPACT_TYPE;
    
        if(filingType.contains(INDIVIUAL) 
            && stateKeyPolicyTypeValue.get(stateMap.get(fsName)) != INDIVIUAL
            && null != policyTypeKeyPolicyFormvalue.get(INDIVIUAL))
            filingStatuss.add(createFillingStatusRecords(policyTypeKeyPolicyFormvalue.get(INDIVIUAL), 
            											 stateMap.get(fsName),FilingStrategyType));
        
        if(filingType.contains(GROUP_TYPE) 
            && stateKeyPolicyTypeValue.get(stateMap.get(fsName)) != GROUP_FILING_TYPE
            && null != policyTypeKeyPolicyFormvalue.get(GROUP_TYPE) )
        
        filingStatuss.add(createFillingStatusRecords(policyTypeKeyPolicyFormvalue.get(GROUP_TYPE),
        											 stateMap.get(fsName),FilingStrategyType));
        
        if(filingType.contains(COMPACT_TYPE) 
            && null != policyTypeKeyPolicyFormvalue.get(COMPACT_TYPE))
        
        filingStatuss.add(createFillingStatusRecords(policyTypeKeyPolicyFormvalue.get(COMPACT_TYPE),
        											 stateMap.get(fsName),FilingStrategyType));
    }
    
    
    
    @AuraEnabled
    // create Policy Form Status records 
    public static void createFilingStatus(String FilingStatusDetail,String insuranceType, String policyFormType,String otherType)
    {
        List<ResponseWrapper> FilingStatus;
        if(null != FilingStatusDetail)
        {
            FilingStatus=(List<ResponseWrapper> )JSON.deserialize(FilingStatusDetail, List<ResponseWrapper>.class);
        }
        //upsert policyFormDetails;
        List<Filing_Status__c> lstFilingStatus=new List<Filing_Status__c>();
        for(ResponseWrapper  FilingData :FilingStatus){
            for(Approach approach:FilingData.approach){
                if(! String.isBlank(approach.ApproachName)){
                    lstFilingStatus.add(createFillingStatusRecords(new Policy_Form_Detail__c(Name=approach.formName,Id=approach.formId),
                                                                   FilingData.state, approach.ApproachName));
                }
            }
        }
        
        if(lstFilingStatus!=null 
          && lstFilingStatus.size()>0)
        {
            insert lstFilingStatus;
        }
        
    }
    // delete the Policy_Form_Detail records 
    @AuraEnabled
    public static void deletePolicyForm(String policyForms)
    {   
        if(null != policyForms)
        {
            List<Policy_Form_Detail__c> policyFormDetails = (List<Policy_Form_Detail__c> )JSON.deserialize(policyForms, List<Policy_Form_Detail__c>.class);
            delete policyFormDetails;
        }
        return ;
    }
    
    // create the Policy_Form_Detail records 
    public static Policy_Form_Detail__c createPolicyFormDetail(String insuranceType, String policyFormType,
                                                                String otherType, String Name,
                                                                String description, Boolean isPrimary,
                                                                Policy_Form_Detail__c  primaryPolicyFormDetails)
    {
        Policy_Form_Detail__c policyFormDetail = new Policy_Form_Detail__c();
        policyFormDetail.Insurance_Type__c = insuranceType;
        policyFormDetail.Policy_Form_Type__c = policyFormType;
        policyFormDetail.Policy_Form_Type_Other__c = otherType;
        policyFormDetail.Name = Name;
        policyFormDetail.Policy_Form_Description__c = description;
        policyFormDetail.Is_Primary__c = isPrimary;
        if(primaryPolicyFormDetails != null)
        policyFormDetail.Related_Policy_Form__c = primaryPolicyFormDetails.Id;
        return policyFormDetail;
    }
    
    
    // create the filling status records 
    public static Filing_Status__c createFillingStatusRecords(Policy_Form_Detail__c pFD,
                                                             String stateName,
                                                             String fillingStrategy)
    {
        Filing_Status__c fs = new Filing_Status__c();
        fs.Policy_Form__c = pFD.Id;
        fs.Name = pFD.Name+'-'+stateName;
        fs.Filing_Strategy__c = fillingStrategy;
        fs.State__c =  stateName;
        return fs;
    }
    
    public static Map<String, String> getAllStateMap()
    {
        Map<String, String> nameKeyValueMap = new Map<String, String>();
        List<State__c> lstStates = State__c.getAll().values();
        lstStates.sort();
        for(State__c state : lstStates)
        {
            nameKeyValueMap.put(state.StateCode__c,state.StateCode__c);
        }
        
        return nameKeyValueMap;
    }
    
    
    public static Map<String, String> getAllstatesKeyStateNameValueMap()
    {
        Map<String, String> nameKeyValueMap = new Map<String, String>();
        for(State__c state : State__c.getAll().values())
        {
            nameKeyValueMap.put(state.Name,state.StateCode__c);
        }
        
        return nameKeyValueMap;
    }
   
    @AuraEnabled
    public static Boolean duplicateFormGenerated(String formName){
        
        Map<String,String> response = new Map<String,String>(); 
        
        List<Policy_Form_Detail__c> policyFormDetails = DAL_PolicyFormDetail.getByName(formName);
        if(policyFormDetails.size()>0)
        {
            return true;
        }
        return false;
    }
    
    @AuraEnabled
    public static Map<String,String> getselectOptions(String getFrom,String objectName,String  methodOrFieldName){
        Map<String,String> allOpts = new Map<String,String>();
        if(getFrom!=null && getFrom=='object'){
            if(Schema.getGlobalDescribe().containsKey(objectName)){
                // Get the object type of the SObject.
                Schema.sObjectType objType = Schema.getGlobalDescribe().get(objectName);
                // Describe the SObject using its object type.
                Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
                // Get a map of fields for the SObject
                map<String, Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
                // Get the list of picklist values for this field.
                list<Schema.PicklistEntry> values = fieldMap.get(methodOrFieldName).getDescribe().getPickListValues();
                // Add these values to the selectoption list.
                for(Schema.PicklistEntry a: values){
                    allOpts.put(a.getLabel(),a.getValue());
                }
            }
        }
        if(getFrom!=null && getFrom=='method')
        {
            if(methodOrFieldName!=null && methodOrFieldName=='getState')
            {
                return CTRL_CreateMassPolicyForm.getAllStateMap();
            }
            else if(methodOrFieldName!=null && methodOrFieldName=='fillingType')
            {
                allOpts.put('Individual Filing','Individual Filing');
                allOpts.put('Group Filing','Group Filing');
            }
            
        }
        return allOpts;
        
    }
    public class StateVariationFormWrapper
    {
        @AuraEnabled
        public String policyFormName;
        @AuraEnabled
        public String fillingType;
        @AuraEnabled
        public String description;
        @AuraEnabled
        public String selectedStates;
    }
    
    public class ResponseWrapper
    {
        @AuraEnabled
        public List<Approach> approach ;
        @AuraEnabled
        Public List<Policy_Form_Detail__c> policyFormDetail;
        @AuraEnabled
        public String state;
    }
    
    public class Approach
    {
        @AuraEnabled
        public String ApproachName;
        @AuraEnabled
        public String formName;
        @AuraEnabled
        public String formId;
       @AuraEnabled
        public Filing_Status__c fs;
    }

}
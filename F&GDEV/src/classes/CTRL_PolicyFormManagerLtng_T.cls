@isTest
private class CTRL_PolicyFormManagerLtng_T {
    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<State__c> stateList = new List<State__c>();
    public static List<Project__c> projectList = new List<Project__c>();
    public static List<State_Availability__c>  stateAvailabilityList = new List<State_Availability__c>();
    public static List<Product_Specification__c>  productSpecifications = new List<Product_Specification__c>();
    public static List<Filing_Status__c> filingStatus = new List<Filing_Status__c>();
    public static List<Policy_Form_Detail__c> policyForms = new List<Policy_Form_Detail__c>();
    public static List<Project_Policy__c> projectPolicyList = new List<Project_Policy__c>();
    public static List<Product_State_Status__c> pssList = new List<Product_State_Status__c>();
    
    static void initStateRecs(){
        stateList = new List<State__c>();
        stateList.add(new State__c(Name='Alaska',StateCode__c = 'AK'));
        stateList.add(new State__c(Name='Alabama',StateCode__c = 'AL'));
        stateList.add(new State__c(Name='Arkansas',StateCode__c = 'AR'));
        stateList.add(new State__c(Name='Arizona',StateCode__c = 'AZ'));
        stateList.add(new State__c(Name='California',StateCode__c = 'CA'));
        stateList.add(new State__c(Name='Colorado',StateCode__c = 'CO'));
        stateList.add(new State__c(Name='Connecticut',StateCode__c = 'CT'));
        stateList.add(new State__c(Name='District of Columbia',StateCode__c = 'DC'));
        stateList.add(new State__c(Name='Delaware',StateCode__c = 'DE'));
        stateList.add(new State__c(Name='Florida',StateCode__c = 'FL'));
        stateList.add(new State__c(Name='Georgia',StateCode__c = 'GA'));
        stateList.add(new State__c(Name='Hawaii',StateCode__c = 'HI'));
        stateList.add(new State__c(Name='Iowa',StateCode__c = 'IA'));
        stateList.add(new State__c(Name='Idaho',StateCode__c = 'ID'));
        stateList.add(new State__c(Name='Illinois',StateCode__c = 'IL'));
        stateList.add(new State__c(Name='Indiana',StateCode__c = 'IN'));
        stateList.add(new State__c(Name='Kansas',StateCode__c = 'KS'));
        stateList.add(new State__c(Name='Kentucky',StateCode__c = 'KY'));
        stateList.add(new State__c(Name='Louisiana',StateCode__c = 'LA'));
        stateList.add(new State__c(Name='Massachusetts',StateCode__c = 'MA'));
        stateList.add(new State__c(Name='Maryland',StateCode__c = 'MD'));
        stateList.add(new State__c(Name='Maine',StateCode__c = 'ME'));
        stateList.add(new State__c(Name='Michigan',StateCode__c = 'MI'));
        stateList.add(new State__c(Name='Minnesota',StateCode__c = 'MN'));
        stateList.add(new State__c(Name='Missouri',StateCode__c = 'MO'));
        stateList.add(new State__c(Name='Mississippi',StateCode__c = 'MS'));
        stateList.add(new State__c(Name='Montana',StateCode__c = 'MT'));
        stateList.add(new State__c(Name='North Carolina',StateCode__c = 'NC'));
        stateList.add(new State__c(Name='North Dakota',StateCode__c = 'ND'));
        stateList.add(new State__c(Name='Nebraska',StateCode__c = 'NE'));
        stateList.add(new State__c(Name='New Hampshire',StateCode__c = 'NH'));
        stateList.add(new State__c(Name='New Jersey',StateCode__c = 'NJ'));
        stateList.add(new State__c(Name='New Mexico',StateCode__c = 'NM'));
        stateList.add(new State__c(Name='Nevada',StateCode__c = 'NV'));
        stateList.add(new State__c(Name='New York',StateCode__c = 'NY'));
        stateList.add(new State__c(Name='Ohio',StateCode__c = 'OH'));
        stateList.add(new State__c(Name='Oklahoma',StateCode__c = 'OK'));
        stateList.add(new State__c(Name='Oregon',StateCode__c = 'OR'));
        stateList.add(new State__c(Name='Pennsylvania',StateCode__c = 'PA'));
        stateList.add(new State__c(Name='Rhode Island',StateCode__c = 'RI'));
        stateList.add(new State__c(Name='South Carolina',StateCode__c = 'SC'));
        stateList.add(new State__c(Name='South Dakota',StateCode__c = 'SD'));
        stateList.add(new State__c(Name='Tennessee',StateCode__c = 'TN'));
        stateList.add(new State__c(Name='Texas',StateCode__c = 'TX'));
        stateList.add(new State__c(Name='Utah',StateCode__c = 'UT'));
        stateList.add(new State__c(Name='Virginia',StateCode__c = 'VA'));
        stateList.add(new State__c(Name='Vermont',StateCode__c = 'VT'));
        stateList.add(new State__c(Name='Washington',StateCode__c = 'WA'));
        stateList.add(new State__c(Name='Wisconsin',StateCode__c = 'WI'));
        stateList.add(new State__c(Name='West Virginia',StateCode__c = 'WV'));
        stateList.add(new State__c(Name='Wyoming',StateCode__c = 'WY'));
        
        insert stateList;
    }
    
    static void testData(){
        admin_User = TestDataFactory.createUser(true,'',SYSTEM_ADMINISTRATOR_PROFILE);
        insert admin_User;
        System.runAs(admin_User){
            
            Date todayDate = System.today() + 5;
            Integer recNum = 10;
            //Insert Project
            Project__c project = (Project__c)SmartFactory.createSObject('Project__c');
            projectList.add(project);
            insert projectList; 
            Id projectId = projectList[0].Id;
            
            Map<String,Object> productSpecificationMap = new Map<String,Object>();
            productSpecificationMap.put('Product_Type__c','Fixed Deferred Annuity');
            productSpecificationMap.put('Project__c',projectId);
            //Insert product specification
            for(Integer i = 0 ; i <count; i++){
                productSpecifications.add((Product_Specification__c) TestDataFactory.operationOnObjectRecord(null, 'Product_Specification__c', productSpecificationMap));
            }
            insert productSpecifications; 
            Id productSpecificationsId = productSpecifications[0].Id;
            
            //Insert State Availability
            Map<String,Object>  stateAvailabilityMap = new Map<String,Object>();
            stateAvailabilityMap.put('State__c','AK');
            stateAvailabilityMap.put('Status__c','Approved');
            stateAvailabilityMap.put('Product_Specification__c',productSpecificationsId);
            stateAvailabilityMap.put('Policy_Print_1_End__c',todayDate);
            stateAvailabilityMap.put('Policy_Print_1_Start__c',todayDate);
            stateAvailabilityMap.put('Policy_Print_2_End__c',todayDate);
            stateAvailabilityMap.put('Policy_Print_2_Start__c',todayDate);
            for(Integer i = 0 ; i <count; i++){
                stateAvailabilityList.add((State_Availability__c) TestDataFactory.operationOnObjectRecord(null, 'State_Availability__c', stateAvailabilityMap));
            }
            insert stateAvailabilityList; 
          
            //Insert policy form details
            Map<String,Object>  policyFormsMap = new Map<String,Object>();
            policyFormsMap.put('Insurance_Type__c','Life');
            policyFormsMap.put('Filing_Strategy__c','Individual');
            policyFormsMap.put('Status__c','Active');
            for(Integer i = 0 ; i <count; i++){
                policyForms.add((Policy_Form_Detail__c) TestDataFactory.operationOnObjectRecord(null, 'Policy_Form_Detail__c', policyFormsMap));
            }
            Integer ii = 0;
            for(Policy_Form_Detail__c policyform : policyForms){
                policyform.Name = 'Policy Spec Name ' + ii;
                ii += 1;
            }
            insert policyForms; 
            
            Map<String,Object> projectPolicyMap = new Map<String,Object>();
            projectPolicyMap.put('Policy_Form__c',policyForms[0].Id);
            projectPolicyMap.put('Project__c',projectList[0].Id);
            //Insert Project Policy 
            for(Integer i = 0 ; i <count; i++){
                projectPolicyList.add((Project_Policy__c) TestDataFactory.operationOnObjectRecord(null, 'Project_Policy__c', projectPolicyMap));
            }
            insert projectPolicyList;
            
            //Insert felling status
            Map<String,Object> filingStatusMap = new Map<String,Object>();
            filingStatusMap.put('Policy_Form__c',policyForms[0].Id);
            filingStatusMap.put('State__c','Al');
            filingStatusMap.put('Form_Variation_Description__c','testDescription');
            filingStatusMap.put('Feature_Variation_Description__c','testFeatureDescription');
            filingStatusMap.put('Filing_Strategy__c','Group Dependent');
            for(Integer i = 0 ; i <count; i++){
                filingStatus.add((Filing_Status__c) TestDataFactory.operationOnObjectRecord(null, 'Filing_Status__c', filingStatusMap));
            }
            insert filingStatus; 
            
            for(State_Availability__c stateavail : stateAvailabilityList){
                for(Filing_Status__c filingstat : filingStatus){
                    pssList.add(new Product_State_Status__c(Filing_Status__c=filingStatus[0].Id, Product_State_Availability__c = stateAvailabilityList[0].Id));
                }
            }
            insert pssList;
        } 
        
    }
    
    static testMethod void testAllMethods() {
        
        testData();
        initStateRecs();
        //	W_Policy
        W_Policy policywrappr = new W_Policy(policyForms[0], filingStatus[0]);
        policywrappr.UISelected = true;
        
        //	W_PolicyFormStateAggr
        W_PolicyFormStateAggregateLtng policyformstateaggr = new W_PolicyFormStateAggregateLtng();
        policyformstateaggr.Fields.add('Expected_Next_Response_Date__c');
        policyformstateaggr.AddPolicyFormState(policywrappr, 'AK', policywrappr.Id);
        policyformstateaggr.isEditedMap.put('Expected_Next_Response_Date__c', true);
        policyformstateaggr.FieldTypeMap.put('Expected_Next_Response_Date__c', 'DATE');
        policyformstateaggr.FieldValueMap.put('Expected_Next_Response_Date__c', '12032019');
        policyformstateaggr.PolicyFormStateIds.add(policywrappr.FilingStatusId);
        
        Test.startTest();
        List<Id> policyFormsIds  = new List<Id>();
        for(Policy_Form_Detail__c policyForm:policyForms) {
            policyFormsIds.add(policyForm.id);
        }
        String projectId = projectList[0].Id;
        Id fillingStatusId =filingStatus[0].Id;
        
        //String statepolicymapstr = JSON.serialize(policyformstateaggr);
        String statepolicymapstr = '{ "PA":{ "a0aC000000En5vYIAR":{ "UISelected":false, "StatusDate":null, "Status":"Not Started", "Name":"FGL TI 1 (2003)", "Id":"a0aC000000En5vYIAR", "FormName":null, "FilingStatusObj":{ "attributes":{ "type":"Filing_Status__c", "url":"" }, "Policy_Form__c":"a0aC000000En5vYIAR", "Id":"a0TC000000QjzsNMAR", "State__c":"PA", "Filing_Status__c":"Not Started" }, "FilingStatusId":"a0TC000000QjzsNMAR", "FilingStatusAvailId":null }, "a0aC000000En5o1IAB":{ "UISelected":false, "StatusDate":"9/11/2011", "Status":"Filed", "Name":"2011 Annual Life Illustration Certification Filing", "Id":"a0aC000000En5o1IAB", "FormName":null, "FilingStatusObj":{ "attributes":{ "type":"Filing_Status__c", "url":"" }, "Policy_Form__c":"a0aC000000En5o1IAB", "Id":"a0TC000000L5bTFMAZ", "State__c":"PA", "Filing_Status__c":"Filed", "Filing_Followup_Date__c":"2011-09-11", "State_Approval_Date__c":"2011-08-11", "Submitted_to_State_Date__c":"2011-06-23", "Objection_Received_Date__c":"2011-07-29", "Objection_Response_Date__c":"2011-08-11", "Filing_Notes_Status_Notes__c":"objection forwarded to actuarial 7-29-2011" }, "FilingStatusId":"a0TC000000L5bTFMAZ", "FilingStatusAvailId":null } }, "NY":{ "a0aC000000En5sKIAR":{ "UISelected":false, "StatusDate":null, "Status":"Not Filing", "Name":"OM PTP2 2008", "Id":"a0aC000000En5sKIAR", "FormName":null, "FilingStatusObj":{ "attributes":{ "type":"Filing_Status__c", "url":"" }, "Policy_Form__c":"a0aC000000En5sKIAR", "Id":"a0TC000000L5a78MAB", "State__c":"NY", "Filing_Status__c":"Not Filing" }, "FilingStatusId":"a0TC000000L5a78MAB", "FilingStatusAvailId":null } }, "PR":{ "a0aC000000En5sKIAR":{ "UISelected":false, "StatusDate":null, "Status":"Not Filing", "Name":"OM PTP2 2008", "Id":"a0aC000000En5sKIAR", "FormName":null, "FilingStatusObj":{ "attributes":{ "type":"Filing_Status__c", "url":"" }, "Policy_Form__c":"a0aC000000En5sKIAR", "Id":"a0TC000000L5a76MAB", "State__c":"PR", "Filing_Status__c":"Not Filing" }, "FilingStatusId":"a0TC000000L5a76MAB", "FilingStatusAvailId":null }, "a0aC000000En5sJIAR":{ "UISelected":false, "StatusDate":null, "Status":"Not Filing", "Name":"OM MPTP 2008", "Id":"a0aC000000En5sJIAR", "FormName":null, "FilingStatusObj":{ "attributes":{ "type":"Filing_Status__c", "url":"" }, "Policy_Form__c":"a0aC000000En5sJIAR", "Id":"a0TC000000L5a6mMAB", "State__c":"PR", "Filing_Status__c":"Not Filing" }, "FilingStatusId":"a0TC000000L5a6mMAB", "FilingStatusAvailId":null }, "a0aC000000En5pLIAR":{ "UISelected":false, "StatusDate":null, "Status":"Not Started", "Name":"ARI-1006(02-11)", "Id":"a0aC000000En5pLIAR", "FormName":null, "FilingStatusObj":{ "attributes":{ "type":"Filing_Status__c", "url":"" }, "Policy_Form__c":"a0aC000000En5pLIAR", "Id":"a0TC000000L5ah2MAB", "State__c":"PR", "Filing_Status__c":"Not Started" }, "FilingStatusId":"a0TC000000L5ah2MAB", "FilingStatusAvailId":null }, "a0aC000000En5o3IAB":{ "UISelected":false, "StatusDate":null, "Status":"Not Filing", "Name":"2012 Annual Life Illustration Certification Filing", "Id":"a0aC000000En5o3IAB", "FormName":null, "FilingStatusObj":{ "attributes":{ "type":"Filing_Status__c", "url":"" }, "Policy_Form__c":"a0aC000000En5o3IAB", "Id":"a0TC000000L5bGLMAZ", "State__c":"PR", "Filing_Status__c":"Not Filing" }, "FilingStatusId":"a0TC000000L5bGLMAZ", "FilingStatusAvailId":null } } }';
        String prodstatepolicystatmapstr='{ "a0dC000000C9u7kIAB":{ "AZ":{ "a0iC000000BzXPkIAN":{ "StateAvailId":"a0iC000000BzXPkIAN", "PolicytoProdStateStat":{ "a0aC000000En5o2IAB":{ "ProductStateStatusId":"a0e0q000000fGHRAA2", "InsertOrDelete":true, "FilingStatusId":"a0TC000000L5aizMAB" }, "a0a0q000000ZTwiAAG":{ "ProductStateStatusId":"a0e0q000000fFu1AAE", "InsertOrDelete":false, "FilingStatusId":"a0T0q000001OhsxEAC" } } } }, "AK":{ "a0iC000000BzXPjIAN":{ "StateAvailId":"a0iC000000BzXPjIAN", "PolicytoProdStateStat":{ "a0aC000000En5o4IAB":{ "ProductStateStatusId":"a0e0q000000fGGxAAM", "InsertOrDelete":false, "FilingStatusId":"a0TC000000L5YzhMAF" }, "a0a0q000000ZTwiAAG":{ "ProductStateStatusId":"a0e0q000000fFv4AAE", "InsertOrDelete":false, "FilingStatusId":"a0T0q000001OhvDEAS" } } } }, "WY":{ "a0i0q000002Eqt4AAC":{ "StateAvailId":"a0i0q000002Eqt4AAC", "PolicytoProdStateStat":{ "a0aC000000En5o2IAB":{ "ProductStateStatusId":"a0e0q000000fGH3AAM", "InsertOrDelete":false, "FilingStatusId":"a0TC000000L5ajBMAR" } } } } } }';
        
        List<State__c> stateList = CTRL_PolicyFormManagerLtng.getStates();
        CTRL_PolicyFormManagerLtng.getDetails(projectId,'Active');
        CTRL_PolicyFormManagerLtng.getPolicies(policyFormsIds,'Active');
        CTRL_PolicyFormManagerLtng.searchPolicies(policyForms[0].Name);
        CTRL_PolicyFormManagerLtng.saveProjectPolicy(projectId,policyFormsIds);
        CTRL_PolicyFormManagerLtng.getPolicyFormStateAggr(statepolicymapstr);
        CTRL_PolicyFormManagerLtng.saveStatePolicyStatus(statepolicymapstr);
        CTRL_PolicyFormManagerLtng.saveProdStatePolicyStatus(prodstatepolicystatmapstr);
        CTRL_PolicyFormManagerLtng.fillPolicyFormStateObj(fillingStatusId,policyformstateaggr);
        CTRL_PolicyFormManagerLtng.fillPolicyFormStateObj(stateList[0].Id,projectPolicyList[0].Id,policyformstateaggr);
        Test.stopTest();
        
    }
    
    
    static testMethod void testSaveProdStatePolicyStatus(){
        testData();
        initStateRecs();
        Test.startTest();
        //	W_Policy
        W_Policy policywrappr = new W_Policy(policyForms[0], filingStatus[0]);
        policywrappr.UISelected = true;
        
        //	PolicyFormStateAggr
        Map<String, Map<Id, W_Policy>> statepolicymap = new Map<String, Map<Id, W_Policy>>();
        statepolicymap.put('AK', new Map<Id, W_Policy>());
        statepolicymap.get('AK').put(policyForms[0].Id, policywrappr);
        
        String prodspecId = productSpecifications[0].Id;
        Map<Id, Map<String, Map<Id, W_ProdStateAvail>>> prodstatepolicystatmap = new Map<Id, Map<String, Map<Id, W_ProdStateAvail>>>();
        prodstatepolicystatmap.put(prodspecId, new Map<String, Map<Id, W_ProdStateAvail>>());
        for(State_Availability__c stateavail : stateAvailabilityList){
            
            if(!prodstatepolicystatmap.get(prodspecId).containsKey(stateavail.State__c)){
                prodstatepolicystatmap.get(prodspecId).put(stateavail.State__c, new Map<Id, W_ProdStateAvail>());
            }
            
            if(!prodstatepolicystatmap.get(prodspecId).get(stateavail.State__c).containsKey(stateavail.Id)){
                prodstatepolicystatmap.get(prodspecId).get(stateavail.State__c).put(stateavail.Id, new W_ProdStateAvail(stateavail));
            }
            
            Boolean hasProdStateStat = false;
            Boolean hasFilingStat = false;
            
            for(Product_State_Status__c pss : pssList){
                W_ProdStateStatus prodstatestat = new W_ProdStateStatus(pss);
                prodstatestat.InsertOrDelete = true;
                
                if(!hasProdStateStat)prodstatestat.ProductStateStatusId = null;
                hasProdStateStat = !hasProdStateStat;
                
                if(!hasProdStateStat){
                    if(!hasFilingStat)prodstatestat.FilingStatusId = null;
                    hasFilingStat = !hasFilingStat;
                }
                
                prodstatepolicystatmap.get(prodspecId).get(stateavail.State__c).get(stateavail.Id).PolicytoProdStateStat.put(pss.Id, prodstatestat);
            }
            
            break;
        }
        
        String prodstatepolicystatmapstr = JSON.serialize(prodstatepolicystatmap);
        CTRL_PolicyFormManagerLtng.saveProdStatePolicyStatus(prodstatepolicystatmapstr);
        Test.stopTest();
    }
    
}
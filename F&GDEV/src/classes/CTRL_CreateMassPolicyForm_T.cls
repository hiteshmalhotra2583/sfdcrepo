@isTest
private class  CTRL_CreateMassPolicyForm_T {
    
    public static User admin_User;
    public static Integer count =2;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<State__c> stateList = new List<State__c>();
    public static List<Project__c> projectList = new List<Project__c>();
    public static List<State_Availability__c>  stateAvailabilityList = new List<State_Availability__c>();
    public static List<Product_Specification__c>  productSpecifications = new List<Product_Specification__c>();
    public static List<Filing_Status__c> filingStatus = new List<Filing_Status__c>();
    public static List<Policy_Form_Detail__c> policyForms = new List<Policy_Form_Detail__c>();
    public static List<Project_Policy__c> projectPolicyList = new List<Project_Policy__c>();
    public static List<Product_State_Status__c> pssList = new List<Product_State_Status__c>();
    public static List<Filing_Strategy__c> filingStrategys = new List<Filing_Strategy__c>();
    public static List<ResponseWrapper> resWrp = new List<ResponseWrapper>();
    public static List<Approach> app = new List<Approach>();
    
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
            policyFormsMap.put('Policy_Form_Type__c','Application');
            policyFormsMap.put('Policy_Form_Type_Other__c','test123');
            policyFormsMap.put('Name','test123');
            policyFormsMap.put('Policy_Form_Description__c','test123');
            policyFormsMap.put('Is_Primary__c',true);
            // policyFormsMap.put('Related_Policy_Form__c');
            policyFormsMap.put('Filing_Strategy__c','Individual');
            for(Integer i = 0 ; i <count; i++){
                policyForms.add((Policy_Form_Detail__c) TestDataFactory.operationOnObjectRecord(null, 'Policy_Form_Detail__c', policyFormsMap));
            }
            insert policyForms; 
            if(policyForms[1]!=null){
                policyForms[0].Related_Policy_Form__c = policyForms[1].Id;
                update policyForms;
            }
            System.debug('policyForms '+policyForms);
            
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
            
            for(Integer i = 0 ; i <count; i++){
                filingStrategys.add((Filing_Strategy__c) TestDataFactory.operationOnObjectRecord(null, 'Filing_Strategy__c', null));
            }
            insert filingStrategys;
        } 
    }
    
    static testMethod void testAllMethods() {
        
        testData();
        initStateRecs();
        List<CTRL_CreateMassPolicyForm.StateVariationFormWrapper> stateVariationWrappers = new List<CTRL_CreateMassPolicyForm.StateVariationFormWrapper>(); 
        CTRL_CreateMassPolicyForm.StateVariationFormWrapper sVW = new CTRL_CreateMassPolicyForm.StateVariationFormWrapper();
        sVW.policyFormName = 'ARI-1891 (06-19)';
        sVW.fillingType = 'Individual Filing';
        sVW.selectedStates = 'AL;CA;';
        stateVariationWrappers.add(sVW);
        String strWrapper =JSON.serialize(stateVariationWrappers);
        
        Test.startTest();
        String insuranceType=policyForms[0].Insurance_Type__c;
        String policyFormType=policyForms[0].Policy_Form_Type__c;
        String otherType=policyForms[0].Policy_Form_Type_Other__c;
        String individualStd ='ARI-1888 (06-19)';
        String groupStd ='ARI-1888 (06-20)';
        String Name=policyForms[0].Name;
        String selectedDefaultFillingStrategy = 'FIA';
        String selectedDefaultFillingStrategy2 = 'IUL';
        String selectedDefaultFillingStrategy3 = 'MYGA';
        String description=policyForms[0].Policy_Form_Description__c;
        String individualStdDes = 'testDescription1';
        String groupStdDes = 'testDescription2';
        String compactStdDes= 'testDescription3';
        Boolean isPrimary=policyForms[0].Is_Primary__c;
        Policy_Form_Detail__c  primaryPolicyFormDetails=policyForms[0];
        CTRL_CreateMassPolicyForm.createPolicyFormRecords(insuranceType, //insuranceType
        												  policyFormType,//policyFormType
        												  otherType,//otherType
        												  individualStd,//individualStd
        												  groupStd,//groupStd
        												  Name,//compact
        												  strWrapper,//stateVariationWrapper
        												  selectedDefaultFillingStrategy,//selectedDefaultFillingStrategy
        												  isPrimary,//isPrimaryInd
        												  isPrimary,//isPrimaryCompact
        												  individualStdDes,//individualStdDes
                                                          groupStdDes,//groupStdDes
                                                          compactStdDes);//compactStdDes
                                                          
       CTRL_CreateMassPolicyForm.createPolicyFormRecords(insuranceType, //insuranceType
        												  policyFormType,//policyFormType
        												  otherType,//otherType
        												  individualStd,//individualStd
        												  groupStd,//groupStd
        												  Name,//compact
        												  strWrapper,//stateVariationWrapper
        												  selectedDefaultFillingStrategy2,//selectedDefaultFillingStrategy
        												  isPrimary,//isPrimaryInd
        												  isPrimary,//isPrimaryCompact
        												  individualStdDes,//individualStdDes
                                                          groupStdDes,//groupStdDes
                                                          compactStdDes);//compactStdDes         
                                                          
        CTRL_CreateMassPolicyForm.createPolicyFormRecords(insuranceType, //insuranceType
        												  policyFormType,//policyFormType
        												  otherType,//otherType
        												  individualStd,//individualStd
        												  groupStd,//groupStd
        												  Name,//compact
        												  strWrapper,//stateVariationWrapper
        												  selectedDefaultFillingStrategy3,//selectedDefaultFillingStrategy
        												  false,//isPrimaryInd
        												  isPrimary,//isPrimaryCompact
        												  individualStdDes,//individualStdDes
                                                          groupStdDes,//groupStdDes
                                                          compactStdDes);//compactStdDes
                                                          
        CTRL_CreateMassPolicyForm.createPolicyFormRecords(insuranceType, //insuranceType
        												  policyFormType,//policyFormType
        												  otherType,//otherType
        												  individualStd,//individualStd
        												  groupStd,//groupStd
        												  Name,//compact
        												  strWrapper,//stateVariationWrapper
        												  selectedDefaultFillingStrategy,//selectedDefaultFillingStrategy
        												  isPrimary,//isPrimaryInd
        												  false,//isPrimaryCompact
        												  individualStdDes,//individualStdDes
                                                          groupStdDes,//groupStdDes
                                                          compactStdDes);//compactStdDes                                                                                                                                            
                                                          
        Approach app1= new Approach();
        app1.ApproachName = 'test123';
        app1.formName = policyForms[0].Name;
        app1.formId = policyForms[0].Id;
        app1.fs = filingStatus[0];
        app.add(app1);
        
        ResponseWrapper res1 = new ResponseWrapper();
        res1.approach = app;
        res1.policyFormDetail = policyForms;
        res1.state = 'test123';
        resWrp.add(res1);
        
        String FilingStatusDetail =  JSON.serialize(resWrp);
        CTRL_CreateMassPolicyForm.createFilingStatus(FilingStatusDetail,insuranceType,policyFormType,otherType);
        CTRL_CreateMassPolicyForm.duplicateFormGenerated(policyForms[0].Name);
        CTRL_CreateMassPolicyForm.getselectOptions('object','Filing_Status__c','State__c');
        CTRL_CreateMassPolicyForm.getselectOptions('method','Filing_Status__c','getState');
        CTRL_CreateMassPolicyForm.getselectOptions('method','Filing_Status__c','fillingType');
        
        String policyForms = JSON.serialize(policyForms);
        CTRL_CreateMassPolicyForm.deletePolicyForm(policyForms);
        Test.stopTest();
    }
    
    public class ResponseWrapper{
        @AuraEnabled
        public List<Approach> approach ;
        @AuraEnabled
        Public List<Policy_Form_Detail__c> policyFormDetail;
        @AuraEnabled
        public String state;
    }
    
    public class Approach{
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
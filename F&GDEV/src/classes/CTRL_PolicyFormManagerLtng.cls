public class  CTRL_PolicyFormManagerLtng {

    public virtual class MessageReturn
    {
        @AuraEnabled
        public boolean bIsError;
        @AuraEnabled
        public string sMessage;

        public MessageReturn(){
            bIsError = false;
        }
        public MessageReturn(string s_Message, boolean b_IsError){
            bIsError = b_IsError;
            sMessage = s_Message;
        }
    }
  
    public class ProductReturn extends MessageReturn
    {
        @AuraEnabled
        public Project__c oProject;    
        @AuraEnabled
        public List<Product_Specification__c> oProducts;
        @AuraEnabled
        public Map<Id, Map<String, Map<Id, W_ProdStateAvail>>> oProdStatePolicyStateStatMap;
        public Set<Id> oPolicyIdSet;
        
        public ProductReturn(){
            bIsError = false;
        }

        public ProductReturn(string s_Message, boolean b_IsError){
            bIsError = b_IsError;
            sMessage = s_Message;
        }
    }

    public class PolicyReturn extends MessageReturn
    {
        @AuraEnabled
        public List<W_Policy> oPolicyList;
        @AuraEnabled
        public List<Policy_Form_Detail__c> oPolicySearchResults;
        @AuraEnabled
        public Map<String, Map<Id, W_Policy>> oStatePolicyMap;
        @AuraEnabled
        public Boolean bPolicyUpdateAccess;
        

        public PolicyReturn(){
            this('', false);
        }
       
       public PolicyReturn(string s_Message, boolean b_IsError){
            bIsError = b_IsError;
            sMessage = s_Message;

            bPolicyUpdateAccess = false;
        }
    }

    public class PolicyFormStateAggrReturn extends MessageReturn{
        @AuraEnabled
        public W_PolicyFormStateAggregate oPolicyFormStateAggr;
        public PolicyFormStateAggrReturn(string s_Message, boolean b_IsError){
            bIsError = b_IsError;
            sMessage = s_Message;
        }
    }
   
  public class InitialWrapper{
        @AuraEnabled
        public List<State__c> states;
        @AuraEnabled
        public ProductReturn ProductReturns;
        @AuraEnabled
        public PolicyReturn PolicyReturns;
    }
   
    @AuraEnabled
    public static String getDetails(String projectId,String policyFormStateVal, String productForm)
    {
        InitialWrapper IW=new InitialWrapper();
        IW.states= getStates(productForm);
        IW.ProductReturns=getProducts(projectId);
        List<String> lstId=new List<String>();
        if(IW.ProductReturns != null 
         && IW.ProductReturns.oPolicyIdSet != null)
        {
            for(Id pID:IW.ProductReturns.oPolicyIdSet){
                lstId.add(String.valueOf(pID));
            }
        }
        IW.PolicyReturns=getPolicies(lstId,policyFormStateVal);
        return JSON.serialize(IW);
     }
    @AuraEnabled
    public static String getPolicyDetails(String projectId,String policyFormStateVal,String productForm)
    {
        InitialWrapper IW=new InitialWrapper();
        IW.states= getStates(productForm);
        //IW.ProductReturns=getProducts(projectId);
        List<String> lstId=new List<String>();
        
        for(Project_Policy__c ProjPolicy:[select 
        										Id,
        										Project__c,
        										Policy_Form__c 
        							       FROM 
        							            Project_Policy__c 
        							      WHERE
        							            Project__c = :projectId ]){
            lstId.add(String.valueOf(ProjPolicy.Policy_Form__c));
        }
        
        IW.PolicyReturns=getPolicies(lstId,policyFormStateVal);
        return JSON.serialize(IW);
    }
    
    @AuraEnabled
    public static List<State__c> getStates(String productForm)
    {
       List<State__c> states = new List<State__c>();
       Set<String> statesNameNotToBeIncluded = null;
       if(productForm =='ProductFromAssoication')
       {
      	   statesNameNotToBeIncluded = getStatesNameWhichNotToBeIncluded();
       }
       
       for(State__c state:[SELECT 
			        				Id, 
			        				Name, 
			        				IsDeleted,
			        			    SetupOwnerId, 
			        			    CreatedDate, 
			        			    CreatedById, 
			        			    LastModifiedDate, 
			        			    LastModifiedById, 
			        			    SystemModstamp, 
			        			    IsActive__c, 
			        			    StateCode__c 
			        		  FROM 
			        		        State__c 
			        		 ORDER by name asc])
		 {
		 	if( productForm =='PolicyFrom')
		 	{
		 		states.add(state);
		 	}
		 	else
		 	{
		      if(productForm =='ProductFromAssoication' && !statesNameNotToBeIncluded.contains(state.StateCode__c))
		       states.add(state);
		 	}
		 }
		 
		 return  states;
    }
    
    
    
    public static Set<String> getStatesNameWhichNotToBeIncluded() {
        
       Set<String> statesNames = new Set<String>();
       for(StatesNotToBeIncluded__mdt s:[Select 
						        			  Id,
						        			  MasterLabel,
							                  StateName__c
							            FROM 
							                 StatesNotToBeIncluded__mdt ])
	  {
	  	statesNames.add(s.StateName__c);
	  }		
	  
	  return statesNames;				                 
    }
    
    @AuraEnabled
    public static ProductReturn getProducts(String sProjectId) {
        ProductReturn prodret = new ProductReturn();

        try{

            List<State_Availability__c> stateavailList = new List<State_Availability__c>();
            stateavailList = [Select 
		                              Product_Specification__r.Project__r.Id,
		                              Product_Specification__r.Project__r.Name, 
		                              Product_Specification__c, 
		                              Product_Specification__r.Id, 
		                              Product_Specification__r.Name, 
		                              State__c, 
		                              Status__c,
		                              Approval_Date__c,
		                              Target_Launch_Date__c,
		                              Launch_Date__c,
		                              Pull_Date__c,
		                              (SELECT 
				                               Filing_Status__c,
				                               Filing_Status__r.Policy_Form__c
				                          FROM 
				                               Product_State_Statuses__r)
		               			      FROM 
		               			        	 State_Availability__c
		               			      WHERE
		               			            Product_Specification__r.Project__c =: sProjectId];

            List<Project_Policy__c> ProjPolicyList = [Select 
            												Id,
            											    Policy_Form__c 
            										   FROM 
            										   		Project_Policy__c 
            										   WHERE 
            										   		Project__c =: sProjectId];
            										   		
            //  Return Error if No Messages are Found
            if(stateavailList.size() > 0)
            {
                Set<Product_Specification__c> ProdSpecSet = new Set<Product_Specification__c>();
                Map<Id, Map<String, Map<Id, W_ProdStateAvail>>> statestatprodmap = new Map<Id, Map<String, Map<Id, W_ProdStateAvail>>>();
                
                for(State_Availability__c stateavail : stateavailList){
                    ProdSpecSet.add(stateavail.Product_Specification__r);

                    if(!statestatprodmap.containsKey(stateavail.Product_Specification__c)){
                        //  Initialize Product to State Mapping
                        statestatprodmap.put(stateavail.Product_Specification__c, new Map<String, Map<Id, W_ProdStateAvail>>());
                    }

                    if(!statestatprodmap.get(stateavail.Product_Specification__c).containsKey(stateavail.State__c)){
                        //  Initialize State to Product State Availability Mapping
                        statestatprodmap.get(stateavail.Product_Specification__c).put(stateavail.State__c, new Map<Id, W_ProdStateAvail>());
                    }

                    //  Initialize Product State Availability Object
                    statestatprodmap.get(stateavail.Product_Specification__c).get(stateavail.State__c).put(stateavail.Id, new W_ProdStateAvail(stateavail,'ltng'));

                    //  Add Product State Status Objects (Junction Object) to State Availability by Policy Id
                    for(Product_State_Status__c prodstatestat : stateavail.Product_State_Statuses__r)
                    { 
                        if(prodstatestat.Filing_Status__r.Policy_Form__c != null)
                        {
                            statestatprodmap.get(stateavail.Product_Specification__c).get(stateavail.State__c).get(stateavail.Id).PolicytoProdStateStat.put(prodstatestat.Filing_Status__r.Policy_Form__c, new W_ProdStateStatus(prodstatestat));
                        }
                    }
                }

                //  Populate Return Object with Values
                prodret.oProject = stateavailList[0].Product_Specification__r.Project__r;
                prodret.oProducts = new List<Product_Specification__c>(ProdSpecSet);
                prodret.oProdStatePolicyStateStatMap = statestatprodmap;

                prodret.oPolicyIdSet = new Set<Id>();
                for(Project_Policy__c projpolicy : ProjPolicyList)
                {
                    prodret.oPolicyIdSet.add(projpolicy.Policy_Form__c);
                }
            }
            else
            {
                prodret.bIsError = true;
                prodret.sMessage =  'No products found for the provided id.';
            }

        }catch (Exception ex)
        {
            prodret.bIsError = true;
            prodret.sMessage = ex.getMessage();
        }

        return prodret;
    }
    
    @AuraEnabled
    public static List<String> getPolicyFormState()
    {
        List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Policy_Form_Detail__c.Status__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple)
		{
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return pickListValuesList;
    }
     
    @AuraEnabled
    public static List<String> getPolicyFormType(){
        List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = Policy_Form_Detail__c.Policy_Form_Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple)
		{
			pickListValuesList.add(pickListVal.getLabel());
		}     
		return pickListValuesList;
    }
   
    @AuraEnabled
    public static List<String> getFilingStrategy(){
        List<String> pickListValuesList= new List<String>();
        Schema.DescribeFieldResult fieldResult = Policy_Form_Detail__c.Filing_Strategy__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple)
        {
            pickListValuesList.add(pickListVal.getLabel());
        }     
        return pickListValuesList;
    }
   
    @AuraEnabled
    public static PolicyReturn getPolicies(List<String> PolicyIds,String policyFormStateVal)
    {
        Boolean iserror = false;
        String message = '';
        
        List<W_Policy> policylist = new List<W_Policy>();
        Map<String, Map<Id, W_Policy>> statepolicymap = new Map<String, Map<Id, W_Policy>>();
        
        try{
            List<Policy_Form_Detail__c> items = new List<Policy_Form_Detail__c>();
            if(!String.isBlank(policyFormStateVal))
            {
             	items = [Select Id,
                				Name,
                			    Policy_Form_Name__c,
                			    Project__c,
                         		Status__c, 
                         		Policy_Form_Type__c,
                                Filing_Strategy__c,
                			    (Select 
                			    		Id,
                			    	    State__c,
                			    	    Filing_Status__c, 
                			    	    File_Date_To_Vendor__c, 
                			    	    Filing_Followup_Date__c, 
                			    	    State_Approval_Date__c, 
                			    	    Submitted_to_State_Date__c, 
                			    	    Objection_Deadline_Date__c, 
                			    	    Objection_Received_Date__c, 
                			    	    Objection_Response_Date__c,
                                 		Most_Recent_Objection_Response_Date__c,
                			    	    Target_File_Date__c, 
                			    	    Filing_Withdrawn_Date__c, 
                			    	    Filing_Notes__c, 
                			    	    Filing_Notes_Status_Notes__c 
                			       FROM 
                			    	    Filing_Statuses__r) 
                			   FROM 
                			  		  Policy_Form_Detail__c
                			   WHERE 
                			   		  Id in: PolicyIds
                			     AND 
                			          Status__c=:policyFormStateVal
                			    ORDER BY Policy_Form_Type__c asc];
            }
            else
            {
                items = [Select 
                				Id, 
                				Name, 
                				Policy_Form_Name__c,
                				Project__c,
                				Status__c,
                         		Policy_Form_Type__c,
                                Filing_Strategy__c,
                				(SELECT 
                				 		Id, 
                				 		State__c, 
                				 		Filing_Status__c, 
                				 		File_Date_To_Vendor__c, 
                				 		Filing_Followup_Date__c,
                				 	    State_Approval_Date__c, 
                				 	    Submitted_to_State_Date__c, 
                				 	    Objection_Deadline_Date__c, 
                				 	    Objection_Received_Date__c, 
                				 	    Objection_Response_Date__c,
                                 		Most_Recent_Objection_Response_Date__c,
                				 	    Target_File_Date__c, 
                				 	    Filing_Withdrawn_Date__c, 
                				 	    Filing_Notes__c, 
                				 	    Filing_Notes_Status_Notes__c 
                				 FROM
                				 		 Filing_Statuses__r) 
	                	     FROM 
	                	    	  Policy_Form_Detail__c 
	                	    WHERE 
	                	    	  Id in: PolicyIds 
	                	  order by
	                	          Policy_Form_Type__c asc];
            }
             
            for(Policy_Form_Detail__c item : items)
            {
                
                //  Return Separte List of Policies for Easier Handling in Javascript
                policylist.add(new W_Policy(item));
                
                for(Filing_Status__c status : item.Filing_Statuses__r)
                {
                    if(!String.isBlank(status.State__c)){
                        if(!statepolicymap.containsKey(status.State__c))
                        {
                            statepolicymap.put(status.State__c, new Map<Id, W_Policy>());
                        }
                        statepolicymap.get(status.State__c).put(item.Id, new W_Policy(item, status));
                    }
                }
            }
            
            //  Setup Message and Flag for Error Condition
            if(policylist.size() == 0)
            {
                message = 'No policy found for the provided id.';
                iserror = true;
            }
            
        }catch (Exception ex)
        {
            iserror = true;
            message = ex.getMessage();
        }
        
        PolicyReturn polret = new PolicyReturn(message, iserror);
        polret.oPolicyList = policylist;
        polret.oStatePolicyMap = statepolicymap;
        polret.bPolicyUpdateAccess = PolicyUpdateAccessSet.contains(UserInfo.getProfileId());
        
        return polret;
    }
    
    private static Set<Id> PolicyUpdateAccessSet
    {
        get{
            if(PolicyUpdateAccessSet == null){
                PolicyUpdateAccessSet = new Set<Id>();
                for(SetupEntityAccess custompermission : [Select 
                												 Parent.ProfileId 
                											FROM 
                												 SetupEntityAccess 
                    										WHERE 
                    											 SetupEntityType = 'CustomPermission' 
                    									    AND 
                    									    	 SetupEntityId IN 
            									    		(SELECT
								    					 			Id 
								    					 	   FROM 
								    					 	   		CustomPermission 
								    					 	   WHERE
								    					 	   		 DeveloperName = 'Compliance_Grid_Profiles')])
                {

                    PolicyUpdateAccessSet.add(custompermission.Parent.ProfileId);
                }
            }

            return PolicyUpdateAccessSet;
        }
        set;
    }
    
    
    @AuraEnabled
    public static PolicyReturn searchPolicies(String sPolicyName) {

        PolicyReturn oPolicyReturn = new PolicyReturn();

        try{
            sPolicyName = '%' + sPolicyName + '%';
            list<Policy_Form_Detail__c> lPolicyForms = new list<Policy_Form_Detail__c>([SELECT Id, Name FROM Policy_Form_Detail__c WHERE Name LIKE :sPolicyName Order By Name]);

            oPolicyReturn.oPolicySearchResults = lPolicyForms;
        }catch (Exception ex){
            oPolicyReturn.bIsError = true;
            oPolicyReturn.sMessage = ex.getMessage();
        }

    	return oPolicyReturn;
    }
    
    @AuraEnabled
    public static MessageReturn saveProjectPolicy(Id ProjectId, List<Id> PolicyIdList){
        MessageReturn ret = new MessageReturn('Policy records saved successfully!', false);

        try{
            List<Project_Policy__c> forInsProjectPolicyList = new List<Project_Policy__c>();

            for(Id PolicyId : PolicyIdList){
                forInsProjectPolicyList.add(new Project_Policy__c(Project__c = ProjectId, Policy_Form__c = PolicyId));
            }

            if(forInsProjectPolicyList.size() > 0){
                insert forInsProjectPolicyList;
            }

        }catch (Exception ex){
            ret.bIsError = true;
            ret.sMessage = ex.getMessage();            
        }

        return ret;
    }
    
    @AuraEnabled
    public static String getPolicyFormStateAggr(String statepolicymapstr) {
        Map<String, Map<Id, W_Policy>> statepolicymap = (Map<String, Map<Id, W_Policy>>)json.deserialize(statepolicymapstr, Map<String, Map<Id, W_Policy>>.class);
        PolicyFormStateAggrReturn ret = new PolicyFormStateAggrReturn(null, false);
        W_PolicyFormStateAggregate aggr = new W_PolicyFormStateAggregate();

        try{
            for(String state : statepolicymap.keySet()){
                for(Id policyId : statepolicymap.get(state).keySet()){
                    W_Policy policywrapper = statepolicymap.get(state).get(policyid);
                    aggr.AddPolicyFormState(policywrapper, state, policyId);
                }
            }

            aggr.UpdateAggreFields();
        }catch (Exception ex){
            ret.sMessage = ex.getMessage();
            ret.bIsError = true;
        }

       
        ret.oPolicyFormStateAggr = aggr;
        
        return json.serialize(ret);
    }
    
    @AuraEnabled
    public static String saveStatePolicyStatus(String policyformstateaggrstr)
    {
        W_PolicyFormStateAggregateLtng policyformstateaggr = (W_PolicyFormStateAggregateLtng)json.deserialize(policyformstateaggrstr, W_PolicyFormStateAggregateLtng.class);
        MessageReturn ret = new MessageReturn('State Policy Filing Statuses Have Been Updated.', false);
        List<Filing_Status__c> forUpdFilingStatList = new List<Filing_Status__c>();
        List<Filing_Status__c> forInsFilingStatList = new List<Filing_Status__c>();

        try{
            //  Loop Existing Policies for Update
            Boolean hasUpdate = false;

            for(Id PolicyFrmStateId : policyformstateaggr.PolicyFormStateIds){

                //  Loop Aggregate Fields Overwriting Policy Object Fields
                Filing_Status__c filingStat = fillPolicyFormStateObj(PolicyFrmStateId, policyformstateaggr);

                if(filingStat != null){
                    forUpdFilingStatList.add(filingStat);
                }
            }

            //  Loop New Policies for Insert
            for(String state : policyformstateaggr.NewStatePolicyMap.keySet())
            {
                for(Id policyid : policyformstateaggr.NewStatePolicyMap.get(state))
                {
                    Filing_Status__c filingStat = fillPolicyFormStateObj(state, policyid, policyformstateaggr);

                    if(filingStat != null)
                    {
                        forInsFilingStatList.add(filingStat);
                    }
                }
            }

            if(forUpdFilingStatList.size() > 0)
            {
                update forUpdFilingStatList;
            }

            if(forInsFilingStatList.size() > 0)
            {
                insert forInsFilingStatList;
            }

        }catch (Exception ex)
        {
            ret.sMessage = ex.getMessage();
            ret.bIsError = true;
        }

        return json.serialize(ret);
    }
    
    public static Filing_Status__c fillPolicyFormStateObj(Id FilingStatusId,
    													  W_PolicyFormStateAggregateLtng policyformstateaggr)
   {
        Filing_Status__c polfrmstate = new Filing_Status__c(Id = FilingStatusId);
        return fillPolicyFormStateObj(polfrmstate, policyformstateaggr);
    }

    public static Filing_Status__c fillPolicyFormStateObj(String state,
    												 	  Id policyid,
    												 	  W_PolicyFormStateAggregateLtng policyformstateaggr)
   {

        Filing_Status__c polfrmstate = new Filing_Status__c(State__c = state,
        													 Policy_Form__c = policyid);
        return fillPolicyFormStateObj(polfrmstate, policyformstateaggr);
    }

    public static Filing_Status__c fillPolicyFormStateObj(Filing_Status__c polfrmstate,
    													   W_PolicyFormStateAggregateLtng policyformstateaggr)
    {
        final String FIELDTYPE_DATE = 'DATE';
        
        Boolean hasUpdate = false;
        Filing_Status__c retPlcyFrmState;
        
        for(String field : policyformstateaggr.Fields)
        {
            
            if(policyformstateaggr.isEditedMap.get(field))
            {
                //  Update Field Value
                if(policyformstateaggr.FieldTypeMap.get(field) == FIELDTYPE_DATE)
                {
                    
                    //  Only Attempt to Save Date if Field Not Empty
                    if(policyformstateaggr.FieldValueMap.get(field) != null 
                    	&& policyformstateaggr.FieldValueMap.get(field) != '')
                     {
                        String dtStr = String.valueOf(policyformstateaggr.FieldValueMap.get(field));
                        String dtDay = dtStr.substring(0,2);
                        String dtMonth = dtStr.substring(2,4);
                        String dtYear = dtStr.substring(4,8);
                        
                        polfrmstate.put(field, Date.parse(String.format('{0}/{1}/{2}', new List<String>{dtDay, dtMonth, dtYear})));
                        
                    }
                    
                }
                else
                {
                    polfrmstate.put(field, policyformstateaggr.FieldValueMap.get(field));
                }
                hasUpdate = true;
            }              
        }
        
        if(hasUpdate)
        {
            retPlcyFrmState = polfrmstate;
        }
        
        return retPlcyFrmState;
    }
    
    @AuraEnabled
    public static String saveProdStatePolicyStatus(String prodstatepolicystatmapstr)
    {
        Map<Id, Map<String, Map<Id, W_ProdStateAvail>>> prodstatepolicystatmap = (Map<Id, Map<String, Map<Id, W_ProdStateAvail>>>)json.deserialize(prodstatepolicystatmapstr, Map<Id, Map<String, Map<Id, W_ProdStateAvail>>>.class);
        
        final String FilingStatus_Default = 'Not Started';

        //  PSS: Product State Status
        List<Product_State_Status__c> pssforInsList = new List<Product_State_Status__c>();
        List<Product_State_Status__c> pssforDelList = new List<Product_State_Status__c>();

        String successmessage = 'Product State Policy Statuses updated.';

        ProductReturn ret = new ProductReturn(successmessage, false);

        try{

            //  Create Map of StateAvail to Policy Filing Status for Records Where Filing Status Does Not Presently Exist
            Map<Id, List<Filing_Status__c>> StateAvailIdtoFilingStatList = new Map<Id, List<Filing_Status__c>>();

            for(Id prodid : prodstatepolicystatmap.keySet())
            {
                for(String state : prodstatepolicystatmap.get(prodid).keySet())
                {
                    for(Id stateavailid : prodstatepolicystatmap.get(prodid).get(state).keySet())
                    {
                        for(Id policyid : prodstatepolicystatmap.get(prodid).get(state).get(stateavailid).PolicytoProdStateStat.keySet())
                        {
                            W_ProdStateStatus prodstatestat = prodstatepolicystatmap.get(prodid).get(state).get(stateavailid).PolicytoProdStateStat.get(policyid);
                            if(prodstatestat.InsertOrDelete && prodstatestat.ProductStateStatusId == null)
                            {
                                //  Populate Product State Status Insert List
                                if(prodstatestat.FilingStatusId != null){
                                    pssforInsList.add(new Product_State_Status__c(Filing_Status__c = prodstatestat.FilingStatusId, Product_State_Availability__c = stateavailid));
                                }
                                else
                                {
                                    //  List to Create State Availability Before Product State Status is Inserted
                                    if(!StateAvailIdtoFilingStatList.containsKey(stateavailid))
                                    {
                                        StateAvailIdtoFilingStatList.put(stateavailid, new List<Filing_Status__c>());
                                    }
                                    StateAvailIdtoFilingStatList.get(stateavailid).add(new Filing_Status__c(Policy_Form__c = policyid, State__c = state));
                                }
                            }

                            if(prodstatestat.InsertOrDelete && prodstatestat.ProductStateStatusId != null)
                            {
                                //  Populate Product State Status Delete List
                                pssforDelList.add(new Product_State_Status__c(Id = Id.valueOf(prodstatestat.ProductStateStatusId)));
                            }
                        }
                    }
                }
            }

            //  Create Filing Status Records if they Exist
            if(StateAvailIdtoFilingStatList.size() > 0)
            {
                List<Filing_Status__c> fsforInsertList = new List<Filing_Status__c>();
                for(Id key : StateAvailIdtoFilingStatList.keySet())
                {
                    fsforInsertList.addAll(StateAvailIdtoFilingStatList.get(key));
                }

                if(fsforInsertList.size() > 0)
                {
                    insert fsforInsertList;
                    //  Add Additional Recors to Product State Status List
                    for(Id key : StateAvailIdtoFilingStatList.keySet())
                    {
                        for(Filing_Status__c fs : StateAvailIdtoFilingStatList.get(key))
                        {
                            pssforInsList.add(new Product_State_Status__c(Filing_Status__c = fs.Id, Product_State_Availability__c = key));
                        }
                    }
                }

            }

            //  Update the Database
            Id ProjectId;
            if(pssforDelList.size()>0)
            {
                ProjectId = getProjectIdfromProductStateStat(pssforDelList[0].Id);
                delete pssforDelList;
            }

            if(pssforInsList.size()>0)
            {
                insert pssforInsList;
                ProjectId = getProjectIdfromProductStateStat(pssforInsList[0].Id);
            }

            //  Requery Product Status Policy Map
            if(!ret.bIsError && ProjectId != null)
            {
                ret = getProducts(ProjectId);
                if(!ret.bIsError){
                    ret.sMessage = successmessage;
                }
            }

        }catch (Exception ex){
            ret.sMessage = ex.getMessage();
            ret.bIsError = true;
        }

        return json.serialize(ret); 
    }
    
     private static Id getProjectIdfromProductStateStat(Id ProductStateStatId){
        Id ProjectId;

        //  Retrieve Project Related to Product Status Status Record
        List<Product_State_Status__c> prdstateStatList = new List<Product_State_Status__c>();
        prdstateStatList = [Select 
        							Product_State_Availability__r.Product_Specification__r.Project__c
        					   FROM 
        					   		Product_State_Status__c 
        					   WHERE 
        					   		Id=:ProductStateStatId Limit 1];
        
        if(prdstateStatList.size() > 0)
        {
            ProjectId = prdstateStatList[0].Product_State_Availability__r.Product_Specification__r.Project__c;
        }

        return ProjectId;
    }
}
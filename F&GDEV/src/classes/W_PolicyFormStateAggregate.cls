global class W_PolicyFormStateAggregate {
	final private String Field_Type_Picklist = 'Picklist';

	//	Initialzie Object Properties
	global W_PolicyFormStateAggregate(){
		this.Fields = new List<String>();
		this.FieldTypeMap = new Map<String, String>();
		this.FieldLabelMap = new Map<String, String>();
		this.FieldPicklistMap = new Map<String, List<String>>();

		this.FieldValueMap = new Map<String, Object>();
		this.FieldOrigValueMap = new Map<String, Object>();

		this.isEditableMap = new Map<String, Boolean>();
		this.isEditedMap = new Map<String, Boolean>();
		this.isMultiValueMap = new Map<String, Boolean>();

		this.PolicyFormStateIds = new List<Id>();
		this.NewStatePolicyMap = new Map<String, List<Id>>();

		//	Initalize Maps Based on Fieldsets
		List<Schema.FieldSetMember> schemaFields = Schema.SObjectType.Filing_Status__c.fieldSets.Policy_Mass_Edit.getFields();
		for(Schema.FieldSetMember schemaField : schemaFields){
			String fieldname = schemaField.getFieldPath();
			String fieldtype = schemaField.getType().name();
			
			this.Fields.add(fieldname);
			this.FieldTypeMap.put(fieldname, fieldtype);
			this.FieldLabelMap.put(fieldname, schemaField.getLabel());

			//	Add Picklist Map
			if(fieldtype == Field_Type_Picklist){
				this.FieldPicklistMap.put(fieldname, getFieldPickList(fieldname));
			}

			//	Editable for Field is Defaulted to False and Updated in Client
			this.isEditableMap.put(fieldname, false);
			//	Edit for Field is Defaulted to False and Updated in Client
			this.isEditedMap.put(fieldname, false);
			//	MultiValue will be Updated to True if there are mulitple values for the specific key field across returned records
			this.isMultiValueMap.put(fieldname, false);
		}

	}

	global List<String> Fields 									{get; set;}
	global Map<String, String> FieldTypeMap						{get; set;}
	global Map<String, String> FieldLabelMap					{get; set;}
	global Map<String, Object> FieldValueMap					{get; set;}
	global Map<String, Object> FieldOrigValueMap				{get; set;}

	global Map<String, List<String>> FieldPicklistMap			{get; set;}
	
	global Map<String, Boolean> isEditableMap					{get; set;}
	global Map<String, Boolean> isEditedMap						{get; set;}
	global Map<String, Boolean> isMultiValueMap					{get; set;}

	global List<Id> PolicyFormStateIds							{get; set;}
	global Map<String, List<Id>> NewStatePolicyMap 				{get; set;}

	private List<String> getFieldPickList(String field){
		List<String> picklistOpts = new List<String>();

		Schema.DescribeFieldResult fieldResult = Schema.SObjectType.Filing_Status__c.fields.getMap().get(field).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();

        for( Schema.PicklistEntry f : ple)
        {
            picklistOpts.add(f.getValue());
        }
		
        return picklistOpts;
	}

	//	Add Id of Policy Form for Pending Update or State to Policy Map for Insert
	global void AddPolicyFormState(W_Policy policywrapper, String state, Id policyId){
		if(policywrapper.UISelected){
			if(policywrapper.FilingStatusId != null){
				this.PolicyFormStateIds.add(policywrapper.FilingStatusId);
			}else{
				if(!NewStatePolicyMap.containsKey(state)){
					NewStatePolicyMap.put(state, new List<Id>());
				}

				NewStatePolicyMap.get(state).add(policyId);
			}
		}
	}

	//	User Ids of Existing Records to Update the Aggregate Object
	global void UpdateAggreFields(){

		if(this.PolicyFormStateIds.size() > 0){
			//	Query Records from Object
			//	List<String> policyformstatids = this.PolicyFormStateIds;
			String qry = String.format('Select {0} from Filing_Status__c Where Id in: PolicyFormStateIds', new List<String>{String.join(this.Fields, ',')});

			List<Filing_Status__c> filingrecs = Database.query(qry);

			//	Iterate Records Populating Properties.
			FieldOrigValueMap = new Map<String, Object>();
			
			for(Filing_Status__c filingrec : filingrecs){
				for(String fieldname : this.Fields){
					if(FieldOrigValueMap.containsKey(fieldname)){
						//	evaluate if the cached value for the field is the same as the field value in the current iterated record
						if(FieldOrigValueMap.get(fieldname) != filingrec.get(fieldname)){
							this.isMultiValueMap.put(fieldname, true);
						}
					}else{
						//	Capture uncaptured value and type of fields to appropriate maps
						Object val = filingrec.get(fieldname);

						if(val != null){
							this.FieldValueMap.put(fieldname, filingrec.get(fieldname));

							//	Record the value of the first record in the FieldOrigValueMap; will be evaluated against subsequent iterations for multival designation.
							FieldOrigValueMap.put(fieldname, val);
						}
					}
				}
			}			
		}

	}
}
public with sharing class W_FilingStatusAggregate {
	public W_FilingStatusAggregate(){}

	private List<String> pvtFieldList = new List<String>
	{
		'Filing_Status__c','State_Approval_Date__c','Submitted_to_State_Date__c','Objection_Deadline_Date__c','Objection_Received_Date__c','Objection_Response_Date__c','Filing_Notes__c','Filing_Notes_Status_Notes__c'
	};

	public Map<String, AggregatedFieldClass> AggregateFieldMap = new Map<String, AggregatedFieldClass>();

	public class AggregatedFieldClass
	{
		public AggregatedFieldClass(String FieldName, String FieldValue, Boolean isMultiValue, Boolean doOverride){}

		public String FieldName 				{get; set;}
		public String FieldValue 				{get; set;}
		public Boolean isMultiValue 			{get; set;}
		public Boolean doOverride 				{get; set;}
	}

	public void addFilingStatus(Filing_Status__c filingstatus){
		//	keep copy of filing status
		pvtFilingStatusList.add(filingstatus);

		//	iterate object fields and update class aggregate field value
		for(String field : pvtFieldList){
			//	Add field if it is not already mapped
			if(!AggregateFieldMap.containsKey(field)){
				this.AggregateFieldMap.put(field, new AggregatedFieldClass(field, String.valueOf(filingstatus.get(field)), false, false));
			}else{
				//	Update object to specify that field value already exists
				this.AggregateFieldMap.get(field).isMultiValue = true;
			}
		}

	}

	public List<Filing_Status__c> getFilingStatusList(){
		return pvtFilingStatusList;
	}

	//	List of Filing Status Objects
	private List<Filing_Status__c> pvtFilingStatusList = new List<Filing_Status__c>();

}
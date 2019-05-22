public class DAL_StateAvailability {
    
    public static List<State_Availability__c> getByTranxcationId(String tranxId)
    {
        return [SELECT
                       Id
                   FROM
                       State_Availability__c
                  WHERE 
                       TranscationId__c =:tranxId];
    }
    
    public static Map<Id,List<State_Availability__c>> getByTranxcationIdMap(List<Id> tranxIds)
    {
        List<State_Availability__c> stateAvailabiltys = [SELECT
										                       Id,
										                       TranscationId__c,
										                       Name,
										                       State__c
										                   FROM
										                       State_Availability__c
										                  WHERE 
										                       TranscationId__c IN:tranxIds];
										                       
		Map<Id,List<State_Availability__c>>	tranxcationIdMap = new Map<Id,List<State_Availability__c>>();	
		for(State_Availability__c stateAvailabilty: stateAvailabiltys)
		{
			List<State_Availability__c> stateAvailabiltyss  = null;
			{
				if(tranxcationIdMap.get(stateAvailabilty.TranscationId__c) != null)
				{
					stateAvailabiltyss  = tranxcationIdMap.get(stateAvailabilty.TranscationId__c);
				}else
				{
					stateAvailabiltyss  = new List<State_Availability__c>();
				}
		        stateAvailabiltyss.add(stateAvailabilty);
			}
			tranxcationIdMap.put(stateAvailabilty.TranscationId__c,stateAvailabiltyss);
		}
		
		return tranxcationIdMap;			                       
    }
    
}
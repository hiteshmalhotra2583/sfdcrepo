public with sharing class DAL_FilingStrategy 
{
    
    /**
    * @description      This is to fetch Filing_Strategy__c.
    * @return           It returns Map of Filing_Strategy__c based on query.
    */ 
    public static Map<String, Filing_Strategy__c> getALL()
    {
      try {    
            String query = 'SELECT ';
                    for(Schema.FieldSetMember f : SObjectType.Filing_Strategy__c.FieldSets.QueryFields.getFields()) {
                        query += f.getFieldPath() + ',';
                    }
                    query = query.substring(0, query.length()-1);
                    query += ' FROM Filing_Strategy__c';  
           
            List<Filing_Strategy__c> fillingStrategys = Database.query(query) ;
            Map<String,Filing_Strategy__c> fsMap = new Map<String,Filing_Strategy__c>() ;
            if(!fillingStrategys.isEmpty()) {
                for(Filing_Strategy__c fs : fillingStrategys)
                {
                    fsMap.put(fs.Name , fs);
                }   
            }
            return fsMap ;
        }
        catch(Exception e) { return null;}
    }
    
    
     /**
    * @description      This is to fetch FIA_Filing_Strategy.
    * @return           It returns Map of Filing_Strategy__c based on query.
    */ 
    public static Map<String, Filing_Strategy__c> getFIAFillingStrategyRecords()
    {
      try {    
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Filing_Strategy__c.FieldSets.FIA_Filing_Strategy.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.substring(0, query.length()-1);
            query += ' FROM Filing_Strategy__c';  
    
            List<Filing_Strategy__c> fillingStrategys = Database.query(query) ;
            Map<String,Filing_Strategy__c> fsMap = new Map<String,Filing_Strategy__c>() ;
            if( ! fillingStrategys.isEmpty())
             {
                for(Filing_Strategy__c fs : fillingStrategys)
                {
                    fsMap.put(fs.Name , fs);
                }
            }
            return fsMap ;
        }
        catch(Exception e) { return null;}
    }
    
    
    
     /**
    * @description      This is to fetch IUL_Filing_Strategy.
    * @return           It returns Map of Filing_Strategy__c based on query.
    */ 
    public static Map<String, Filing_Strategy__c> getIULFillingStrategyRecords()
    {
      try {    
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Filing_Strategy__c.FieldSets.IUL_Filing_Strategy.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.substring(0, query.length()-1);
            query += ' FROM Filing_Strategy__c';  
            List<Filing_Strategy__c> fillingStrategys = Database.query(query) ;
            Map<String,Filing_Strategy__c> fsMap = new Map<String,Filing_Strategy__c>() ;
            if(!fillingStrategys.isEmpty()) {
                for(Filing_Strategy__c fs : fillingStrategys)
                {
                    fsMap.put(fs.Name , fs);
                }
            }
            return fsMap ;
        }
        catch(Exception e) { return null;}
    }
    
    
     /**
    * @description      This is to fetch MYGA_Filing_Strategy.
    * @return           It returns Map of Filing_Strategy__c based on query.
    */ 
    public static Map<String, Filing_Strategy__c> getMYGAFillingStrategyRecords()
    {
      try {    
            String query = 'SELECT ';
            for(Schema.FieldSetMember f : SObjectType.Filing_Strategy__c.FieldSets.MYGA_Filing_Strategy.getFields()) {
                query += f.getFieldPath() + ',';
            }
            query = query.substring(0, query.length()-1);
            query += ' FROM Filing_Strategy__c';  

            List<Filing_Strategy__c> fillingStrategys = Database.query(query) ;
            Map<String,Filing_Strategy__c> fsMap = new Map<String,Filing_Strategy__c>() ;
            if(!fillingStrategys.isEmpty()) {
                for(Filing_Strategy__c fs : fillingStrategys)
                {
                    fsMap.put(fs.Name , fs);
                }
            }
            return fsMap ;
        }
        catch(Exception e) { return null;}
    }
}
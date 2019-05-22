public class TestDataFactory {

    private static final Integer DEFAULT_NAME_LEN = 15;
    private static final String ADMIN_PROFILE = 'System Administrator';
    public Static SObject operationOnObjectRecord(String ActionString,String sObjectName,Map <String,Object> MapFieldsAndValue)
    {
        //get the object describe
        Schema.SObjectType oSObjectType=Schema.getGlobalDescribe().get(sObjectName);
        //Create the instance of the object
        Sobject oObject = oSObjectType.newSObject();
        
        //Set dummy data for the rest of the fields in the object
        for (Schema.SObjectField oFieldSet: oSObjectType.getDescribe().fields.getMap().values())
        {
            Schema.DescribeFieldResult oDescribeFieldResult=oFieldSet.getDescribe();
            if (oDescribeFieldResult.isCreateable() 
                    && (MapFieldsAndValue==Null || MapFieldsAndValue.isEmpty() 
                        || !MapFieldsAndValue.containsKey(oDescribeFieldResult.getName())))
            {
                if(String.ValueOf(oDescribeFieldResult.getType())=='STRING')
                {
                    Integer Length=oDescribeFieldResult.getLength();
                    if (Length >= 10)
                    {
                        Length=10;
                    }
                    oObject.put(oDescribeFieldResult.getName(),generateRandomString(Length));
                }
                else if (String.ValueOf(oDescribeFieldResult.getType())=='BOOLEAN')
                {
                    oObject.put(oDescribeFieldResult.getName(),getRandomBoolean());
                }
                else if(String.ValueOf(oDescribeFieldResult.getType())=='DATETIME')
                {
                    oObject.put(oDescribeFieldResult.getName(),System.Now());
                }
                else if (String.ValueOf(oDescribeFieldResult.getType())=='DATE')
                {
                    oObject.put(oDescribeFieldResult.getName(),System.Today()+generaterandomInteger(2));
                }
                else if (String.ValueOf(oDescribeFieldResult.getType())=='DOUBLE')
                {
                    oObject.put(oDescribeFieldResult.getName(),Double.ValueOf(generaterandomInteger(oDescribeFieldResult.getDigits())));
                }
                else if (String.ValueOf(oDescribeFieldResult.getType())=='EMAIL')
                {
                    oObject.put(oDescribeFieldResult.getName(),generateRandomEmail());
                }
                
            }
        }
        
        //Set the values of the fields according to the map
        if (MapFieldsAndValue!=null && !MapFieldsAndValue.isEmpty())
        {
            for (String keysString:MapFieldsAndValue.keySet())
            {
                oObject.put(keysString,MapFieldsAndValue.get(keysString));
            }
        }
        
        if (ActionString!=Null && ActionString!='')
        {
            if (ActionString.toLowerCase()=='insert')
            {
                insert oObject;
            }
            else if (ActionString.toLowerCase()=='update')
            {
                update oObject;
            }
            else if (ActionString.toLowerCase()=='upsert')
            {
                upsert oObject;
            }
            else if (ActionString.toLowerCase()=='delete')
            {
                delete oObject;
            }
        }
        return oObject;
    }
    
    public static String generateRandomString(Integer len) 
    {
        return al.RandomStringUtils.randomAlphabetic(len);
    }

    //This method is used to generate a random integer
    public Static Integer generaterandomInteger(Integer upperLimit){
        Integer rand = Math.round(Math.random()*1000);
        if (upperLimit==0)
        {
            return 0;
        }
        return Math.mod(rand, upperLimit);
    }
    //This method is used to create a user
    public Static User createUser(Boolean ifinsert,  Boolean bypassValidationRule,String bypassTrigger)
    {
        //UserRole r = new UserRole(DeveloperName = 'testUserRole'+System.currentTimeMillis(), Name = generateRandomString(5));
        //insert r;
        User u = new User(
                ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
                LastName = 'last',
                Email = generateRandomEmail(),
                Username = generateRandomEmail() + System.currentTimeMillis(),
                CompanyName = generateRandomString(3),
                Title = generateRandomString(3),
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ByPassValidation__c = bypassValidationRule
                //UserRoleId = r.Id,
        );
        if (ifinsert)
        {
            insert u;
        }
        return u;
    }
    
    
    
    //This method is used to generate an email id
    public Static String generateRandomEmail()
    {
        String emailString=generateRandomString(6)+'@'+generateRandomString(6)+'.com';
        return emailString;
    }
    
    private static final IntegerRange BINARY_RANGE = new IntegerRange(0,1);
    
    public static Boolean getRandomBoolean(){
        return nextInteger(BINARY_RANGE,true) == 1;
    }
    
    public static Integer nextInteger(IntegerRange range, Boolean inclusive){
        if(range == null){
            return null;
        }
        if(inclusive && (range.max() - range.min()) <= 0){
            return range.min();
        }
        if(!inclusive && (range.max() - range.min()) <= 2){
            return range.min();
        }
        Integer inclusiveChange1 = -1;
        if(inclusive) inclusiveChange1 = 1;
        Integer inclusiveChange2 = 1;
        if(inclusive) inclusiveChange2 = 0;
        return (Integer) (
            Math.round(
                Math.floor(
                    Math.random()
                    * ((range.max()-range.min()+inclusiveChange1))
                )
            ) 
            + range.min()
            + inclusiveChange2
        );
    }
    
    public class IntegerRange {

    private Integer min;
    private Integer max;
    
    public IntegerRange(Integer number1){
        if(number1 == null){
            throw new IllegalArgumentException('illegal argument: null number');
        }
        min = max = number1;
    } 
    public IntegerRange(Integer number1, Integer number2){
        if(number1 == null || number2 == null){
            throw new IllegalArgumentException('illegal argument: null number');
        }
        if(number1 < number2){
            min = number1;
            max = number2;    
        } else {
            min = number2;
            max = number1;    
        }
    }
    
    public Integer max(){ return max; }
    public Integer min(){ return min;}
    public String toAString(){ return '[' + min + ',' + max + ']'; }
    public Boolean contains(Integer value){ return min <= value && value <= max; }
    public Boolean contains(IntegerRange value){ return min <= value.min() && value.max() <= max; }
    public Boolean overlaps(IntegerRange value){ return min <= value.max() && value.min() <= max; }

}

public static User createUser(boolean bypassValidation,
                              String byPassSelectedTrigger,
                              String profileName) {
        User Admin_User;
        
        Map<String, Id> profileMap = new Map<String, Id>();
        
        for(Profile p : [SELECT Id, Name From Profile]) 
        {
            profileMap.put(p.Name, p.Id);
        }
        
        Admin_User = new User(
            Username = generateRandomEmail() + System.currentTimeMillis()//'adminA2@admin.com'
            , ProfileId = profileMap.get(profileName)
            , Alias = 'test123'
            , Email = generateRandomEmail()//'admin@admin.com'
            , EmailEncodingKey = 'UTF-8'
            , LastName = 'TestAdmin'
            , TimeZoneSidKey = 'Europe/Berlin'
            , LocaleSidKey = 'en_US'
            , LanguageLocaleKey = 'en_US'
            , ByPassValidation__c = bypassValidation
            ,ByPassTrigger__c = byPassSelectedTrigger
           
        );
        
        return Admin_User;
    }
    public static void initStateList(){
		List<State__c> stateList = new List<State__c>();
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
   public class IllegalArgumentException extends Exception {}

}
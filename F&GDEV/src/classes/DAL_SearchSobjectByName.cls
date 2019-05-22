public class DAL_SearchSobjectByName
 {
    
    public static List<sObject> getSobjectRecordsByName(String objName, String searchString, String moreFields, List<sObject> selectedRecords) 
    {
        String query = 'Select Id, Name ';
        if(moreFields!=null && moreFields!='')
        {
            query+= ', '+moreFields + ' ';
        }
        query+= 'from ' + objName+' where Name like \'%'+searchString+ '%\' ';
        if(selectedRecords!=null && !selectedRecords.isEmpty())
        {
            query+=' AND ID NOT IN: selectedRecords';
        }
        List<sObject> lstResults  = Database.query(query);
        return lstResults;
    }
}
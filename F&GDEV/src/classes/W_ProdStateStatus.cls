global with sharing class W_ProdStateStatus {
    global W_ProdStateStatus(Product_State_Status__c prodstatestat) {
        this.ProductStateStatusId = prodstatestat.Id;
        this.FilingStatusId = prodstatestat.Filing_Status__c;
        this.InsertOrDelete = false;
    }
    
    global Id ProductStateStatusId 							{get; set;}
    global Id FilingStatusId 								{get; set;}
    global Boolean InsertOrDelete							{get; set;}
}
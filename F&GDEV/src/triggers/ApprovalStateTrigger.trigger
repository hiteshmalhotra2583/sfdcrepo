trigger ApprovalStateTrigger on Approval_State__c (after insert) {

   new TH_ApprovalState().run();

}
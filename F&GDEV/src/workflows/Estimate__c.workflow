<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Estimate_Has_Been_Submitted</fullName>
        <description>Estimate Has Been Submitted</description>
        <protected>false</protected>
        <recipients>
            <recipient>amy.coyne@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PDHub_Templates/Estimate_Has_Been_Submitted</template>
    </alerts>
    <alerts>
        <fullName>Work_Order_Estimate_Has_Been_Approved</fullName>
        <description>Work Order &amp; Estimate Has Been Approved</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PDHub_Templates/Estimate_Has_Been_Approved</template>
    </alerts>
    <alerts>
        <fullName>Work_Order_Estimate_Has_Been_Rejected</fullName>
        <description>Work Order &amp; Estimate Has Been Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PDHub_Templates/Estimate_Has_Been_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Estimate_Status_to_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Set Estimate Status to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Estimate_Status_to_Recalled</fullName>
        <field>Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Set Estimate Status to Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Estimate_Status_to_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Set Estimate Status to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Estimate_Status_to_Submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Set Estimate Status to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>

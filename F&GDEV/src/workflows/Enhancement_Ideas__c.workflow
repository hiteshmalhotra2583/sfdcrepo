<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Enhancement_Idea</fullName>
        <description>New Enhancement Idea</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <recipient>alexandra.gold@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>david.rusinko@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/Enhancement_Idea_New</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Close_Date</fullName>
        <field>Closed_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Close Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Enhancement Idea Close Date</fullName>
        <actions>
            <name>Update_Close_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Enhancement_Ideas__c.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Enhancement_Ideas__c.Closed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

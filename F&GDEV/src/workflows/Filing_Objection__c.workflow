<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>ObjectionCloseDate</fullName>
        <field>Objection_Closed__c</field>
        <formula>Objection_Response_Submitted__c</formula>
        <name>ObjectionCloseDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Assign Close Date</fullName>
        <actions>
            <name>ObjectionCloseDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Filing_Objection__c.Objection_Response_Submitted__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Used for Update Objection Data on Policy Form State process builder flow.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

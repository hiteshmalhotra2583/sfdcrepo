<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Fill_Task_Type_Custom</fullName>
        <description>For reporting purposes related to tasks.</description>
        <field>Activity_Type_Custom__c</field>
        <formula>TEXT( Type )</formula>
        <name>Fill Task Type Custom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Fill Task Type Custom</fullName>
        <actions>
            <name>Fill_Task_Type_Custom</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Type</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>For reporting purposes related to tasks.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

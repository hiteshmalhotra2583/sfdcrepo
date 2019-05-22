<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>BasePolicyFormMark</fullName>
        <field>Base_Policy_Form__c</field>
        <literalValue>1</literalValue>
        <name>BasePolicyFormMark</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BasePolicyFormUnmark</fullName>
        <field>Base_Policy_Form__c</field>
        <literalValue>0</literalValue>
        <name>BasePolicyFormUnmark</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Compact_Situs_Approval_Date</fullName>
        <field>Compact_Situs_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Compact/Situs Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>No_Outstanding_States_Closes_Form</fullName>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <name>No Outstanding States Closes Form</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PolicyFormTypeEraseOther</fullName>
        <field>Policy_Form_Type_Other__c</field>
        <name>PolicyFormTypeEraseOther</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Policy_Form_Status_Active</fullName>
        <field>Status__c</field>
        <literalValue>Active</literalValue>
        <name>Policy Form Status Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Compact_Situs_Approval_Date</fullName>
        <field>Compact_Situs_Approval_Date__c</field>
        <name>Remove Compact/Situs Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Base Policy Form Unmark</fullName>
        <actions>
            <name>BasePolicyFormUnmark</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Policy_Form_Detail__c.Policy_Form_Type__c</field>
            <operation>notEqual</operation>
            <value>Base Policy Form</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Mark Base Policy Form</fullName>
        <actions>
            <name>BasePolicyFormMark</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Policy_Form_Detail__c.Policy_Form_Type__c</field>
            <operation>equals</operation>
            <value>Base Policy Form</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>No Outstanding States Closes Form</fullName>
        <actions>
            <name>Compact_Situs_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>No_Outstanding_States_Closes_Form</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Policy_Form_Detail__c.Number_of_Outstanding_States__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Policy_Form_Detail__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Policy_Form_Detail__c.Filing_Strategy__c</field>
            <operation>equals</operation>
            <value>IIPRC,Group</value>
        </criteriaItems>
        <description>Outstanding States = 0 changes the Policy Form Status to Closed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Outstanding States Opens Form</fullName>
        <actions>
            <name>Policy_Form_Status_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Remove_Compact_Situs_Approval_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Policy_Form_Detail__c.Number_of_Outstanding_States__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Outstanding States &gt; 0 changes the Policy Form Status to Active.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Policy Form Type Erase Other</fullName>
        <actions>
            <name>PolicyFormTypeEraseOther</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Policy_Form_Detail__c.Policy_Form_Type__c</field>
            <operation>notEqual</operation>
            <value>Other</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

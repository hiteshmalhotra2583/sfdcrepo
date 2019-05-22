<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Add_Objection_Deadline</fullName>
        <field>Objection_Deadline_Date__c</field>
        <formula>Min_Objection_Deadline_Date__c</formula>
        <name>Add Objection Deadline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Add_Objection_Response_Date</fullName>
        <field>Objection_Response_Date__c</field>
        <formula>Min_Response_Date__c</formula>
        <name>Add Objection Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Date_Changes_Status</fullName>
        <description>Approved Date Changes Status to Approved.</description>
        <field>Filing_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approved Date Changes Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Filing_Status_to_Withdrawn</fullName>
        <field>Filing_Status__c</field>
        <literalValue>Withdrawn</literalValue>
        <name>Change Filing Status to Withdrawn</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Policy_Form_Status</fullName>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Close Policy Form Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Policy_Form__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Compact_Approved_Date_Changes_Status</fullName>
        <field>Filing_Status__c</field>
        <literalValue>Approved - Compact</literalValue>
        <name>Compact Approved Date Changes Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Compact_Dependent_Ends_with_Approved_Com</fullName>
        <description>Compact Dependent Ends with Approved Compact.</description>
        <field>Filing_Status__c</field>
        <literalValue>Approved - Compact</literalValue>
        <name>Compact Dependent Ends with Approved Com</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Compact_Dependent_Starts_with_Pending_Co</fullName>
        <field>Filing_Status__c</field>
        <literalValue>Pending Compact</literalValue>
        <name>Compact Dependent Starts with Pending Co</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Exempt_Strategy_and_Exempt_Approval</fullName>
        <field>Filing_Status__c</field>
        <literalValue>Approved - Exempt</literalValue>
        <name>Exempt Strategy and Exempt Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fill_Outstanding_Objections</fullName>
        <field>Outstanding_Objections__c</field>
        <formula>Objections_Outstanding__c</formula>
        <name>Fill Outstanding Objections</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Group_Dependent_Ends_with_Approved_Group</fullName>
        <field>Filing_Status__c</field>
        <literalValue>Approved - Dependent Group</literalValue>
        <name>Group Dependent Ends with Approved Group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Group_Dependent_Starts_with_Pending_Grou</fullName>
        <field>Filing_Status__c</field>
        <literalValue>Pending Group</literalValue>
        <name>Group Dep Starts with Pending Group</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Objection_Deadline</fullName>
        <field>Objection_Deadline_Date__c</field>
        <name>Remove Objection Deadline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Objection_Response_Date</fullName>
        <field>Objection_Response_Date__c</field>
        <name>Remove Objection Response Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Submitted_to_State_Date_Changes_Status</fullName>
        <field>Filing_Status__c</field>
        <literalValue>Filed</literalValue>
        <name>Submitted to State Date Changes Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Add Objection Deadline</fullName>
        <actions>
            <name>Add_Objection_Deadline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Filing_Status__c.Min_Objection_Deadline_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Add Objection Response Date</fullName>
        <actions>
            <name>Add_Objection_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Filing_Status__c.Min_Response_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Objections_Outstanding__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Approved Date Changes Status</fullName>
        <actions>
            <name>Approved_Date_Changes_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Filing_Status__c.State_Approval_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Outstanding_Objections__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Approved Date Changes Status of Approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Compact Approved Date Changes Status</fullName>
        <actions>
            <name>Compact_Approved_Date_Changes_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Policy_Form_Detail__c.Compact_Situs_Approval_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Strategy__c</field>
            <operation>equals</operation>
            <value>Compact Dependent</value>
        </criteriaItems>
        <description>Compact Approved Date Changes Status of Approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Compact Dependent Ends with Approved Compact</fullName>
        <actions>
            <name>Compact_Dependent_Ends_with_Approved_Com</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Strategy__c</field>
            <operation>equals</operation>
            <value>Compact Dependent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Status__c</field>
            <operation>equals</operation>
            <value>Pending Compact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Policy_Form_Detail__c.Compact_Situs_Approval_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Compact_Situs_Approval_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Compact Dependent strategy ends with Approved - Dependent Compact status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Compact Dependent Starts with Pending Compact</fullName>
        <actions>
            <name>Compact_Dependent_Starts_with_Pending_Co</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Strategy__c</field>
            <operation>equals</operation>
            <value>Compact Dependent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Status__c</field>
            <operation>notEqual</operation>
            <value>Approved,Not Filing,Pending Compact,Approved - Compact</value>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.State_Approval_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Compact Dependent strategy starts with Pending Compact status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Exempt Strategy and Exempt Approval</fullName>
        <actions>
            <name>Exempt_Strategy_and_Exempt_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Strategy__c</field>
            <operation>equals</operation>
            <value>Exempt</value>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Status__c</field>
            <operation>notEqual</operation>
            <value>Approved - Exempt</value>
        </criteriaItems>
        <description>Exempt strategy means Exempt - Approval status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fill Outstanding Objections</fullName>
        <actions>
            <name>Fill_Outstanding_Objections</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Status__c</field>
            <operation>notEqual</operation>
            <value>Withdrawn</value>
        </criteriaItems>
        <description>Fill the number of Outstanding Objections with Objections Outstanding. This is for process builder purposes based on Withdrawn filing status change.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Group Dependent Ends with Approved Group</fullName>
        <actions>
            <name>Group_Dependent_Ends_with_Approved_Group</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Strategy__c</field>
            <operation>equals</operation>
            <value>Group Dependent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Compact_Situs_Approval_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Group Dependent strategy ends with Approved - Dependent Group status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Group Dependent Starts with Pending Group</fullName>
        <actions>
            <name>Group_Dependent_Starts_with_Pending_Grou</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Strategy__c</field>
            <operation>equals</operation>
            <value>Group Dependent</value>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Status__c</field>
            <operation>notEqual</operation>
            <value>Approved,Not Filing,Pending Group,Approved - Dependent Group</value>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.State_Approval_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Group Dependent strategy starts with Pending Group status.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Remove Objection Deadline</fullName>
        <actions>
            <name>Remove_Objection_Deadline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Filing_Status__c.Min_Objection_Deadline_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Remove Objection Response Date</fullName>
        <actions>
            <name>Remove_Objection_Response_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Filing_Status__c.Outstanding_Objections__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Submitted to State Date Changes Status</fullName>
        <actions>
            <name>Submitted_to_State_Date_Changes_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Filing_Status__c.Submitted_to_State_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.State_Approval_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Withdrawn_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Outstanding_Objections__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Submitted to State Date Changes Status of Filed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Withdrawn Date Changes Status</fullName>
        <actions>
            <name>Change_Filing_Status_to_Withdrawn</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Withdrawn_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Filing_Status__c.Filing_Status__c</field>
            <operation>notEqual</operation>
            <value>Withdrawn</value>
        </criteriaItems>
        <description>Withdrawn Date Changes Status of Withdraw.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

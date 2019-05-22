<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Add_Completion_Date</fullName>
        <description>When completion date is not entered but subproject status is Closed, make completion date today.</description>
        <field>Subproject_Close_Date__c</field>
        <formula>TODAY()</formula>
        <name>Add Completion Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Subproject_Status_to_Completed</fullName>
        <field>Subproject_Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Change Subproject Status to Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Fill_Current_Target_Date</fullName>
        <field>Current_Target_Date__c</field>
        <formula>Subproject_Close_Date__c</formula>
        <name>Fill Current Target Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Add Completion Date</fullName>
        <actions>
            <name>Add_Completion_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subproject__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PD Ops Subproject Layout</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subproject__c.Subproject_Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Subproject__c.Subproject_Close_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When subproject status is Completed, set completion date to Today.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Fill Current Target Date</fullName>
        <actions>
            <name>Change_Subproject_Status_to_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Fill_Current_Target_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Subproject__c.Subproject_Close_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Subproject__c.Current_Target_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Subproject__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PD Ops Subproject Layout</value>
        </criteriaItems>
        <description>If Current Target Date is empty and Subproject Close Date is entered and the record is PD Ops Subproject type then Current Target Date = Subproject Close Date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Generate Subproject Tasks</fullName>
        <actions>
            <name>Dell_Submit_Work_Order_Estimate</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Dell_Upload_BRD</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Dell_Upload_Model_Office_Test_Output</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Dell_Upload_Model_Office_Test_Plan</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>FGL_Distribute_BRD_for_Approval</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>FGL_Distribute_Test_Output_for_Approval</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>FGL_Distribute_Test_Plan_for_Approval</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Project__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Generates Subproject Tasks upon record creation.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Dell_Submit_Work_Order_Estimate</fullName>
        <assignedToType>owner</assignedToType>
        <description>1. Create &amp; Save the Estimate record.
2. Upload the document as an attachment.
3. Click the &apos;Submit For Approval&apos; button.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Dell Submit Work Order &amp; Estimate</subject>
    </tasks>
    <tasks>
        <fullName>Dell_Upload_BRD</fullName>
        <assignedToType>owner</assignedToType>
        <description>Upload the BRD as an Attachment on the Subproject record.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Dell Upload BRD</subject>
    </tasks>
    <tasks>
        <fullName>Dell_Upload_Model_Office_Test_Output</fullName>
        <assignedToType>owner</assignedToType>
        <description>Upload the Test Output as an Attachment on the Subproject record.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Dell Upload Model Office Test Output</subject>
    </tasks>
    <tasks>
        <fullName>Dell_Upload_Model_Office_Test_Plan</fullName>
        <assignedToType>owner</assignedToType>
        <description>Upload the Test Plan as an Attachment on the Subproject record.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Dell Upload Model Office Test Plan</subject>
    </tasks>
    <tasks>
        <fullName>FGL_Distribute_BRD_for_Approval</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>FGL Distribute BRD for Approval</subject>
    </tasks>
    <tasks>
        <fullName>FGL_Distribute_Test_Output_for_Approval</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>FGL Distribute Test Output for Approval</subject>
    </tasks>
    <tasks>
        <fullName>FGL_Distribute_Test_Plan_for_Approval</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>FGL Distribute Test Plan for Approval</subject>
    </tasks>
</Workflow>

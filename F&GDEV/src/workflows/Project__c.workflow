<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Project_Approval_Email</fullName>
        <description>Project Approval Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PDHub_Templates/Project_Record_Has_Been_Approved</template>
    </alerts>
    <alerts>
        <fullName>Project_Rejection_Email</fullName>
        <description>Project Rejection Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PDHub_Templates/Record_Has_Been_Rejected</template>
    </alerts>
    <alerts>
        <fullName>Send_New_Admin_Project_Email</fullName>
        <description>Send New Admin Project Email</description>
        <protected>false</protected>
        <recipients>
            <recipient>david.rusinko@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Send_New_Admin_Project_Email</template>
    </alerts>
    <fieldUpdates>
        <fullName>ATI_Text</fullName>
        <field>ATI_Text__c</field>
        <formula>TEXT( ATI_Number__c )</formula>
        <name>ATI_Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Asessment_Start_Today</fullName>
        <field>Assessment_Start_Date__c</field>
        <formula>Today()</formula>
        <name>Record Asessment Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Filing_Record_Type_Changes_Category</fullName>
        <field>Project_Category__c</field>
        <literalValue>Compliance</literalValue>
        <name>Filing Record Type Changes Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Feasibility_Start_Date</fullName>
        <field>Feasibility_Start_Date__c</field>
        <formula>Today()</formula>
        <name>Record Feasibility Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Implementation_Start_Date</fullName>
        <field>Implementation_Start_Date__c</field>
        <formula>Today()</formula>
        <name>Set Implementation Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Initial_PM_Tasks_Generated</fullName>
        <description>Sets checkbox to true to indicate tasks have been generated.</description>
        <field>Initial_PM_Tasks_Generated__c</field>
        <literalValue>1</literalValue>
        <name>Set Initial PM Tasks Generated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Phase_to_Day_1_Implementation</fullName>
        <field>Project_Phase__c</field>
        <literalValue>Implementation - Day 1</literalValue>
        <name>Set Phase to Day 1 Implementation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Project_Phase_Feasibility</fullName>
        <field>Project_Phase__c</field>
        <literalValue>Feasibility</literalValue>
        <name>Set Project Phase Feasibility</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Project_Phase_to_ATI_Pending</fullName>
        <field>Project_Phase__c</field>
        <literalValue>ATI Pending</literalValue>
        <name>Set Project Phase to ATI Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Project_Phase_to_Assessment</fullName>
        <description>Set Project Phase to &apos;Assessment&apos;</description>
        <field>Project_Phase__c</field>
        <literalValue>Assessment</literalValue>
        <name>Set Project Phase to Assessment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Project_Phase_to_Implementation</fullName>
        <field>Project_Phase__c</field>
        <literalValue>Implementation - Day 1</literalValue>
        <name>Set Project Phase to Implementation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ATI Text</fullName>
        <actions>
            <name>ATI_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Project__c.ATI_Text__c</field>
            <operation>notEqual</operation>
            <value>XXXX</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Assessment to Feasibility</fullName>
        <actions>
            <name>Record_Feasibility_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Project__c.Project_Phase__c</field>
            <operation>equals</operation>
            <value>Feasibility</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Feasibility_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Concept to Assessment</fullName>
        <actions>
            <name>Asessment_Start_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Project__c.Project_Phase__c</field>
            <operation>equals</operation>
            <value>Assessment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Assessment_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Generate Initial PM Tasks 1</fullName>
        <actions>
            <name>Calculator_Updates</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Checking_Tool_Updates</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Commission_Matrix_Updates</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Contract_Summary_Updates</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Create_Launch_Plan</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Hold_Marketing_Launch_Status_Update_Mtg</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Propose_New_Plan_Codes_Plan_Code_Options</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Publish_New_Plan_Codes_Plan_Code_Options</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Schedule_Project_Kickoff</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Schedule_Project_Team_Regroup</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Generates initial PM tasks  once PM has been assigned.  Must be updated if names of referenced profiles are changed.  Should stay consistent with &apos;Generate Initial PM Tasks 2&apos;.</description>
        <formula>and(ischanged(OwnerId), ispickval(Project_Phase__c,&quot;Implementation - Day 1&quot;), Initial_PM_Tasks_Generated__c=False, or( Owner:User.Profile.Name=&quot;PDH Project Manager&quot;, Owner:User.Profile.Name=&quot;PDH PD Management&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Generate Initial PM Tasks 2</fullName>
        <actions>
            <name>Set_Initial_PM_Tasks_Generated</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Create_Subproject_Records</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Specimen_Contracts_to_Sales</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Update_Illustration_Software</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Update_Marketing_Materials</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Update_Product_Notebook</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Update_Websites</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Update_iPad_App</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Generates initial PM tasks and sets the task generation back-end checkbox to true once PM has been assigned.  Must be updated if names of referenced profiles are changed.  Should stay consistent with &apos;Generate Initial PM Tasks 1&apos;.</description>
        <formula>and(ischanged(OwnerId), ispickval(Project_Phase__c,&quot;Implementation - Day 1&quot;), Initial_PM_Tasks_Generated__c=False, or( Owner:User.Profile.Name=&quot;PDH Project Manager&quot;, Owner:User.Profile.Name=&quot;PDH PD Management&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send New Admin Project Email</fullName>
        <actions>
            <name>Send_New_Admin_Project_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Project__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PM Project</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Phase to Implementation</fullName>
        <actions>
            <name>Set_Implementation_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Phase_to_Day_1_Implementation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Project__c.ATI_Approved__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Project__c.Implementation_Start_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Calculator_Updates</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Calculator Updates</subject>
    </tasks>
    <tasks>
        <fullName>Checking_Tool_Updates</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Checking Tool Updates</subject>
    </tasks>
    <tasks>
        <fullName>Commission_Matrix_Updates</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Commission Matrix Updates</subject>
    </tasks>
    <tasks>
        <fullName>Contract_Summary_Updates</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Contract Summary Updates</subject>
    </tasks>
    <tasks>
        <fullName>Create_Launch_Plan</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Create Launch Plan</subject>
    </tasks>
    <tasks>
        <fullName>Create_Subproject_Records</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Create Subproject Records</subject>
    </tasks>
    <tasks>
        <fullName>Hold_Marketing_Launch_Status_Update_Mtg</fullName>
        <assignedToType>owner</assignedToType>
        <description>Prior to field being alerted of new products.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Hold Marketing Launch/Status Update Mtg.</subject>
    </tasks>
    <tasks>
        <fullName>Propose_New_Plan_Codes_Plan_Code_Options</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Propose New Plan Codes/Plan Code Options</subject>
    </tasks>
    <tasks>
        <fullName>Publish_New_Plan_Codes_Plan_Code_Options</fullName>
        <assignedToType>owner</assignedToType>
        <description>To Accounting, Actuarial, IT, Reporting &amp; CCL via PD database.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Publish New Plan Codes/Plan Code Options</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_Project_Kickoff</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schedule Project Kickoff</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_Project_Team_Regroup</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schedule Project Team Regroup</subject>
    </tasks>
    <tasks>
        <fullName>Send_Specimen_Contracts_to_Sales</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Send Specimen Contracts to Sales</subject>
    </tasks>
    <tasks>
        <fullName>Update_Illustration_Software</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Illustration Software</subject>
    </tasks>
    <tasks>
        <fullName>Update_Marketing_Materials</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Marketing Materials</subject>
    </tasks>
    <tasks>
        <fullName>Update_Product_Notebook</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Product Notebook</subject>
    </tasks>
    <tasks>
        <fullName>Update_Websites</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update Websites</subject>
    </tasks>
    <tasks>
        <fullName>Update_iPad_App</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project__c.Requested_Day_1_Complete_Date__c</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Update iPad App</subject>
    </tasks>
</Workflow>

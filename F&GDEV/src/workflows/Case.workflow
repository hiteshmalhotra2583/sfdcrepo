<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_IS_case_alert</fullName>
        <ccEmails>IllustrationSoftware@fglife.com</ccEmails>
        <description>New IS case alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>david.rusinko@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>philip.owens@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/SUPPORTNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Notify_FGL_Admin_New_SF_Support_Case</fullName>
        <description>Notify FGL Admin New SF Support Case</description>
        <protected>false</protected>
        <recipients>
            <recipient>david.rusinko@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/SUPPORTNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Deadline_Approaching</fullName>
        <ccEmails>IllustrationSoftware@fglife.com</ccEmails>
        <description>Reminder: Deadline Approaching</description>
        <protected>false</protected>
        <recipients>
            <recipient>david.rusinko@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>philip.owens@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/SUPPORTCaseescalationnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>Reminder_Deadline_Approaching1</fullName>
        <ccEmails>IllustrationSoftware@fglife.com</ccEmails>
        <description>Reminder: Deadline Approaching</description>
        <protected>false</protected>
        <recipients>
            <recipient>david.rusinko@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>philip.owens@fglife.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/SUPPORTCaseescalationnotificationSAMPLE</template>
    </alerts>
    <rules>
        <fullName>New IS case</fullName>
        <actions>
            <name>New_IS_case_alert</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_IS_Case_Review</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Category__c</field>
            <operation>equals</operation>
            <value>Illustration Software</value>
        </criteriaItems>
        <description>New IS case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Reminder_Deadline_Approaching1</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>New SF Support Case</fullName>
        <actions>
            <name>Notify_FGL_Admin_New_SF_Support_Case</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Review_New_SF_Support_Case</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Category__c</field>
            <operation>equals</operation>
            <value>Salesforce Support</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>New_IS_Case_Review</fullName>
        <assignedTo>alexandra.gold@fglife.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>This is a description.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New IS Case Review</subject>
    </tasks>
    <tasks>
        <fullName>Review_New_SF_Support_Case</fullName>
        <assignedTo>david.rusinko@fglife.com</assignedTo>
        <assignedToType>user</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Review New SF Support Case</subject>
    </tasks>
</Workflow>

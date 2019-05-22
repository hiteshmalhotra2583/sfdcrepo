<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Solution_Approval</fullName>
        <description>Solution Approval</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Support/SUPPORTNewassignmentnotificationSAMPLE</template>
    </alerts>
    <fieldUpdates>
        <fullName>PST_Solution_Review_Approve</fullName>
        <field>Status</field>
        <literalValue>Reviewed</literalValue>
        <name>PST Solution Review Approve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>

<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_lead_owner_for_VP_Approved</fullName>
        <description>Email to lead owner for VP Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/VP_Lead_Approved</template>
    </alerts>
    <alerts>
        <fullName>Lead_Approved</fullName>
        <description>Lead Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Lead_Approved</template>
    </alerts>
    <alerts>
        <fullName>Lead_Rejected</fullName>
        <description>Lead Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Lead_Rejected</template>
    </alerts>
    <alerts>
        <fullName>RSD_Approval</fullName>
        <description>RSD Approval</description>
        <protected>false</protected>
        <recipients>
            <recipient>kirk@yeti.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/RSD_Approval</template>
    </alerts>
    <alerts>
        <fullName>RSD_Approval_For_Canada_Leads</fullName>
        <description>RSD Approval For Canada Leads</description>
        <protected>false</protected>
        <recipients>
            <recipient>andrew.nicol@yeti.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/RSD_Approval_Canada</template>
    </alerts>
    <fieldUpdates>
        <fullName>Lead_Approved</fullName>
        <field>Approved__c</field>
        <literalValue>1</literalValue>
        <name>Lead Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Rejected_Update_Status</fullName>
        <field>Status</field>
        <literalValue>Unqualified</literalValue>
        <name>Lead Rejected - Update Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Follow Up Call</fullName>
        <actions>
            <name>Call_New_Lead</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Call new Lead within 24 hours</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead VP Approved</fullName>
        <actions>
            <name>Email_to_lead_owner_for_VP_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Approved_by_VP_of_Sales__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Lead owner will receive an email when lead is approved.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Onsite Visit</fullName>
        <actions>
            <name>Schedule_Onsite_Visit</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>Onsite visit within 30 days of lead creation</description>
        <formula>Owner:User.Profile.Name = &apos;YETI Field Sales&apos;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>RSD Approval</fullName>
        <actions>
            <name>RSD_Approval</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RSM_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RSD Approval For Canada</fullName>
        <actions>
            <name>RSD_Approval_For_Canada_Leads</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Dealer Canada</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RSM_Approval__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Call_New_Lead</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Call New Lead</subject>
    </tasks>
    <tasks>
        <fullName>Schedule_Onsite_Visit</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>30</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Schedule Onsite Visit</subject>
    </tasks>
</Workflow>

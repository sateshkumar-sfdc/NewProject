<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Check_Email_Response</fullName>
        <field>Email_Response__c</field>
        <literalValue>1</literalValue>
        <name>Check Email Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>First_Response</fullName>
        <field>First_Response__c</field>
        <formula>NOW()</formula>
        <name>First Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Change</fullName>
        <field>Status_Changed__c</field>
        <formula>Now()</formula>
        <name>Owner Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFirstResponse</fullName>
        <description>Update action on FirstRespond__c on Case which will time stamp</description>
        <field>FirstRespond__c</field>
        <formula>NOW()</formula>
        <name>UpdateFirstResponse</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_to_Reopened</fullName>
        <field>Status</field>
        <literalValue>Reopened</literalValue>
        <name>Update Case to Reopened</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Intl_Case_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>International</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Intl Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Capture the First Response</fullName>
        <actions>
            <name>UpdateFirstResponse</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.FirstRespond__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This workflow will update the First Response field on case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Reopen</fullName>
        <actions>
            <name>Check_Email_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_to_Reopened</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
            <value>trackingupdates@fedex.com</value>
        </criteriaItems>
        <description>Reopen case when customer sends email after case closure.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Finanace Queue Assignment</fullName>
        <active>false</active>
        <criteriaItems>
            <field>EmailMessage.FromAddress</field>
            <operation>equals</operation>
            <value>FinancialServices@yeticoolers.com,FinancialServices@yeti.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ID_Case_Safe__c</field>
            <operation>notEqual</operation>
            <value>005i0000001vaUY</value>
        </criteriaItems>
        <description>Update the case owner to the Finance case queue when the first email received is sent to the financialservices@yeticoolers.com</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>First Response to Emails</fullName>
        <actions>
            <name>First_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.First_Response__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>First Response to Emails</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Intl Request Queue Assignment</fullName>
        <actions>
            <name>Update_Intl_Case_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.ToAddress</field>
            <operation>equals</operation>
            <value>internationalorders@yeticoolers.com,internationalorders@yeti.com</value>
        </criteriaItems>
        <description>Update the case owner to the International case queue when the first email received is sent to the internationalorders@yeticoolers.com</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Email Response</fullName>
        <actions>
            <name>Check_Email_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>Flag the case when a new email message is received.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RMA Request Queue Assignment</fullName>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.ToAddress</field>
            <operation>equals</operation>
            <value>,yetireturns@YETI.com,yetireturns@yeticoolers.com</value>
        </criteriaItems>
        <description>Update the case owner to the RMA case queue when the first email received is sent to the yetireturns@yeti.com email address.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Status Change for Email Resp</fullName>
        <actions>
            <name>Owner_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Response</value>
        </criteriaItems>
        <description>Status Change for First Response to Emails</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

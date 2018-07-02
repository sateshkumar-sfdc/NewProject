<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EmailSendStatus</fullName>
        <description>Send Email Notification of Completed Send</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ExactTarget/ETSendDone</template>
    </alerts>
    <alerts>
        <fullName>SendFailed</fullName>
        <description>Send Email Notification of Failed Send</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>ExactTarget/ETSendDone</template>
    </alerts>
    <fieldUpdates>
        <fullName>DelayedSend</fullName>
        <field>TriggerDelayedSend__c</field>
        <literalValue>1</literalValue>
        <name>DelayedSend</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FailBackupWorkflow</fullName>
        <field>SendStatus__c</field>
        <literalValue>Failed</literalValue>
        <name>FailBackupWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>true</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FailBackupWorkflowM</fullName>
        <field>Messages__c</field>
        <formula>$Label.errorNoRes</formula>
        <name>FailBackupWorkflowM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PopulateBackupWorkflow</fullName>
        <field>BackupWorkflow__c</field>
        <formula>IF(ISBLANK(Scheduled_Date_Time__c), now()+(1/48), Scheduled_Date_Time__c+(1/48))</formula>
        <name>PopulateBackupWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SendClassFrom</fullName>
        <field>FromEmail__c</field>
        <formula>FromAddress__c</formula>
        <name>SendClassFrom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SendComplete</fullName>
        <field>SendStatus__c</field>
        <literalValue>Completed</literalValue>
        <name>SendComplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SendStatusDateTime</fullName>
        <field>Status_Date_Time__c</field>
        <formula>now()</formula>
        <name>SendStatusDateTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetConversationId</fullName>
        <field>ConversationId__c</field>
        <formula>$Organization.Id+Id</formula>
        <name>SetConversationId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TrackingAsOfSD</fullName>
        <field>Tracking_As_Of__c</field>
        <formula>LastModifiedDate</formula>
        <name>TrackingAsOfSD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>true</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UnpopulateBackupWorkflow</fullName>
        <field>BackupWorkflow__c</field>
        <name>UnpopulateBackupWorkflow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>FailBackupWorkflow</fullName>
        <actions>
            <name>FailBackupWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FailBackupWorkflowM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>       NOT( Split_Send__c )       &amp;&amp;       (       !ISPICKVAL(SendStatus__c,&quot;Failed&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Completed&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Canceled&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Fail&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Complete&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Cancel&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Cancelled&quot;)         &amp;&amp;         !TrackingOnly__c         &amp;&amp;         ISBLANK(BackupWorkflow__c)         &amp;&amp;         NOT         (         IF         (         ISBLANK(Scheduled_Date_Time__c),         (NOW()-(1/2))&lt;Created_Date_Time__c,         (NOW()-(1/2))&lt;Scheduled_Date_Time__c         ||         HasBeenQueued__c         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Pending Tracking Subscription&quot;)         )         )       )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PopulateBackupWorkflow</fullName>
        <actions>
            <name>PopulateBackupWorkflow</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>!ISPICKVAL(SendStatus__c,&quot;Failed&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Completed&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Canceled&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Fail&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Complete&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Cancel&quot;)         &amp;&amp;         !ISPICKVAL(SendStatus__c,&quot;Cancelled&quot;)         &amp;&amp;       ! TrackingOnly__c       &amp;&amp;       ISBLANK( BackupWorkflow__c )       &amp;&amp;       (       IF       (       ISBLANK(Scheduled_Date_Time__c) ,       ( NOW()-(1/2) ) &lt;  Created_Date_Time__c ,       ( NOW()-(1/2) ) &lt;  Scheduled_Date_Time__c       )       ||       HasBeenQueued__c       ||       Split_Send__c       )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SendClassFrom</fullName>
        <actions>
            <name>SendClassFrom</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( FromAddress__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SendComplete</fullName>
        <actions>
            <name>EmailSendStatus</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>SendComplete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SendDefinition__c.SendStatus__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>SendDefinition__c.ConversationId__c</field>
            <operation>notContain</operation>
            <value>v3_</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SendFailed</fullName>
        <actions>
            <name>SendFailed</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(Send_Status_View__c = &apos;Fail&apos; ||  Send_Status_View__c = &apos;Failed&apos; ||  Send_Status_View__c = &apos;Error&apos; ||  Send_Status_View__c = &apos;Errored&apos; ||  Send_Status_View__c = &apos;Canceled&apos;) &amp;&amp;  NOT( CONTAINS( ConversationId__c , &quot;v3_&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SendStatusDateTime</fullName>
        <actions>
            <name>SendStatusDateTime</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( SendStatus__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetConversationId</fullName>
        <actions>
            <name>SetConversationId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT( CONTAINS( ConversationId__c , &quot;v3_&quot;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TrackingAsOfSD</fullName>
        <actions>
            <name>TrackingAsOfSD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(NumberofExistingUndeliverables__c) || ISCHANGED(NumberofExistingUnsubscribes__c) || ISCHANGED(NumberofHardBounces__c) || ISCHANGED(NumberofSoftBounces__c) || ISCHANGED(NumberofSubscribersForwardingEmail__c) || ISCHANGED(NumberofTotalOpens__c) || ISCHANGED(NumberofUniqueClicks__c) || ISCHANGED(NumberofUniqueOpens__c) || ISCHANGED(NumberSent__c) || ISCHANGED(NumberUnsubscribed__c) || ISCHANGED(NumberofTotalClicks__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

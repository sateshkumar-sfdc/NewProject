<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Status_to_D</fullName>
        <field>Status__c</field>
        <literalValue>D</literalValue>
        <name>Update Status to &quot;D&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update ERP Cust Num</fullName>
        <active>false</active>
        <criteriaItems>
            <field>ET_Subscribers__c.Name</field>
            <operation>notEqual</operation>
            <value>0</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Updating Status to %22D%22</fullName>
        <actions>
            <name>Update_Status_to_D</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ET_Subscribers__c.ET_Subscription_Status__c</field>
            <operation>equals</operation>
            <value>Unsubscribed</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

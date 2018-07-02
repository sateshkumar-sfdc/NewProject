<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Credit_Card_Send_To_ERP</fullName>
        <field>Send_To_ERP__c</field>
        <literalValue>1</literalValue>
        <name>Credit Card - Send To ERP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Credit Card - Send To ERP</fullName>
        <actions>
            <name>Credit_Card_Send_To_ERP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(Sync_with_ERP__c, NOT(Send_To_ERP__c), NOT(PRIORVALUE(Send_To_ERP__c)),  $User.Id != &apos;005i0000001CQCm&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Credit Card - Set Owner</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Credit_Card__c.OwnerId</field>
            <operation>notEqual</operation>
            <value>ATS Integration</value>
        </criteriaItems>
        <description>Set owner to integration user (to hide inactive cards via private security model).</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>

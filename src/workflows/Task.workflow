<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Close_Task</fullName>
        <description>Updates the task Status to completed</description>
        <field>Status</field>
        <literalValue>Completed</literalValue>
        <name>Close Task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Close Task</fullName>
        <actions>
            <name>Close_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Task.Close_Tasks__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Used to close multiple tasks from a list view</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

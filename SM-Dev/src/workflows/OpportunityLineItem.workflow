<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Opportunity_Product_Discount</fullName>
        <description>Set Discount based on Discount Percent picklist.</description>
        <field>Discount</field>
        <formula>VALUE(TEXT(Discount_Percent__c))/100</formula>
        <name>Opportunity Product - Discount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Prod_Need_by_Date_Today</fullName>
        <field>Need_By_Date__c</field>
        <formula>Opportunity.Need_By_Date__c</formula>
        <name>Oppty Prod: Need by Date Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Need By Date updated</fullName>
        <actions>
            <name>Oppty_Prod_Need_by_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Need_By_Date__c &lt; Opportunity.Need_By_Date__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Product - Discount</fullName>
        <actions>
            <name>Opportunity_Product_Discount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Set Discount based on Discount Percent picklist</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

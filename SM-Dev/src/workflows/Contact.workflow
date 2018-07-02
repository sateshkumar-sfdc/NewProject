<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Dealer_Welcome_Email</fullName>
        <description>New Dealer Welcome Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Dealer_Welcome</template>
    </alerts>
    <fieldUpdates>
        <fullName>Contact_Email_Address_Changed</fullName>
        <description>This marks Email Address Changed on Contact object, when the Email Address has changed where the previous value is not NULL.</description>
        <field>Email_Address_Changed__c</field>
        <literalValue>1</literalValue>
        <name>Contact - Email Address Changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mapping_Lead_and_Contact_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Canada_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Mapping Lead and Contact RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contact - Email Address Changed</fullName>
        <actions>
            <name>Contact_Email_Address_Changed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule fires when email address value has changed. Also note that the previous value is not NULL.</description>
        <formula>AND(NOT(ISBLANK(Email)),ISCHANGED(Email))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact - New Dealer Welcome Email</fullName>
        <actions>
            <name>New_Dealer_Welcome_Email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Contact.Converted_from_Lead__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Mapping Lead and Contact RT</fullName>
        <actions>
            <name>Mapping_Lead_and_Contact_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.LeadconversionRT__c</field>
            <operation>equals</operation>
            <value>Dealer Canada</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>

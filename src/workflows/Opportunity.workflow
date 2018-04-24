<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Approval_Status_Approved</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Pending</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Pending</literalValue>
        <name>Approval Status Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Status_Rejected</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mapping_Lead_and_Opportunity_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Canada_Insides_Sales_Field_Sales</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Mapping Lead and Opportunity RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Closed_Won</fullName>
        <field>StageName</field>
        <literalValue>Closed Won</literalValue>
        <name>Opportunity -Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Sales_Order_Processing</fullName>
        <field>StageName</field>
        <literalValue>Processing</literalValue>
        <name>Opportunity - Sales Order Processing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Sample_Order_Created</fullName>
        <field>StageName</field>
        <literalValue>Sample Order Created</literalValue>
        <name>Opportunity - Sample Order Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Sample_Order_PO_Number</fullName>
        <field>PO_Number__c</field>
        <formula>&apos;Welcome Kit&apos;</formula>
        <name>Opportunity - Sample Order PO Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Sample_Order_Requested</fullName>
        <field>StageName</field>
        <literalValue>Sample Order Requested</literalValue>
        <name>Opportunity - Sample Order Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Need_by_Date_Today</fullName>
        <field>Need_By_Date__c</field>
        <formula>Today()</formula>
        <name>Oppty: Need by Date Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_Quote_Completed</fullName>
        <field>StageName</field>
        <literalValue>Quote Created</literalValue>
        <name>Update Stage- Quote Completed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updated_Closed_In_Current_Year_Flag</fullName>
        <field>Closed_In_Current_Year__c</field>
        <literalValue>1</literalValue>
        <name>Updated Closed In Current Year Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Mapping Lead and Opportunity RT</fullName>
        <actions>
            <name>Mapping_Lead_and_Opportunity_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.LeadConversionRT__c</field>
            <operation>equals</operation>
            <value>Dealer Canada</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Closed Won</fullName>
        <actions>
            <name>Opportunity_Closed_Won</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordType.Name &lt;&gt; &apos;Sample Order&apos;, Sales_Order__c &lt;&gt; &apos;&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Need by Date Passed</fullName>
        <actions>
            <name>Oppty_Need_by_Date_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Sales_Order__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Need_By_Date__c</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>If need by date is in the past when order is sent to ERP, update Need by date to today</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Sales Order Processing</fullName>
        <actions>
            <name>Opportunity_Sales_Order_Processing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordType.Name &lt;&gt; &apos;Sample Order&apos;, Send_To_ERP__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Sample Order Created</fullName>
        <actions>
            <name>Opportunity_Sample_Order_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordType.Name = &apos;Sample Order&apos;, Sales_Order__c &lt;&gt; &apos;&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Sample Order PO Number</fullName>
        <actions>
            <name>Opportunity_Sample_Order_PO_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordType.Name = &apos;Sample Order&apos;, PO_Number__c = &apos;&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity - Sample Order Requested</fullName>
        <actions>
            <name>Opportunity_Sample_Order_Requested</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordType.Name = &apos;Sample Order&apos;, Send_To_ERP__c = true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Stage-Quote</fullName>
        <actions>
            <name>Update_Stage_Quote_Completed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.ENSX_EDM__Quote_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Stage to Quote Created if there is a Quote Number</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Updated Closed In Current Year Flag</fullName>
        <actions>
            <name>Updated_Closed_In_Current_Year_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>IF(YEAR(CloseDate)==YEAR(TODAY()),true,false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

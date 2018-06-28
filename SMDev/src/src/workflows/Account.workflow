<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Lead_is_converted_into_an_Account</fullName>
        <description>Lead is converted into an Account</description>
        <protected>false</protected>
        <recipients>
            <type>campaignMemberDerivedOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Lead_is_converted_into_an_Account</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Billing_City_to_Shipping_City</fullName>
        <field>ShippingCity</field>
        <formula>BillingCity</formula>
        <name>Account - Billing City to Shipping City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Billing_Country_to_Shipping_Co</fullName>
        <field>ShippingCountry</field>
        <formula>BillingCountry</formula>
        <name>Account - Billing Country to Shipping Co</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Billing_Latitude_to_Shipping_L</fullName>
        <field>ShippingLatitude</field>
        <formula>BillingLatitude</formula>
        <name>Account - Billing Latitude to Shipping L</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Billing_Longitude_to_Shipping</fullName>
        <field>ShippingLongitude</field>
        <formula>BillingLongitude</formula>
        <name>Account - Billing Longitude to Shipping</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Billing_State_to_Shipping_Stat</fullName>
        <field>ShippingState</field>
        <formula>BillingState</formula>
        <name>Account - Billing State to Shipping Stat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Billing_Street_to_Shipping_Str</fullName>
        <field>ShippingStreet</field>
        <formula>BillingStreet</formula>
        <name>Account - Billing Street to Shipping Str</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Billing_Zip_to_Shipping_Zip</fullName>
        <field>ShippingPostalCode</field>
        <formula>BillingPostalCode</formula>
        <name>Account - Billing Zip to Shipping Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inside_SalesRep_Update</fullName>
        <field>Inside_Sales_Rep__c</field>
        <formula>CASE( SalesRepCode__c , 
&quot;troach&quot;, &quot;Stephanie Stafford&quot;, 
&quot;dmitchum&quot;, &quot;Larissa Vallejo&quot;, 
&quot;kmiller&quot;, &quot;Mimi Fuchs&quot;, 
&quot;mkasok&quot;, &quot;Larissa Vallejo&quot;,
&quot;egeary&quot;, &quot;Mimi Fuchs&quot;,
&quot;cfoltz&quot;, &quot;Cassie Martin&quot;,
&quot;arussell&quot;, &quot;Josh Wright&quot;, 
&quot;pbrowne&quot;, &quot;Cassie Martin&quot;,
&quot;befird&quot;, &quot;Melanie Hay&quot;,
&quot;ksmyth&quot;, &quot;Melanie Hay&quot;,
&quot;rsalinas&quot;, &quot;Josh Wright&quot;,
&quot;wosborne&quot;, &quot;Mike Demeo&quot;,
&quot;cfallin&quot;, &quot;Whitney Worthington&quot;,
&quot;mdickson&quot;, &quot;Melissa Ford&quot;,
&quot;mestey&quot;, &quot;Megan Morales&quot;, 
&quot;kgriffin&quot;, &quot;Jake Drees&quot;,
&quot;tcreasy&quot;, &quot;Megan Morales&quot;,
&quot;rlientz&quot;, &quot;Scotty Walkwitz&quot;, 
&quot;cday&quot;, &quot;Whitney Worthington&quot;, 
&quot;cwithrow&quot;, &quot;Kyle Davis&quot;, 
&quot;jliver&quot;, &quot;Ryan Davidson&quot;, 
&quot;wspann&quot;, &quot;Kyle Davis&quot;, 
&quot;jmarquar&quot;, &quot;April Obersteller&quot;, 
&quot;jmersber&quot;, &quot;Katy Young&quot;, 
&quot;jneeley&quot;, &quot;Chris Hogan&quot;, 
&quot;cjones&quot;, &quot;Katy Young&quot;, 
&quot;dpmartso&quot;, &quot;April Obersteller&quot;, 
&quot;kcogdill&quot;, &quot;Bethany Franklin&quot;, 
&quot;bmcneil&quot;, &quot;Matt Dillahunty&quot;, 
&quot;bworth&quot;, &quot;Matt Dillahunty&quot;, 
&quot;pfurlow&quot;, &quot;Stuart Folkes&quot;, 
&quot;mthorn&quot;, &quot;Erin Zeto&quot;, 
&quot;lparris&quot;, &quot;Johannah Niles&quot;, 
&quot;jworkman&quot;, &quot;Erica Cicero&quot;, 
&quot;ctynes&quot;, &quot;Will Adams&quot;, 
&quot;belkins&quot;, &quot;Johannah Niles&quot;, 
&quot;mbitter&quot;, &quot;Erica Cicero&quot;, 
&quot;twalsh&quot;, &quot;Cheryl Stanton&quot;, 
&quot;cscott&quot;, &quot;Jonathan Wyrick&quot;, 
&quot;jholt&quot;, &quot;Cheryl Stanton&quot;, 
&quot;dduty&quot;, &quot;Trevor Stewart&quot;, 
&quot;cdrews&quot;, &quot;Trevor Stewart&quot;,
&quot;jsanders&quot;, &quot;Jonathan Wyrick&quot;,  
&quot;YETI&quot;, &quot;YETI&quot;, 
&quot;&quot;)</formula>
        <name>Inside SalesRep Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Mapping_Lead_and_Account_RT</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Canada</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Mapping Lead and Account RT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Ship_To_Sales_Rep</fullName>
        <field>SalesRepCode__c</field>
        <formula>Parent.SalesRepCode__c</formula>
        <name>Ship To Sales Rep</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Credit_Hold</fullName>
        <field>Credit_Hold__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Credit Hold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Credit_Hold</fullName>
        <field>Credit_Hold__c</field>
        <literalValue>1</literalValue>
        <name>Update Credit Hold</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Account - Billing Address to Shipping Address</fullName>
        <actions>
            <name>Account_Billing_City_to_Shipping_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Billing_Country_to_Shipping_Co</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Billing_Latitude_to_Shipping_L</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Billing_Longitude_to_Shipping</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Billing_State_to_Shipping_Stat</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Billing_Street_to_Shipping_Str</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Account_Billing_Zip_to_Shipping_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Was_Lead__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account - Complete Tax Exempt Documentation</fullName>
        <actions>
            <name>Complete_Tax_Exempt_Documentation</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Account.Tax_Exempt__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Hold Checked</fullName>
        <actions>
            <name>Update_Credit_Hold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Utilization_Horizon__c</field>
            <operation>greaterOrEqual</operation>
            <value>100</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Credit Hold Unchecked</fullName>
        <actions>
            <name>Uncheck_Credit_Hold</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Utilization_Horizon__c</field>
            <operation>lessThan</operation>
            <value>100</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead is converted into an Account</fullName>
        <actions>
            <name>Lead_is_converted_into_an_Account</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Was_Lead__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Lead is converted into an Account</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Mapping Lead and Account RT</fullName>
        <actions>
            <name>Mapping_Lead_and_Account_RT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.LeadconversionRT__c</field>
            <operation>equals</operation>
            <value>Dealer Canada</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Complete_Tax_Exempt_Documentation</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>14</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Complete Tax Exempt Documentation</subject>
    </tasks>
</Workflow>

<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Delayed_Response_Rule</fullName>
        <description>Delayed Response Rule</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>customerservice@yeti.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/Delayed_Response_Rule</template>
    </alerts>
    <alerts>
        <fullName>Email_Program_Information</fullName>
        <description>Email Program Information</description>
        <protected>false</protected>
        <recipients>
            <field>Web_Form_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>customlogo@yeti.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Team_automated/Custom_Logo_Program_Information</template>
    </alerts>
    <alerts>
        <fullName>Notify_Dealer_Non_Business_Hours</fullName>
        <description>Notify Dealer - Non Business Hours</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>sales@yeti.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Team_automated/Notify_Dealer_Non_Business_Hours</template>
    </alerts>
    <alerts>
        <fullName>Notify_Dealer_Open_4hrs</fullName>
        <description>Notify Dealer - Open 4hrs</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>sales@yeti.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Team_automated/Notify_Dealer_Open_4hrs</template>
    </alerts>
    <alerts>
        <fullName>Notify_Manager</fullName>
        <description>Notify Manager</description>
        <protected>false</protected>
        <recipients>
            <recipient>Escalated</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>Support_Team_automated/Case_Escalation</template>
    </alerts>
    <alerts>
        <fullName>Notify_Outfitter_Non_Business_Hours</fullName>
        <description>Notify Outfitter - Non Business Hours</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>customerservice@yeti.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Team_automated/Notify_Outfitter_Non_Business_Hours</template>
    </alerts>
    <alerts>
        <fullName>Notify_Outfitter_Open_4hrs</fullName>
        <description>Notify Outfitter - Open 4hrs</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>customerservice@yeti.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Team_automated/Notify_Outfitter_Open_4hrs</template>
    </alerts>
    <alerts>
        <fullName>OOO_for_Dealers_on_July_29</fullName>
        <description>OOO for Dealers on July 29</description>
        <protected>false</protected>
        <recipients>
            <recipient>cgarcia@yeticoolers.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sales@yeti.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Support_Team_automated/OOO_July_29_Dealers</template>
    </alerts>
    <fieldUpdates>
        <fullName>Case_Owner_Outfitter_RMA</fullName>
        <field>OwnerId</field>
        <lookupValue>Outfitter_RMA</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner: Outfitter RMA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Owner_to_Logan</fullName>
        <field>OwnerId</field>
        <lookupValue>lretzer@yeticoolers.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Case Owner To Logan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Outfitter</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Case Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Record_Type_Custom_Logo</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Custom_Logo</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Case Record Type-Custom Logo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Send_To_ERP</fullName>
        <field>Send_To_ERP__c</field>
        <literalValue>1</literalValue>
        <name>Case - Send To ERP</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Owner_for_Pronghorn</fullName>
        <description>Change owner to Katie Walske</description>
        <field>OwnerId</field>
        <lookupValue>kwalske@yeticoolers.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Change Owner for Pronghorn</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_FedEx_Cases</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close FedEx Cases</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_Sticker_Catalog</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close Sticker/Catalog</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Case_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Dealer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Dealer Case Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dealer_Type_Updated</fullName>
        <field>Type</field>
        <literalValue>Dealer</literalValue>
        <name>Dealer Type Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Outfitter_Case_Owner_Changes_Type</fullName>
        <field>Type</field>
        <literalValue>Outfitter</literalValue>
        <name>Outfitter-Case Owner Changes Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Outfitter_Case_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Outfitter</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Outfitter Case Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RMA_Queue_update</fullName>
        <field>OwnerId</field>
        <lookupValue>Outfitter_RMA</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>RMA Queue update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Current_Status</fullName>
        <field>Updated_Status__c</field>
        <formula>TEXT( Status )</formula>
        <name>Set Current Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Severely_Dissatisfied_Customer</fullName>
        <field>OwnerId</field>
        <lookupValue>Outfitter</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Severely Dissatisfied Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Working_to_New</fullName>
        <description>Change status from working to new if the user moves Case from My Cases to Case Queue</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>Status:Working to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Temp_queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Temps</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Temp queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_Email_Response</fullName>
        <field>Email_Response__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Email Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Owner_To_Escalated_Queue</fullName>
        <field>OwnerId</field>
        <lookupValue>Escalated</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case Owner To Escalated Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Record_Type_Custom_Logo</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Custom_Logo</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Case Record Type -Custom Logo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Record_Type_Dealer</fullName>
        <description>Updating Case Record Type automatically after TYPE field is updated</description>
        <field>RecordTypeId</field>
        <lookupValue>Dealer</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Case Record Type-Dealer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Record_Type_Outfitter</fullName>
        <description>Updating Case Record Type automatically after TYPE field is updated</description>
        <field>RecordTypeId</field>
        <lookupValue>Outfitter</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Case Record Type-Outfitter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_to_Awaiting_Logo</fullName>
        <field>Status</field>
        <literalValue>Awaiting Response</literalValue>
        <name>Update Case Status to Awaiting (Logo)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_to_Closed_Logo</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update Case Status to Closed (Logo)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_to_Closed_Outfitter</fullName>
        <description>Close case if status is New and subject is voicemail</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update Case Status to Closed (Outfitter)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_to_Working_Logo</fullName>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Update Case Status to Working (Logo)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_to_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update Case to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_to_YETI_Admin</fullName>
        <field>OwnerId</field>
        <lookupValue>yetiadmin@yeticoolers.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Update Case to YETI Admin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Working</fullName>
        <description>Update status to working when a user Accepts the Case</description>
        <field>Status</field>
        <literalValue>Working</literalValue>
        <name>Update Status to Working</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Approval Received Tasks %28Custom Logo%29</fullName>
        <actions>
            <name>Burn_Coolers_with_Custom_Logo</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Approved_Proof_to_MIG</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Final_Payment_Request_to_Customer</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Payment_Request_to_Customer</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Ship_Order_to_Customer</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Update_Order_Status_in_ERP</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Approval_Received__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Custom Logo</value>
        </criteriaItems>
        <description>Create a series of tasks when the &quot;Approval Received&quot; checkbox is checked.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case - Send To ERP</fullName>
        <actions>
            <name>Case_Send_To_ERP</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>AND(Sync_with_ERP__c = true, PRIORVALUE(Send_To_ERP__c) &lt;&gt; true, LastModifiedBy.Profile.Name  &lt;&gt; &apos;Integration&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Escalation</fullName>
        <actions>
            <name>Notify_Manager</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Case_Owner_To_Escalated_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Escalated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Dealer,Outfitter</value>
        </criteriaItems>
        <description>Change the owner to the escalated queue and notify the escalated queue members when the case status is changed to escalated.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Open - 4 Hours</fullName>
        <active>true</active>
        <description>Store case status after 4 hours of creation in a field
8AM - 5PM CST  = 1PM - 10PM GMT = 13 -22 in 24 hr format</description>
        <formula>AND(  MOD( DATEVALUE(CreatedDate) - DATE(1900, 1, 6), 7) &gt;= 2,  VALUE(MID(TEXT(CreatedDate),12,2)) &gt;= 13,  VALUE(MID(TEXT(CreatedDate),12,2)) &lt;= 22,  NOT($Setup.Holidays__c.Christmas_Day__c = DATEVALUE(CreatedDate)),  NOT($Setup.Holidays__c.Christmas_Eve__c = DATEVALUE(CreatedDate)),  NOT($Setup.Holidays__c.Day_After_Thanksgiving__c = DATEVALUE(CreatedDate)),  NOT($Setup.Holidays__c.Independence_Day__c = DATEVALUE(CreatedDate)),  NOT($Setup.Holidays__c.Labor_Day__c = DATEVALUE(CreatedDate)),  NOT($Setup.Holidays__c.Memorial_Day__c = DATEVALUE(CreatedDate)),  NOT($Setup.Holidays__c.New_Years_Day__c = DATEVALUE(CreatedDate)),  NOT($Setup.Holidays__c.New_Years_Eve__c = DATEVALUE(CreatedDate)),  NOT($Setup.Holidays__c.Thanksgiving_Day__c = DATEVALUE(CreatedDate) )           )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Set_Current_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case Open - Non Business Hours - Dealer</fullName>
        <actions>
            <name>Notify_Dealer_Non_Business_Hours</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email notification to the dealer when a case is created via email or web form during non business hrs.
7AM - 6PM CST  = 1PM - 10PM GMT = 12 -23 in 24 hr format</description>
        <formula>AND( RecordType.Name = &apos;Dealer&apos;, OR(MOD( DATEVALUE(CreatedDate)  - DATE(1900, 1, 6), 7) &lt; 2, VALUE(MID(TEXT(CreatedDate),12,2))&lt;12, VALUE(MID(TEXT(CreatedDate),12,2))&gt;23,  $Setup.Holidays__c.Christmas_Day__c =  DATEVALUE(CreatedDate),  $Setup.Holidays__c.Christmas_Eve__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.Day_After_Thanksgiving__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.Independence_Day__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.Labor_Day__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.Memorial_Day__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.New_Years_Day__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.New_Years_Eve__c  = DATEVALUE(CreatedDate), $Setup.Holidays__c.Thanksgiving_Day__c = DATEVALUE(CreatedDate) ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Open - Non Business Hours - Outfitter</fullName>
        <actions>
            <name>Notify_Outfitter_Non_Business_Hours</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email notification to the outfitter when a case is created via email or web form during non business hrs.
8AM - 6PM CST  = 1PM - 10PM GMT = 13 -23 in 24 hr format</description>
        <formula>AND( RecordType.Name = &apos;Outfitter&apos;, OR(MOD( DATEVALUE(CreatedDate) - DATE(1900, 1, 6), 7) &lt; 2,  VALUE(MID(TEXT(CreatedDate),12,2))&lt;13,  VALUE(MID(TEXT(CreatedDate),12,2))&gt;23,  $Setup.Holidays__c.Christmas_Day__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.Christmas_Eve__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.Day_After_Thanksgiving__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.Independence_Day__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.Labor_Day__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.Memorial_Day__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.New_Years_Day__c = DATEVALUE(CreatedDate),  $Setup.Holidays__c.New_Years_Eve__c = DATEVALUE(CreatedDate), $Setup.Holidays__c.Thanksgiving_Day__c = DATEVALUE(CreatedDate)  )  )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Open - Open 4hrs - Dealer</fullName>
        <actions>
            <name>Notify_Dealer_Open_4hrs</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email notification to the dealer when a case is created during business hrs and the status is still new after 4 hrs.</description>
        <formula>AND( ISCHANGED(Updated_Status__c),  ISPICKVAL(Status, &apos;Routing&apos;),     RecordType.Name = &apos;Dealer&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Open - Open 4hrs - Outfitter</fullName>
        <actions>
            <name>Notify_Outfitter_Open_4hrs</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send an email notification to the outfitter when a case is created during business hrs and the status is still new after 4 hrs.</description>
        <formula>AND(  ISCHANGED(Updated_Status__c),  ISPICKVAL(Status, &apos;Routing&apos;), RecordType.Name = &apos;Outfitter&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Record Type-Custom Logo</fullName>
        <actions>
            <name>Case_Record_Type_Custom_Logo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Custom Logo</value>
        </criteriaItems>
        <description>When Type is transferred, case record type updates automatically</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Record Type-Dealer</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <description>When Type is transferred, case record type updates automatically</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Record Type-Outfitter</fullName>
        <actions>
            <name>Case_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Outfitter</value>
        </criteriaItems>
        <description>When Type is transferred, case record type updates automatically</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Type-Custom Logo</fullName>
        <actions>
            <name>Update_Case_Record_Type_Custom_Logo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Custom Logo</value>
        </criteriaItems>
        <description>Updating Case Record Type automatically after TYPE field is updated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Type-Dealer</fullName>
        <actions>
            <name>Update_Case_Record_Type_Dealer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <description>Updating Case Record Type automatically after TYPE field is updated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Type-Outfitter</fullName>
        <actions>
            <name>Update_Case_Record_Type_Outfitter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Outfitter</value>
        </criteriaItems>
        <description>Updating Case Record Type automatically after TYPE field is updated</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case to Awaiting Response %28Logo%29</fullName>
        <actions>
            <name>Update_Case_Status_to_Awaiting_Logo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Custom Logo</value>
        </criteriaItems>
        <description>Update the case status to &quot;Awaiting Response&quot; when the case is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case to Closed %28Logo%29</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Custom Logo</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Awaiting Response</value>
        </criteriaItems>
        <description>Update the case status to &quot;Closed&quot; when the case has been in a &quot;Awaiting Response&quot; status for 72 hrs.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Case_Status_to_Closed_Logo</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case to Closed Voicemail %28Outfitter%29</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outfitter</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>new message</value>
        </criteriaItems>
        <description>Update the case status to &quot;Closed&quot; when the voicemail case has been in a &quot;New&quot; status for 72 hrs.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Case_Status_to_Closed_Outfitter</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case to Working %28Logo%29</fullName>
        <actions>
            <name>Update_Case_Status_to_Working_Logo</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Create_Logo_Parts_in_ERP</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Artwork_to_MIG</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_PO_to_MIG</name>
            <type>Task</type>
        </actions>
        <actions>
            <name>Send_Proof_to_Customer</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Artwork_Received__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Custom Logo</value>
        </criteriaItems>
        <description>Update the case status to working when the &quot;Artwork Received&quot; checkbox is checked and then create a series of tasks.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Catalog%2FSticker Request - Auto Close Case</fullName>
        <actions>
            <name>Update_Case_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_to_YETI_Admin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Requsting_Item__c</field>
            <operation>equals</operation>
            <value>Catalogue,Sticker</value>
        </criteriaItems>
        <description>Automatically close Catalog/Sticker request cases and update the owner to the YETI admin user.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Close Case %28Fed Ex Shipment%29</fullName>
        <actions>
            <name>Close_FedEx_Cases</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>FedEx Shipment,Tendered to FedEx</value>
        </criteriaItems>
        <description>Close cases that are dealing with trackingupdates@fedex.com</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Custom Logo Email Program Information</fullName>
        <actions>
            <name>Email_Program_Information</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Custom Logo</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <description>Send email with PDF instructions to the customer when the case is created via web.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Dealer-Case Owner Changes Type</fullName>
        <actions>
            <name>Dealer_Case_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Dealer_Type_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Delayed Response Rule</fullName>
        <actions>
            <name>Delayed_Response_Rule</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outfitter</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Move to RMA Queue</fullName>
        <actions>
            <name>RMA_Queue_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>YETI: Shipment for RMA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>YETI Product Return Label</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>YETI Return Form</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Move to Temp Queue</fullName>
        <actions>
            <name>Temp_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Dealer Employee Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Friends &amp; Family Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Pro Guide Application</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outfitter</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NRA Email Setup</fullName>
        <actions>
            <name>Case_Owner_to_Logan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>NRA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>N.R.A.</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>National Rifle association</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>OOO July 29 - Dealer</fullName>
        <actions>
            <name>OOO_for_Dealers_on_July_29</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Dealer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Public Email</value>
        </criteriaItems>
        <description>OOO</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Outfitter-Case Owner Changes Type</fullName>
        <actions>
            <name>Outfitter_Case_Owner_Changes_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Outfitter_Case_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Outfitter</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Pronghorn Emails</fullName>
        <actions>
            <name>Change_Owner_for_Pronghorn</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>contains</operation>
            <value>@optivations.com</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Severely Dissatisfied Customer</fullName>
        <actions>
            <name>Severely_Dissatisfied_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Severely Dissatisfied Customer</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck Email Response</fullName>
        <actions>
            <name>Uncheck_Email_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Uncheck the email response field when the case is modified.</description>
        <formula>AND(Email_Response__c = True, NOT(ISCHANGED(Email_Response__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Status to New if User Changes to Queue</fullName>
        <actions>
            <name>Status_Working_to_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Dealer,Outfitter</value>
        </criteriaItems>
        <description>Update Status to New if User Changes Owner to Outfitter/Dealer Queue if they accidentally accept a case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Status to Working After Owner Accepts</fullName>
        <actions>
            <name>Update_Status_to_Working</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>Outfitter Queue,RMA Queue</value>
        </criteriaItems>
        <description>When User clicks Accept, the status changes to Working automatically</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>warranty cases routed to the %E2%80%9COutfitter RMA%E2%80%9D</fullName>
        <actions>
            <name>Case_Owner_Outfitter_RMA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>startsWith</operation>
            <value>Warranty Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Web</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Outfitter</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Burn_Coolers_with_Custom_Logo</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>g. Burn Coolers with Custom Logo</subject>
    </tasks>
    <tasks>
        <fullName>Create_Logo_Parts_in_ERP</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>c. Create Logo Parts in ERP</subject>
    </tasks>
    <tasks>
        <fullName>Send_Approved_Proof_to_MIG</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>f. Send Approved Proof to MIG</subject>
    </tasks>
    <tasks>
        <fullName>Send_Artwork_to_MIG</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>a. Send Artwork to MIG</subject>
    </tasks>
    <tasks>
        <fullName>Send_Final_Payment_Request_to_Customer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>9</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>j. Send Final Payment Request to Customer</subject>
    </tasks>
    <tasks>
        <fullName>Send_PO_to_MIG</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>3</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>b. Send PO to MIG</subject>
    </tasks>
    <tasks>
        <fullName>Send_Payment_Request_to_Customer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>e. Send Payment Request to Customer</subject>
    </tasks>
    <tasks>
        <fullName>Send_Proof_to_Customer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>5</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>d. Send Proof to Customer</subject>
    </tasks>
    <tasks>
        <fullName>Ship_Order_to_Customer</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>h. Ship Order to Customer</subject>
    </tasks>
    <tasks>
        <fullName>Update_Order_Status_in_ERP</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>i. Update Order Status in ERP</subject>
    </tasks>
</Workflow>

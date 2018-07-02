<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EmbellishedArtSetYETIKeyToArtName</fullName>
        <description>This field update is used to update the YETI Key field with the Art Name field if YETI Key is already not populated by the user.</description>
        <field>ArtYETIKey__c</field>
        <formula>IF((RIGHT(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE((SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(ArtName__c , &quot; &quot;, &quot;-&quot;) , &quot;&amp;&quot;, &quot;-&quot;) , &quot;)&quot;, &quot; &quot;) , &quot;(&quot;, &quot; &quot;) , &quot;&apos;&quot;, &quot;&quot;), &quot;.&quot;, &quot;&quot;)), &quot;/&quot;, &apos;-&apos;)
,&quot;#&quot;,&quot;&quot;),&quot;    &quot;, &quot;-&quot;),&quot;   &quot;, &quot;-&quot;),&quot;  &quot;,&quot;-&quot;),&quot;  &quot;,&quot;-&quot;),&quot; &quot;,&quot;-&quot;),&quot;----&quot;,&quot;-&quot;),&quot;---&quot;,&quot;-&quot;),&quot;--&quot;,&quot;-&quot;),&quot;--&quot;,&quot;-&quot;), 1) = &apos;-&apos;), TRIM(LEFT(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE((SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(ArtName__c , &quot; &quot;, &quot;-&quot;) , &quot;&amp;&quot;, &quot;-&quot;) , &quot;)&quot;, &quot; &quot;) , &quot;(&quot;, &quot; &quot;) , &quot;&apos;&quot;, &quot;&quot;), &quot;.&quot;, &quot;&quot;)), &quot;/&quot;, &apos;-&apos;)
,&quot;#&quot;,&quot;&quot;),&quot;    &quot;, &quot;-&quot;),&quot;   &quot;, &quot;-&quot;),&quot;  &quot;,&quot;-&quot;),&quot;  &quot;,&quot;-&quot;),&quot; &quot;,&quot;-&quot;),&quot;----&quot;,&quot;-&quot;),&quot;---&quot;,&quot;-&quot;),&quot;--&quot;,&quot;-&quot;),&quot;--&quot;,&quot;-&quot;),LEN(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE((SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(ArtName__c , &quot; &quot;, &quot;-&quot;) , &quot;&amp;&quot;, &quot;-&quot;) , &quot;)&quot;, &quot; &quot;) , &quot;(&quot;, &quot; &quot;) , &quot;&apos;&quot;, &quot;&quot;), &quot;.&quot;, &quot;&quot;)), &quot;/&quot;, &apos;-&apos;)
,&quot;#&quot;,&quot;&quot;),&quot;    &quot;, &quot;-&quot;),&quot;   &quot;, &quot;-&quot;),&quot;  &quot;,&quot;-&quot;),&quot;  &quot;,&quot;-&quot;),&quot; &quot;,&quot;-&quot;),&quot;----&quot;,&quot;-&quot;),&quot;---&quot;,&quot;-&quot;),&quot;--&quot;,&quot;-&quot;),&quot;--&quot;,&quot;-&quot;))-1)), SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE((SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(SUBSTITUTE(ArtName__c , &quot; &quot;, &quot;-&quot;) , &quot;&amp;&quot;, &quot;-&quot;) , &quot;)&quot;, &quot; &quot;) , &quot;(&quot;, &quot; &quot;) , &quot;&apos;&quot;, &quot;&quot;), &quot;.&quot;, &quot;&quot;)), &quot;/&quot;, &apos;-&apos;)
,&quot;#&quot;,&quot;&quot;),&quot;    &quot;, &quot;-&quot;),&quot;   &quot;, &quot;-&quot;),&quot;  &quot;,&quot;-&quot;),&quot;  &quot;,&quot;-&quot;),&quot; &quot;,&quot;-&quot;),&quot;----&quot;,&quot;-&quot;),&quot;---&quot;,&quot;-&quot;),&quot;--&quot;,&quot;-&quot;),&quot;--&quot;,&quot;-&quot;))</formula>
        <name>EmbellishedArt:Set YETIKey to ArtName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Embellished Art %3A Populate YETI-Key</fullName>
        <actions>
            <name>EmbellishedArtSetYETIKeyToArtName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmbellishedArt__c.ArtYETIKey__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>EmbellishedArt__c.ArtName__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow evaluates to populate YETI Key (if empty) from the Art Name field.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>

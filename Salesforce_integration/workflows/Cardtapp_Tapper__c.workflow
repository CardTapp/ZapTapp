<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Cardtapp_Existing_Contact_found</fullName>
        <description>Cardtapp - Existing Contact found</description>
        <protected>false</protected>
        <recipients>
            <field>Salesforce_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>support@cardtapp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cardtapp_Email_Templates/Cardtapp_Existing_Contact_found</template>
    </alerts>
    <alerts>
        <fullName>Cardtapp_Existing_Lead_found</fullName>
        <description>Cardtapp - Existing Lead found</description>
        <protected>false</protected>
        <recipients>
            <field>Salesforce_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>support@cardtapp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cardtapp_Email_Templates/Cardtapp_Existing_Lead_found</template>
    </alerts>
    <alerts>
        <fullName>Cardtapp_New_Lead_created</fullName>
        <description>Cardtapp - New Lead created</description>
        <protected>false</protected>
        <recipients>
            <field>Salesforce_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>support@cardtapp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cardtapp_Email_Templates/Cardtapp_New_Lead_createdCardtapp_New_Contact_created</template>
    </alerts>
    <alerts>
        <fullName>Email_User_that_Cardtapp_Tapper_has_been_created_in_SF</fullName>
        <description>Cardtapp - New Contact created</description>
        <protected>false</protected>
        <recipients>
            <field>Salesforce_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>support@cardtapp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cardtapp_Email_Templates/Cardtapp_New_Contact_created</template>
    </alerts>
    <alerts>
        <fullName>Email_User_that_Cardtapp_Tapper_has_been_created_in_SF_not_attached</fullName>
        <description>Cardtapp - Ambiguous lead/contact found</description>
        <protected>false</protected>
        <recipients>
            <field>Salesforce_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>support@cardtapp.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cardtapp_Email_Templates/Cardtapp_Ambiguous_lead_contact_found</template>
    </alerts>
    <rules>
        <fullName>Cardtapp - Ambiguous lead%2Fcontact found</fullName>
        <actions>
            <name>Email_User_that_Cardtapp_Tapper_has_been_created_in_SF_not_attached</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(    Notify_Ambiguous_lead_contact_found__c ,     Workflow_action__c = &apos;Ambiguous lead/contact found&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Cardtapp - Existing Contact found</fullName>
        <actions>
            <name>Cardtapp_Existing_Contact_found</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(    Notify_Existing_Contact_found__c ,    Workflow_action__c = &apos;Existing Contact found&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Cardtapp - Existing Lead found</fullName>
        <actions>
            <name>Cardtapp_Existing_Lead_found</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(    Notify_existing_lead_found__c ,    Workflow_action__c = &apos;Existing Lead found&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Cardtapp - New Contact created</fullName>
        <actions>
            <name>Email_User_that_Cardtapp_Tapper_has_been_created_in_SF</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(    Notify_new_contact_created__c ,    Workflow_action__c = &apos;New Contact created&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Cardtapp - New Lead created</fullName>
        <actions>
            <name>Cardtapp_New_Lead_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND(    Notify_new_lead_created__c ,    Workflow_action__c = &apos;New Lead created&apos; )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>

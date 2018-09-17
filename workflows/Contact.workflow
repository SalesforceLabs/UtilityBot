
<!--
 /*
 * Copyright (c) 2018, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 */ -->
<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Verification_Code_Email</fullName>
        <description>Send Verification Code Email</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>UtilityBotEmails/VerificationCodeEmail</template>
    </alerts>
    <fieldUpdates>
        <fullName>Set_Code_Set_Time</fullName>
        <field>Code_Set_Time__c</field>
        <formula>Now()</formula>
        <name>Set Code Set Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Send_Verification_Code</fullName>
        <actions>
            <name>Send_Verification_Code_Email</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_Code_Set_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT ISBLANK(Verification_Code__c) &amp;&amp;  ISCHANGED(Verification_Code__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>

/**
 * Created by Devin on 4/18/2024.
 */
@IsTest
public with sharing class TestNewOutboundANI {
    @IsTest
    static void TestNewFive9Task(){
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockOutBoundAniResponse());

        //Prepare Test by creating two copies of lead. one for before and one for after.
        Lead oldlead = new Lead(
                FirstName='Test',
                LastName='Lead',
                MobilePhone='4022174741',
                ba685ce4_2c28_433a_a4c6_cac18b40f436__c='',
                Company='TestCompany');
        insert oldlead;

        Id leadID = oldlead.Id;
        Test.startTest();

        // Create Task that fires Trigger
        Task task = new Task(WhoId=leadID,Five9__Five9SessionId__c = '123',Five9DNIS__c='4022174741');
        insert task;

        //Get Updated Lead
        Lead newLead = [SELECT Id, ba685ce4_2c28_433a_a4c6_cac18b40f436__c FROM Lead WHERE Id = :leadID];
        // Assert Lead ba6 before task trigger does not equal ba6 after task trigger
        Assert.areNotEqual(
                oldlead.ba685ce4_2c28_433a_a4c6_cac18b40f436__c,
                newLead.ba685ce4_2c28_433a_a4c6_cac18b40f436__c);
    }

}
/**
 * Created by Devin on 5/1/2024.
 */
@isTest
public with sharing class TestFive9Chain2 {


    Master
    Handler
            Helper

        @isTest
        static void testPostVoiceCalltoSF() {
            // set mock response
            Test.setMock(HttpCalloutMock.class, new Five9Chain2MockResponse());

            Lead oldlead = new Lead(
                    FirstName='Test1',
                    LastName='Lead',
                    Company='TestCompany',
                    Status='Open',
                    MobilePhone='4022174741');
            insert oldlead;

            Id leadID = oldlead.Id;


            // Create test Task record
            Task testTask = new Task(
                    Subject = 'Test Task Chain2',
                    Five9DNIS__c = oldlead.MobilePhone,
                    Five9TalkAndHoldTimeInSeconds__c = 60,
                    CreatedDate = Datetime.now(),
                    Five9ANI__c = '987654321',
                    CallType = 'Outbound',
                    Five9__Five9SessionId__c = 'ABC123456789CBACBSAEFG',
                    OwnerId = UserInfo.getUserId(),
                    WhoId = oldlead.Id


            );

            // Call the method to be tested

            Test.startTest();
            insert testTask;
            Lead leadNew = [SELECT id, description FROM Lead WHERE Id = :leadId];

            Test.stopTest();

            System.assertNotEquals(oldlead.Description,leadNew.Description);
            // Add assertions here if needed
            // Example:
            // System.assertEquals(expectedValue, actualValue);
        }


        // Add more test methods as needed to cover other methods in Five9Chain2 class
    }

/**
 * Created by Devin on 5/2/2024.
 */

@IsTest
private class PostVoiceCallChainTest {


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

        insert testTask;

        // Call the method to be tested
        Test.startTest();
        PostVoiceCallChain.PostVoiceCalltoSF(testTask.id);
        Test.stopTest();



        // Add assertions here if needed
        // Example:
        // System.assertEquals(expectedValue, actualValue);
    }


}
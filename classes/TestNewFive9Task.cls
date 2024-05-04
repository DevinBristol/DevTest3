/**
 * Created by Devin on 4/29/2024.
 */

public with sharing class TestNewFive9Task {

    public static void NewTestTask() {
        Task testTask = new Task(
                Subject = 'test',
                OwnerId = System.UserInfo.getUserId(),
                Five9DNIS__c = '4022174741',
                Five9TalkAndHoldTimeInSeconds__c = 15,
                CallType = 'Outbound',
                Five9ANI__c = '4022174741',
                Five9__Five9SessionId__c = 'test',
                WhoId = '00QSu00000428vFMAQ'
        );
        insert testTask;
    }

}
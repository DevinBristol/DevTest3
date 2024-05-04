/**
 * Created by Devin on 4/23/2024.
 */
public with sharing class TestQueableGetAndSetANI {


    public static void createTestLead(){
        Lead ld = new Lead(FirstName='tester',LastName='mctester',MobilePhone='4022174741');
        insert ld;
    }
}
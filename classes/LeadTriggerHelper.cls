/**
 * Created by Devin on 4/23/2024.
 */

public with sharing class LeadTriggerHelper {

    public LeadTriggerHelper() {
        System.debug('Inside LeadTriggerHelper Constructor');
    }
    public void doTask1(List<Lead> newLeads) {
        System.debug('Inside Task 1');
        for(Lead l : newLeads){
            l.Description = l.Description + '10';
        }
        update newLeads;
    }


}
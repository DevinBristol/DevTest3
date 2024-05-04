/**
 * Created by Devin on 4/23/2024.
 */

public class LeadTriggerHandler extends TriggerHandler {

    public override void afterInsert()
    {
        for (Lead ld : (List<Lead>)Trigger.new){
            if(String.isNotBlank(ld.MobilePhone)){
                OutboundANIGetAndSetANI updateLead = new OutboundANIGetAndSetANI();
                OutboundANIGetAndSetANI.GetANI(ld.MobilePhone, ld.Id);
            }
        }
    }

}
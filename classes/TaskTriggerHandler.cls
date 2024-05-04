/**
 * Created by Devin on 4/29/2024.
 */


public class TaskTriggerHandler extends TriggerHandler {


    public List<Task> tasks = (List<Task>)Trigger.new;

    public override void afterInsert() {

        Five9Helper helper = new Five9Helper();
        String TaskJsonString = helper.VCjsonString(tasks);

        Five9Api.TaskToVoiceCall(TaskJsonString);
    }

}
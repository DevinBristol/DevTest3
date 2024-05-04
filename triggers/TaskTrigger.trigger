/**
 * Created by Devin on 4/18/2024.
 */

trigger TaskTrigger on Task (after insert) {
            {
                new TaskTriggerHandler().run();
            }
        }
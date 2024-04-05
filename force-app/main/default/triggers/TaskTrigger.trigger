trigger TaskTrigger on Task (before insert,
before update,
before delete,
after insert,
after update,
after delete,
after undelete
) {

  TaskTriggerHandler handler = new TaskTriggerHandler(trigger.isExecuting, trigger.size);

switch on Trigger.operationType {
  when BEFORE_INSERT {
  }
  when BEFORE_UPDATE {
    handler.beforeUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
  }
  when BEFORE_DELETE {
  }
  when AFTER_INSERT {
  }
  when AFTER_UPDATE {
    handler.afterUpdate(trigger.old, trigger.new, trigger.oldMap, trigger.newMap);
  }
  when AFTER_DELETE {
  }
  when AFTER_UNDELETE {
  }
}

}
trigger AccountTrigger on Account(
  before insert,
  before update,
  before delete,
  after insert,
  after update,
  after delete,
  after undelete
) {

    AccountTriggerHandler handler = new AccountTriggerHandler(trigger.isExecuting, trigger.size);

  switch on Trigger.operationType {
    when BEFORE_INSERT {
    }
    when BEFORE_UPDATE {
    }
    when BEFORE_DELETE {
    }
    when AFTER_INSERT {
        handler.afterInsert(trigger.new, trigger.newMap);
    }
    when AFTER_UPDATE {
    }
    when AFTER_DELETE {
    }
    when AFTER_UNDELETE {
    }
  }

}
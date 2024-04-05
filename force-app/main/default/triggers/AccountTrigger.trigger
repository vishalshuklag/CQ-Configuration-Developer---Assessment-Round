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
    
    when AFTER_INSERT {
        handler.afterInsert(trigger.new, trigger.newMap);
    }
  }

}
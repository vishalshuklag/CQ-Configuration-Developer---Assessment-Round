public with sharing class AccountTriggerHandler {
    //Variables
    private boolean triggerIsExecuting;
    private integer triggerSize;
    
    //Parameterized Constructor
    public AccountTriggerHandler(boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    @SuppressWarnings('PMD.EmptyStatementBlock')
    public void beforeInsert(List<Account> newAccountsList) {

    }

    /**
     * @description This is invoked for the After insert context on Account sObject
     * @param newAccountsList trigger.new
     * @param newAccountsMap trigger.newMap
     */
    public void afterInsert(List<Account> newAccountsList, Map<Id, Account> newAccountsMap) {
        AccountHelper.createTaskForNewAccount(newAccountsList); // 
    }
}
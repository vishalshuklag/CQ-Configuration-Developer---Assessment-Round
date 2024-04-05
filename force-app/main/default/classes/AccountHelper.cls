/**
 * @description 
 * @author Vishal Shukla
 * @since 05/04/2024
 */
public with sharing class AccountHelper {
    
    /**
     * @description 
     * @param newAccounts 
     */
    @SuppressWarnings('PMD.ApexCRUDViolation')
    public static void createTaskForNewAccount(List<Account> newAccounts) {
       
        List<Task> taskList = new List<Task>();

        for (Account acc : newAccounts) {
          Task accountReviewTask = new Task();
          accountReviewTask.Subject = 'Review Account- ' + acc.AccountNumber; // Subject: Review Account- <Account Number>
          accountReviewTask.Status = 'Not Started'; // Status: Not Started
          accountReviewTask.WhatId = acc.Id; // Related To: New Account
          accountReviewTask.OwnerId = acc.OwnerId; // Assigned To: owner of the Account.   
          accountReviewTask.ActivityDate = Date.today() + 7; // Due Date: after a week
          taskList.add(accountReviewTask);

        }

        if (!taskList.isEmpty()) {
            Database.insert(taskList, false);
        }

    }
}
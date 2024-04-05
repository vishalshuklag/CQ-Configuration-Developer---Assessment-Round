/**
 * @description Test Class of AccountHelper Apex Class
 * @author 
 * @since 
 */
@IsTest
public with sharing class AccountHelper_Test {

    @testSetup
    private static void testSetup() {
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.AccountNumber = 'ACC012';

        insert testAccount;
    }
    
    @isTest
    private static void taskCreation_test() {
        // Test data setup
        List<Account> accountsList = [SELECT Id FROM Account];
        Test.startTest();
        AccountHelper.createTaskForNewAccount(accountsList);
        Test.stopTest();
    
        // Asserts
        List<Task> reviewTaskList = [SELECT Id, ActivityDate FROM Task WHERE WhatId = :accountsList.get(0).Id];
        System.assertEquals(2, reviewTaskList.size(), 'Review Task not created');
    }
}
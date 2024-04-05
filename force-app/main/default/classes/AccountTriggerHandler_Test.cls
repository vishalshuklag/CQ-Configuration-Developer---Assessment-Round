/**
 * @description Test Class of AccountTriggerHandler Apex Class
 * @author 
 * @since 
 */
@IsTest
public with sharing class AccountTriggerHandler_Test {
    
    @isTest
    private static void testCreateNewAccount() {
        // Test data setup
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        testAccount.AccountNumber = 'ACC012';
        // Actual test
        Test.startTest();
        insert testAccount;
        Test.stopTest();
    
        // Asserts
        List<Task> reviewTaskList = [SELECT Id, Subject, Status, ActivityDate FROM Task WHERE WhatId = :testAccount.Id];
        System.assertEquals(1, reviewTaskList.size(), 'Review Task not created');
        System.assertEquals('Review Account- ACC012', reviewTaskList.get(0)?.Subject, 'Subject is different');
    }
}